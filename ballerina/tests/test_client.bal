// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerinax/googleapis.gcalendar.mock as _;
import ballerina/os;
import ballerina/test;

configurable boolean isTestOnLiveServer = os:getEnv("IS_TEST_ON_LIVE_SERVER") == "true";

Client calendarClient = test:mock(Client);

configurable string mockClientId = ?;
configurable string mockClientSecret = ?;
configurable string mockRefreshToken = ?;
configurable string mockRefreshUrl = ?;

@test:BeforeSuite
function initializeClientsForCalendarServer () returns error? {
    if isTestOnLiveServer {
        calendarClient = check new({
            auth: {
                clientId: os:getEnv("CLIENT_ID"),
                clientSecret: os:getEnv("CLIENT_SECRET"),
                refreshToken: os:getEnv("REFRESH_TOKEN"),
                refreshUrl: os:getEnv("REFRESH_URL")
            }
        });
    } else {
        calendarClient = check new (
            {
                timeout: 100000,
                auth: {
                    refreshToken: mockRefreshToken,
                    clientId: mockClientId,
                    clientSecret: mockClientSecret,
                    refreshUrl: mockRefreshUrl
                }
            },
            serviceUrl = "http://localhost:9090/calendar/v3"
        );
    }
}

function verifyAndReturnId(string? id) returns string|error {
    if id is () {
        return error("id is nil");
    }
    return id;
}

@test:Config {}
function testCreateAndDeleteCalendar() returns error? {
    string summary = "Test Calendar 1";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClient->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);

    string id = check verifyAndReturnId(calendar.id);
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarGet() returns error? {
    string summary = "calendar summary";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    Calendar retrievedCal = check calendarClient->/calendars/[id].get();
    test:assertEquals(retrievedCal.summary, summary);
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarUpdate() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string newSummary = "Updated Test Calendar";
    createdCal.summary = newSummary;
    string id = check verifyAndReturnId(createdCal.id);
    Calendar updatedCal = check calendarClient->/calendars/[id].put(createdCal);
    test:assertEquals(updatedCal.summary, newSummary);
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarPatch() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string newSummary = "Patched Test Calendar";
    createdCal.summary = newSummary;
    string id = check verifyAndReturnId(createdCal.id);
    Calendar patchedCal = check calendarClient->/calendars/[id].patch(createdCal);
    test:assertEquals(patchedCal.summary, newSummary);
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarAclGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    Acl acl = check calendarClient->/calendars/[id]/acl.get();
    AclRule[]? aclRules = acl.items;
    if aclRules !is () {
        test:assertTrue(aclRules.length() > 0);
    }
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarEventsGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(event);
    test:assertEquals(createdEvent.summary, eventSummary);
    Events events = check calendarClient->/calendars/[id]/events.get();
    Event[]? eventItems = events.items;
    test:assertNotEquals(eventItems, ());
    string? eventId = createdEvent.id;
    test:assertTrue(createdEvent.id is string);
    if eventId is string {
        check calendarClient->/calendars/[id]/events/[eventId].delete();
    }
}

@test:Config {}
function testCalendarEventGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check calendarClient->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
}

