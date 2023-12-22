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

Client calendarClientForMockServer = test:mock(Client);

configurable string mockClientId = ?;
configurable string mockClientSecret = ?;
configurable string mockRefreshToken = ?;
configurable string mockRefreshUrl = ?;

@test:BeforeSuite
function initializeClientsForCalendarServer () returns error? {
    if isTestOnLiveServer {
        calendarClientForMockServer = check new({
            auth: {
                clientId: os:getEnv("CLIENT_ID"),
                clientSecret: os:getEnv("CLIENT_SECRET"),
                refreshToken: os:getEnv("REFRESH_TOKEN"),
                refreshUrl: os:getEnv("REFRESH_URL")
            }
        });
    } else {
        calendarClientForMockServer = check new (
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

@test:Config {
    groups: ["mock", "live"]
}
function testCreateAndDeleteCalendar() returns error? {
    string summary = "Test Calendar 1";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClientForMockServer->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);

    string id = check verifyAndReturnId(calendar.id);
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock"]
}
function testGetCalendar() returns error? {
    string id = "default-calendar-id";
    Calendar retrievedCal = check calendarClientForMockServer->/calendars/[id].get();
    test:assertEquals(retrievedCal.id, id);
}

@test:Config {
    groups: ["live"]
}
function testCalendarGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    Calendar retrievedCal = check calendarClientForMockServer->/calendars/[id].get();
    test:assertEquals(retrievedCal.summary, summary);
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock"]
}
function testCalendarUpdate() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    string newSummary = "Updated Test Calendar";
    createdCal.summary = newSummary;
    string id = check verifyAndReturnId(createdCal.id);
    Calendar updatedCal = check calendarClientForMockServer->/calendars/[id].put(createdCal);
    test:assertEquals(updatedCal.summary, newSummary);
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarPatch() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    string newSummary = "Patched Test Calendar";
    createdCal.summary = newSummary;
    string id = check verifyAndReturnId(createdCal.id);
    Calendar patchedCal = check calendarClientForMockServer->/calendars/[id].patch(createdCal);
    test:assertEquals(patchedCal.summary, newSummary);
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock"]
}
function testGetCalendarAcl() returns error? {
    string aclId = "default-acl-id";
    Acl acl = check calendarClientForMockServer->/calendars/[aclId]/acl.get();
    test:assertEquals(acl.kind, "calendar#acl");
}

@test:Config {
    groups: ["live"]
}
function testCalendarAclGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    Acl acl = check calendarClientForMockServer->/calendars/[id]/acl.get();
    AclRule[]? aclRules = acl.items;
    if aclRules !is () {
        test:assertTrue(aclRules.length() > 0);
    }
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarEventsGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    test:assertEquals(createdEvent.summary, eventSummary);
    Events events = check calendarClientForMockServer->/calendars/[id]/events.get();
    Event[]? eventItems = events.items;
    test:assertNotEquals(eventItems, ());
    string? eventId = createdEvent.id;
    test:assertTrue(createdEvent.id is string);
    if eventId is string {
        check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    }
}

@test:Config {
    groups: ["mock"]
}
function testGetCalendarEvent() returns error? {
    string id = "default-calendar-id";
    string eventId = "default-event-id";
    Event retrievedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.id, eventId);
}

@test:Config {
    groups: ["live"]
}
function testCalendarEventGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
}

@test:Config {
    groups: ["mock"]
}
function testCreateCalendarEvent() returns error? {
    Event event = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: "Test Event"
    };
    string id = "default-calendar-id";
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    test:assertEquals(createdEvent.id, id);
}

@test:Config {
    groups: ["live"]
}
function testCalendarEventCreate() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarEventUpdate() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    string newSummary = "Updated Test Event";
    createdEvent.summary = newSummary;
    Event updatedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarEventPatch() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    string newSummary = "Patched Test Event";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event patchedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarEventDelete() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testEventCreate() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(payload = payload);
    test:assertEquals(createdEvent.summary, summary);
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testEventImport() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(payload = payload);
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
    Event importedEvent = check calendarClientForMockServer->/calendars/[id]/events/'import.post(payload);
    test:assertEquals(importedEvent.summary, summary);
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testEventUpdate() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(payload = payload);
    string newSummary = "Updated Test Meeting 110";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event updatedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    test:assertEquals(updatedEvent.summary, newSummary);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testEventPatch() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(payload = payload);
    string newSummary = "Patched Test Meeting 110";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event patchedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
}

@test:Config {
    groups: ["live"]
}
function testEventGet() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(payload = payload);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, summary);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
}

@test:Config {
    groups: ["mock"]
}
function testGetEvent() returns error? {
    string id = "default-calendar-id";
    string eventId = "default-event-id";
    Event retrievedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.id, eventId);
}

