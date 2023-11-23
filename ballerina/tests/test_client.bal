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

import ballerina/test;
import ballerina/os;

configurable string clientId = os:getEnv("CLIENT_ID");
configurable string clientSecret = os:getEnv("CLIENT_SECRET");
configurable string refreshToken = os:getEnv("REFRESH_TOKEN");
configurable string refreshUrl = os:getEnv("REFRESH_URL");

ConnectionConfig config = {
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
};

function verifyAndReturnId(string? id) returns string|error {
  if id is () {
    return error("id is nil");
  }
  return id;
}

@test:Config {}
function testCreateAndDeleteCalendar() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar 1";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check client1->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);

    string id = check verifyAndReturnId(calendar.id);
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testGetCalendar() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    Calendar retrievedCal = check client1->/calendars/[id].get();
    test:assertEquals(retrievedCal.summary, summary);
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testUpdateCalendar() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string newSummary = "Updated Test Calendar";
    createdCal.summary = newSummary;
    string id = check verifyAndReturnId(createdCal.id);
    Calendar updatedCal = check client1->/calendars/[id].put(createdCal);
    test:assertEquals(updatedCal.summary, newSummary);
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testPatchCalendar() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string newSummary = "Patched Test Calendar";
    createdCal.summary = newSummary;
    string id = check verifyAndReturnId(createdCal.id);
    Calendar patchedCal = check client1->/calendars/[id].patch(createdCal);
    test:assertEquals(patchedCal.summary, newSummary);
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testGetCalendarAcl() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string id = check verifyAndReturnId(createdCal.id);
    Acl acl = check client1->/calendars/[id]/acl.get();
    AclRule[]? aclRules = acl.items;
    if aclRules !is () {
        test:assertTrue(aclRules.length() > 0);
    }
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testGetCalendarEvents() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(event);
    test:assertEquals(createdEvent.summary, eventSummary);
    Events events = check client1->/calendars/[id]/events.get();
    Event[]? eventItems = events.items;
    test:assertNotEquals(eventItems, ());
    string? eventId = createdEvent.id;
    test:assertTrue(createdEvent.id is string);
    if eventId is string {
        check client1->/calendars/[id]/events/[eventId].delete();
    }
}

@test:Config{}
function testGetCalendarEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check client1->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    check client1->/calendars/[id]/events/[eventId].delete();
}

@test:Config{}
function testCreateCalendarEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check client1->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    check client1->/calendars/[id]/events/[eventId].delete();
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testUpdateCalendarEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    string newSummary = "Updated Test Event";
    createdEvent.summary = newSummary;
    Event updatedEvent = check client1->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    check client1->/calendars/[id]/events/[eventId].delete();
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testPatchCalendarEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(event);
    string newSummary = "Patched Test Event";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event patchedEvent = check client1->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    check client1->/calendars/[id]/events/[eventId].delete();
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testDeleteCalendarEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check client1->/calendars/[id]/events/[eventId].delete();
    check client1->/calendars/[id].delete();
}

@test:Config {}
function testCreateEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(payload = payload);
    test:assertEquals(createdEvent.summary, summary);
    check client1->/calendars/[id].delete();
}

@test:Config {}
function testUpdateEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(payload = payload);
    string newSummary = "Updated Test Meeting 110";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event updatedEvent = check client1->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    test:assertEquals(updatedEvent.summary, newSummary);
    check client1->/calendars/[id]/events/[eventId].delete();
}

@test:Config {}
function testPatchEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(payload = payload);
    string newSummary = "Patched Test Meeting 110";
    createdEvent.summary = newSummary;
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event patchedEvent = check client1->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    check client1->/calendars/[id]/events/[eventId].delete();
}

@test:Config {}
function testGetEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(payload = payload);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Event retrievedEvent = check client1->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.summary, summary);
    check client1->/calendars/[id]/events/[eventId].delete();
}

@test:Config {}
function testDeleteEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Meeting 110";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(payload = payload);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check client1->/calendars/[id]/events/[eventId].delete();
}