@test:Config {}
function testCalendarEventCreate() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check calendarClient->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarEventUpdate() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    string newSummary = "Updated Test Event";
    createdEvent.summary = newSummary;
    Event updatedEvent = check calendarClient->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarEventPatch() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(event);
    string newSummary = "Patched Test Event";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event patchedEvent = check calendarClient->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarEventDelete() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testEventCreate() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    Event payload = {
        "start": {
            "dateTime": "2023-10-19T03:00:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "end": {
            "dateTime": "2023-10-19T03:30:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "summary": summary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(payload = payload);
    test:assertEquals(createdEvent.summary, summary);
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testEventImport() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    Event payload = {
        "start": {
            "dateTime": "2023-10-19T03:00:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "end": {
            "dateTime": "2023-10-19T03:30:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "summary": summary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(payload = payload);
    test:assertEquals(createdEvent.summary, summary);
    payload = {
        "iCalUID": id,
        "start": {
            "dateTime": "2023-10-19T03:00:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "end": {
            "dateTime": "2023-10-19T03:30:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "summary": summary
    };
    Event importedEvent = check calendarClient->/calendars/[id]/events/'import.post(payload);
    test:assertEquals(importedEvent.summary, summary);
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testEventUpdate() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    Event payload = {
        "start": {
            "dateTime": "2023-10-19T03:00:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "end": {
            "dateTime": "2023-10-19T03:30:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "summary": summary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(payload = payload);
    string newSummary = "Updated Test Meeting 110";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event updatedEvent = check calendarClient->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    test:assertEquals(updatedEvent.summary, newSummary);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
}

@test:Config {}
function testEventPatch() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    Event payload = {
        "start": {
            "dateTime": "2023-10-19T03:00:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "end": {
            "dateTime": "2023-10-19T03:30:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "summary": summary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(payload = payload);
    string newSummary = "Patched Test Meeting 110";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event patchedEvent = check calendarClient->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
}

@test:Config {}
function testEventGet() returns error? {
    string summary = "Test Event";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    Event payload = {
        "start": {
            "dateTime": "2023-10-19T03:00:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "end": {
            "dateTime": "2023-10-19T03:30:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "summary": summary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(payload = payload);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check calendarClient->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, summary);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
}

@test:Config {}
function testEventDelete() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    Event payload = {
        "start": {
            "dateTime": "2023-10-19T03:00:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "end": {
            "dateTime": "2023-10-19T03:30:00+05:30",
            "timeZone": "Asia/Colombo"
        },
        "summary": summary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(payload = payload);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
}

@test:Config {
    enable: false
}
function testPostCalendarAcl() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    json acl = {
        role: "owner",
        scope: {
            'type: "user",
            value: "user@example.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule res = check calendarClient->/calendars/[id]/acl.post(check acl.cloneWithType(AclRule));
    test:assertEquals(res.role, check acl.role);
    AclRule_scope? scope = res.scope;
    if scope is AclRule_scope {
        test:assertEquals(scope.value, check acl.scope.value);
        check calendarClient->/calendars/[id].delete();
    }
}

@test:Config {}
function testAclRuleCreate() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    AclRule aclRule = {
        id: id,
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule createdAclRule = check calendarClient->/calendars/[id]/acl.post(aclRule);
    Acl acl = check calendarClient->/calendars/[id]/acl.get();
    boolean aclRuleFound = false;
    AclRule[]? aclItems = acl.items;
    if aclItems != () {
        foreach AclRule acl_item in aclItems {
            if acl_item.id == createdAclRule.id {
                aclRuleFound = true;
                break;
            }
        }
    }
    test:assertTrue(aclRuleFound, "Retrieved ACL does not contain the created ACL rule");
    string aclRuleId = check verifyAndReturnId(createdAclRule.id);
    check calendarClient->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testAclRuleGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    AclRule aclRule = {
        id: id,
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule createdAclRule = check calendarClient->/calendars/[id]/acl.post(aclRule);
    test:assertEquals(createdAclRule.role, aclRule.role);
    string aclRuleId = check verifyAndReturnId(createdAclRule.id);
    AclRule getAclRule = check calendarClient->/calendars/[id]/acl/[aclRuleId].get();
    test:assertEquals(getAclRule.role, aclRule.role);
    check calendarClient->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testAclRuleUpdate() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    AclRule aclRule = {
        id: id,
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule createdAclRule = check calendarClient->/calendars/[id]/acl.post(aclRule);
    test:assertEquals(createdAclRule.role, aclRule.role);
    string aclRuleId = check verifyAndReturnId(createdAclRule.id);
    aclRule = {
        role: "writer",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule updateAclRule = check calendarClient->/calendars/[id]/acl/[aclRuleId].put(aclRule);
    test:assertEquals(updateAclRule.role, aclRule.role);
    check calendarClient->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testAclRulePatch() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    AclRule aclRule = {
        id: id,
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule createdAclRule = check calendarClient->/calendars/[id]/acl.post(aclRule);
    test:assertEquals(createdAclRule.role, aclRule.role);
    string aclRuleId = check verifyAndReturnId(createdAclRule.id);
    aclRule = {
        role: "writer",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule updateAclRule = check calendarClient->/calendars/[id]/acl/[aclRuleId].patch(aclRule);
    test:assertEquals(updateAclRule.role, aclRule.role);
    check calendarClient->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarEventInstancesGet() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Events instances = check calendarClient->/calendars/[id]/events/[eventId]/instances.get();
    test:assertNotEquals(instances.items, ());
    check calendarClient->/calendars/[id]/events/[eventId].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {
    enable: false
}
function testCalendarEventMove() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string summary2 = "Test Calendar 2";
    Calendar cal2 = {
        summary: summary2
    };
    Calendar createdCal2 = check calendarClient->/calendars.post(cal2);
    string eventSummary = "Test Event";
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: eventSummary
    };
    string calId = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[calId]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    string calId2 = check verifyAndReturnId(createdCal2.id);
    Event moveEvent = check calendarClient->/calendars/[calId]/events/[eventId]/move.post(destination = calId2);
    test:assertEquals(moveEvent.summary, eventSummary);
    check calendarClient->/calendars/[calId2]/events/[eventId].delete();
    check calendarClient->/calendars/[calId2].delete();
    check calendarClient->/calendars/[calId].delete();
}

@test:Config {}
function testCalendarFromListDelete() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCalendar = check calendarClient->/calendars.post(cal);
    CalendarListEntry response = check calendarClient->/users/me/calendarList.post({id: createdCalendar.id});
    test:assertEquals(response.id, createdCalendar.id);
    string id = check verifyAndReturnId(createdCalendar.id);
    check calendarClient->/users/me/calendarList/[id].delete();
    check calendarClient->/calendars/[id].delete();
}

@test:Config {}
function testCalendarListEntryPatch() returns error? {
    
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClient->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        summary: summary,
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check calendarClient->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    CalendarListEntry updatedEntry = check calendarClient->/users/me/calendarList/[updateId].patch(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);
    check calendarClient->/users/me/calendarList/[updateId].delete();
}

@test:Config {}
function testPostCalendarList() returns error? {
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClient->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        summary: summary,
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check calendarClient->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    check calendarClient->/users/me/calendarList/[updateId].delete();
}

@test:Config {}
function testCalendarListEntryGet() returns error? {
    string summary = "Calendar Summary";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClient->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry createdCalendarListEntry = check calendarClient->/users/me/calendarList.post(calendarListEntry);
    string id = check verifyAndReturnId(createdCalendarListEntry.id);
    CalendarListEntry retrievedCalendarListEntry = check calendarClient->/users/me/calendarList/[id].get();
    test:assertEquals(retrievedCalendarListEntry.summary, summary);
    check calendarClient->/users/me/calendarList/[id].delete();
}

@test:Config {}
function testCalendarListEntryUpdate() returns error? {
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClient->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        summary: summary,
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check calendarClient->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    CalendarListEntry updatedEntry = check calendarClient->/users/me/calendarList/[updateId].put(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);
    check calendarClient->/users/me/calendarList/[updateId].delete();
}

@test:Config {}
function testCalendarListGet() returns error? {
    
    CalendarList calendarList = check calendarClient->/users/me/calendarList.get();
    test:assertNotEquals(calendarList, ());
    CalendarListEntry[]? calendarListEntries = calendarList.items;
    test:assertTrue(calendarListEntries is () || calendarListEntries.length() > 0);
}

@test:Config {}
function testColorsGet() returns error? {
    
    Colors colors = check calendarClient->/colors.get();
    test:assertNotEquals(colors.calendar, ());
    test:assertNotEquals(colors.event, ());
    test:assertEquals(colors.kind, "calendar#colors");
}

@test:Config {}
function testFreeBusy() returns error? {
    
    FreeBusyRequest freeBusyRequest = {
        timeMin: "2022-01-01T00:00:00Z",
        timeMax: "2022-01-02T00:00:00Z",
        timeZone: "UTC",
        items: [
            {
                id: "primary"
            }
        ]
    };
    FreeBusyResponse freeBusyResponse = check calendarClient->/freeBusy.post(freeBusyRequest);
    test:assertNotEquals(freeBusyResponse.kind, ());
    test:assertNotEquals(freeBusyResponse.calendars, ());
}

@test:Config {}
function testCalendarEventQuickAdd() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClient->/calendars.post(cal);
    string eventText = "Event created using quickAdd";
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClient->/calendars/[id]/events/quickAdd.post(text = eventText);
    test:assertEquals(createdEvent.summary, eventText);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check calendarClient->/calendars/[id]/events/[eventId].delete();
    check calendarClient->/calendars/[id].delete();
}