@test:Config {
    groups: ["mock", "live"]
}
function testEventDelete() returns error? {
    
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(payload = payload);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testPostCalendarAcl() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    json acl = {
        role: "owner",
        scope: {
            'type: "user",
            value: "user@example.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule res = check calendarClientForMockServer->/calendars/[id]/acl.post(check acl.cloneWithType(AclRule));
    test:assertEquals(res.role, check acl.role);
    AclRule_scope? scope = res.scope;
    if scope is AclRule_scope {
        test:assertEquals(scope.value, check acl.scope.value);
        check calendarClientForMockServer->/calendars/[id].delete();
    }
}

@test:Config {
    groups: ["live"]
}
function testAclRuleCreate() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule createdAclRule = check calendarClientForMockServer->/calendars/[id]/acl.post(aclRule);
    Acl acl = check calendarClientForMockServer->/calendars/[id]/acl.get();
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
    check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock"]
}
function testGetAclRule() returns error? {
    string id = "default-calendar-id";
    string aclRuleId = "default-calendar-id";
    AclRule getAclRule = check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].get();
    test:assertEquals(getAclRule.id, aclRuleId);
}

@test:Config {
    groups: ["live"]
}
function testAclRuleGet() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule createdAclRule = check calendarClientForMockServer->/calendars/[id]/acl.post(aclRule);
    test:assertEquals(createdAclRule.role, aclRule.role);
    string aclRuleId = check verifyAndReturnId(createdAclRule.id);
    AclRule getAclRule = check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].get();
    test:assertEquals(getAclRule.role, aclRule.role);
    check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["live"]
}
function testAclRuleUpdate() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule createdAclRule = check calendarClientForMockServer->/calendars/[id]/acl.post(aclRule);
    test:assertEquals(createdAclRule.role, aclRule.role);
    string aclRuleId = check verifyAndReturnId(createdAclRule.id);
    aclRule = {
        role: "writer",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule updateAclRule = check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].put(aclRule);
    test:assertEquals(updateAclRule.role, aclRule.role);
    check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["live"]
}
function testUpdateAclRule() returns error? {
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    string id = "default-calendar-id";
    string aclRuleId = "default-acl-id";
    aclRule = {
        role: "writer",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule updateAclRule = check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].put(aclRule);
    test:assertEquals(updateAclRule.role, aclRule.role);
}

@test:Config {
    groups: ["mock"]
}
function testPatchAclRule() returns error? {
    string role = "reader";
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    string id = "default-calendar-id";
    string aclRuleId = "default-acl-id";
    aclRule.role = role;
    AclRule updateAclRule = check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].patch(aclRule);
    test:assertEquals(updateAclRule.role, role);
}

@test:Config {
    groups: ["live"]
}
function testAclRulePatch() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule createdAclRule = check calendarClientForMockServer->/calendars/[id]/acl.post(aclRule);
    test:assertEquals(createdAclRule.role, aclRule.role);
    string aclRuleId = check verifyAndReturnId(createdAclRule.id);
    aclRule = {
        role: "writer",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule updateAclRule = check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].patch(aclRule);
    test:assertEquals(updateAclRule.role, aclRule.role);
    check calendarClientForMockServer->/calendars/[id]/acl/[aclRuleId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarEventInstancesGet() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Events instances = check calendarClientForMockServer->/calendars/[id]/events/[eventId]/instances.get();
    test:assertNotEquals(instances.items, ());
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock"]
}
function testMoveCalendarEvent() returns error? {
    string calId = "default-calendar-id";
    string calId2 = "default-calendar-id2";
    string eventId = "default-event-id";
    Event moveEvent = check calendarClientForMockServer->/calendars/[calId]/events/[eventId]/move.post(calId2);
    test:assertEquals(moveEvent.iCalUID, calId2);
}

@test:Config {
    groups: ["live"]
}
function testCalendarEventMove() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    string summary2 = "Test Calendar 2";
    Calendar cal2 = {
        summary: summary2
    };
    Calendar createdCal2 = check calendarClientForMockServer->/calendars.post(cal2);
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
    Event createdEvent = check calendarClientForMockServer->/calendars/[calId]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    string calId2 = check verifyAndReturnId(createdCal2.id);
    Event moveEvent = check calendarClientForMockServer->/calendars/[calId]/events/[eventId]/move.post(calId2);
    test:assertEquals(moveEvent.summary, eventSummary);
    check calendarClientForMockServer->/calendars/[calId2]/events/[eventId].delete();
    check calendarClientForMockServer->/calendars/[calId2].delete();
    check calendarClientForMockServer->/calendars/[calId].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarFromListDelete() returns error? {
    
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCalendar = check calendarClientForMockServer->/calendars.post(cal);
    CalendarListEntry response = check calendarClientForMockServer->/users/me/calendarList.post({id: createdCalendar.id});
    test:assertEquals(response.id, createdCalendar.id);
    string id = check verifyAndReturnId(createdCalendar.id);
    check calendarClientForMockServer->/users/me/calendarList/[id].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["live"]
}
function testCalendarListEntryPatch() returns error? {
    
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClientForMockServer->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check calendarClientForMockServer->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    CalendarListEntry updatedEntry = check calendarClientForMockServer->/users/me/calendarList/[updateId].patch(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);
    check calendarClientForMockServer->/users/me/calendarList/[updateId].delete();
}