@test:Config{}
function testPostCalendarAcl() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    json acl = {
        role: "owner",
        scope: {
            'type: "user",
            value: "user@example.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule res = check client1->/calendars/[id]/acl.post(check acl.cloneWithType(AclRule));
    test:assertEquals(res.role, check acl.role);
    AclRule_scope? scope = res.scope;
    if scope is AclRule_scope {
        test:assertEquals(scope.value, check acl.scope.value);
        check client1->/calendars/[id].delete();
    }
}

@test:Config{}
function testCreateAclRule() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    string id = check verifyAndReturnId(createdCal.id);
    AclRule createdAclRule = check client1->/calendars/[id]/acl.post(aclRule);
    Acl acl = check client1->/calendars/[id]/acl.get();
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
    check client1->/calendars/[id]/acl/[aclRuleId].delete();
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testGetCalendarEventInstances() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
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
    Event createdEvent = check client1->/calendars/[id]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    Events instances = check client1->/calendars/[id]/events/[eventId]/instances.get();
    test:assertNotEquals(instances.items, ());
    check client1->/calendars/[id]/events/[eventId].delete();
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testMoveCalendarEvent() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string summary2 = "Test Calendar 2";
    Calendar cal2 = {
        summary: summary2
    };
    Calendar createdCal2 = check client1->/calendars.post(cal2);
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
    Event createdEvent = check client1->/calendars/[calId]/events.post(event);
    string eventId = check verifyAndReturnId(createdEvent.id);
    string calId2 = check verifyAndReturnId(createdCal2.id);
    Event moveEvent = check client1->/calendars/[calId]/events/[eventId]/move.post(calId2);
    test:assertEquals(moveEvent.summary, eventSummary);
    check client1->/calendars/[calId2]/events/[eventId].delete();
    check client1->/calendars/[calId2].delete();
    check client1->/calendars/[calId].delete();
}

@test:Config {}
function testDeleteCalendarFromList() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCalendar = check client1->/calendars.post(cal);
    CalendarListEntry response = check client1->/users/me/calendarList.post({id: createdCalendar.id});
    test:assertEquals(response.id, createdCalendar.id);
    string id = check verifyAndReturnId(createdCalendar.id);
    check client1->/users/me/calendarList/[id].delete();
    check client1->/calendars/[id].delete();
}

@test:Config{}
function testPatchCalendarListEntry() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check client1->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check client1->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    CalendarListEntry updatedEntry = check client1->/users/me/calendarList/[updateId].patch(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);
    check client1->/users/me/calendarList/[updateId].delete();
}

@test:Config {}
function testPostCalendarList() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check client1->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check client1->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    check client1->/users/me/calendarList/[updateId].delete();
}

@test:Config {}
function testGetCalendarListEntry() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check client1->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry createdCalendarListEntry = check client1->/users/me/calendarList.post(calendarListEntry);
    string id = check verifyAndReturnId(createdCalendarListEntry.id);
    CalendarListEntry retrievedCalendarListEntry = check client1->/users/me/calendarList/[id].get();
    test:assertEquals(retrievedCalendarListEntry.summary, summary);
    check client1->/users/me/calendarList/[id].delete();
}

@test:Config{}
function testUpdateCalendarListEntry() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar List Entry";
    Calendar cal = {
        summary: summary
    };
    Calendar calendar = check client1->/calendars.post(cal);
    test:assertEquals(calendar.summary, summary);
    CalendarListEntry calendarListEntry = {
        id: calendar.id
    };
    CalendarListEntry calendarUpdate = check client1->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(calendarUpdate.summary, summary);
    string updateId = check verifyAndReturnId(calendarUpdate.id);
    CalendarListEntry updatedEntry = check client1->/users/me/calendarList/[updateId].put(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);
    check client1->/users/me/calendarList/[updateId].delete();
}

@test:Config{}
function testGetCalendarList() returns error?  {
    Client client1 = check new(config);
    CalendarList calendarList = check client1->/users/me/calendarList.get();
    test:assertNotEquals(calendarList, ());
    CalendarListEntry[]? calendarListEntries = calendarList.items;
    test:assertTrue(calendarListEntries is () || calendarListEntries.length() > 0);
}

@test:Config {}
function testGetColors() returns error?  {
    Client client1 = check new(config);
    Colors colors = check client1->/colors.get();
    test:assertNotEquals(colors.calendar, ());
    test:assertNotEquals(colors.event, ());
    test:assertEquals(colors.kind, "calendar#colors");
}

@test:Config {}
function testFreeBusy() returns error?  {
    Client client1 = check new(config);
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
    FreeBusyResponse freeBusyResponse = check client1->/freeBusy.post(freeBusyRequest);
    test:assertNotEquals(freeBusyResponse.kind, ());
    test:assertNotEquals(freeBusyResponse.calendars, ());
}

@test:Config{}
function testCreateCalendarEventQuickAdd() returns error?  {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string eventText = "Event created using quickAdd";
    string id = check verifyAndReturnId(createdCal.id);
    Event createdEvent = check client1->/calendars/[id]/events/quickAdd.post(eventText);
    test:assertEquals(createdEvent.summary, eventText);
    string eventId = check verifyAndReturnId(createdEvent.id);
    check client1->/calendars/[id]/events/[eventId].delete();
    check client1->/calendars/[id].delete();
}