@test:Config {
    groups: ["mock"]
}
function testCreateCalendarList() returns error? {
    string id = "default-calendar-id";
    CalendarListEntry calendarListEntry = {
        id: id
    };
    CalendarListEntry calendarUpdate = check calendarClientForMockServer->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.id, id);
}

@test:Config {
    groups: ["live"]
}
function testPostCalendarList() returns error? {
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClientForMockServer->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check calendarClientForMockServer->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    check calendarClientForMockServer->/users/me/calendarList/[updateId].delete();
}

@test:Config {
    groups: ["live"]
}
function testCalendarListEntryGet() returns error? {
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClientForMockServer->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry createdCalendarListEntry = check calendarClientForMockServer->/users/me/calendarList.post(calendarListEntry);
    string id = check verifyAndReturnId(createdCalendarListEntry.id);
    CalendarListEntry retrievedCalendarListEntry = check calendarClientForMockServer->/users/me/calendarList/[id].get();
    test:assertEquals(retrievedCalendarListEntry.summary, summary);
    check calendarClientForMockServer->/users/me/calendarList/[id].delete();
}

@test:Config {
    groups: ["mock"]
}
function testUpdateCalendarListEntry() returns error? {
    string id = "default-calendar-id";
    string updateId = "default-calendar-id2";
    CalendarListEntry calendarListEntry = {
        id: id
    };
    calendarListEntry.id = updateId;
    CalendarListEntry updatedEntry = check calendarClientForMockServer->/users/me/calendarList/[id].put(calendarListEntry);
    test:assertEquals(updatedEntry.id, updateId);
}

@test:Config {
    groups: ["live"]
}
function testCalendarListEntryUpdate() returns error? {
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check calendarClientForMockServer->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check calendarClientForMockServer->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    CalendarListEntry updatedEntry = check calendarClientForMockServer->/users/me/calendarList/[updateId].put(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);
    check calendarClientForMockServer->/users/me/calendarList/[updateId].delete();
}

@test:Config {
    groups: ["mock", "live"]
}
function testCalendarListGet() returns error? {
    
    CalendarList calendarList = check calendarClientForMockServer->/users/me/calendarList.get();
    test:assertNotEquals(calendarList, ());
    CalendarListEntry[]? calendarListEntries = calendarList.items;
    test:assertTrue(calendarListEntries is () || calendarListEntries.length() > 0);
}

@test:Config {
    groups: ["mock", "live"]
}
function testColorsGet() returns error? {
    
    Colors colors = check calendarClientForMockServer->/colors.get();
    test:assertNotEquals(colors.calendar, ());
    test:assertNotEquals(colors.event, ());
    test:assertEquals(colors.kind, "calendar#colors");
}

@test:Config {
    groups: ["mock", "live"]
}
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
    FreeBusyResponse freeBusyResponse = check calendarClientForMockServer->/freeBusy.post(freeBusyRequest);
    test:assertNotEquals(freeBusyResponse.kind, ());
    test:assertNotEquals(freeBusyResponse.calendars, ());
}

@test:Config {
    groups: ["mock"]
}
function testCreateCalendarEventQuickAdd() returns error? {
    string id = "default-calendar-id";
    string eventText = "Event created using quickAdd";
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events/quickAdd.post(eventText);
    test:assertEquals(createdEvent.summary, eventText);
}

@test:Config {
    groups: ["live"]
}
function testCalendarEventQuickAdd() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check calendarClientForMockServer->/calendars.post(cal);
    string eventText = "Event created using quickAdd";
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check calendarClientForMockServer->/calendars/[id]/events/quickAdd.post(eventText);
    test:assertEquals(createdEvent.summary, eventText);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    check calendarClientForMockServer->/calendars/[id].delete();
}

@test:Config {
    groups: ["mock"]
}
function testPatchCalendarListEntry() returns error? {
    string id = "default-calendar-id";
    CalendarListEntry calendarListEntry = {
        id: id
    };
    string updateId = "default-calendar-id2";
    calendarListEntry.id = updateId;
    CalendarListEntry updatedEntry = check calendarClientForMockServer->/users/me/calendarList/[id].patch(calendarListEntry);
    test:assertEquals(updatedEntry.id, updateId);
}
