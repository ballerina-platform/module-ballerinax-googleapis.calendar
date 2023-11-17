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
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

@test:Config {}
function testCreateAndDeleteCalendar() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar 1";
    Calendar cal = {
        summary: summary
    };
    Calendar unionResult = check client1->/calendars.post(cal);
    test:assertEquals(unionResult.summary, summary);

    Error? res = check client1->/calendars/[<string>unionResult.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testGetCalendar() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    Calendar retrievedCal = check client1->/calendars/[<string>createdCal.id].get();
    test:assertEquals(retrievedCal.summary, summary);
    Error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testUpdateCalendar() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string newSummary = "Updated Test Calendar";
    createdCal.summary = newSummary;
    Calendar updatedCal = check client1->/calendars/[<string>createdCal.id].put(createdCal);
    test:assertEquals(updatedCal.summary, newSummary);
    Error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testPatchCalendar() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string newSummary = "Patched Test Calendar";
    createdCal.summary = newSummary;
    Calendar patchedCal = check client1->/calendars/[<string>createdCal.id].patch(createdCal);
    test:assertEquals(patchedCal.summary, newSummary);
    Error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testGetCalendarAcl() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    Acl acl = check client1->/calendars/[<string>createdCal.id]/acl.get();
    AclRule[]? aclRules = acl.items;
    if aclRules !is () {
        test:assertTrue(aclRules.length() > 0);
    }
    Error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testGetCalendarEvents() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    test:assertEquals(createdEvent.summary, eventSummary);
    Events events = check client1->/calendars/[<string>createdCal.id]/events.get();
    Event[]? eventItems = events.items;
    test:assertNotEquals(eventItems, ());
    Error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testGetCalendarEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    Event retrievedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testCreateCalendarEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    Event retrievedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].get();
    test:assertEquals(retrievedEvent.summary, eventSummary);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testUpdateCalendarEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    string newSummary = "Updated Test Event";
    createdEvent.summary = newSummary;
    Event updatedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testPatchCalendarEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    string newSummary = "Patched Test Event";
    createdEvent.summary = newSummary;
    Event patchedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testDeleteCalendarEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config {}
function testCreateEvent() returns error? {
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
    Event unionResult = check client1->/calendars/[<string>createdCal.id]/events.post(payload = payload);
    test:assertEquals(unionResult.summary, summary);
}

@test:Config {}
function testUpdateEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(payload = payload);

    string newSummary = "Updated Test Meeting 110";
    createdEvent.summary = newSummary;
    Event updatedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
    test:assertEquals(updatedEvent.summary, newSummary);

    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

@test:Config {}
function testPatchEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(payload = payload);
    string newSummary = "Patched Test Meeting 110";
    createdEvent.summary = newSummary;
    Event patchedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

@test:Config {}
function testGetEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(payload = payload);
    Event retrievedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].get();
    test:assertEquals(retrievedEvent.summary, summary);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

@test:Config {}
function testDeleteEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(payload = payload);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testPostCalendarAcl() returns error? {
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
    AclRule res = check client1->/calendars/[<string>createdCal.id]/acl.post(check acl.cloneWithType(AclRule));
    test:assertEquals(res.role, check acl.role);
    test:assertEquals((<AclRule_scope>res.scope).value, check acl.scope.value);
    error? delRes = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(delRes, ());
}

@test:Config{}
function testCreateAclRule() returns error? {
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
    AclRule createdAclRule = check client1->/calendars/[<string>createdCal.id]/acl.post(aclRule);
    Acl acl = check client1->/calendars/[<string>createdCal.id]/acl.get();
    boolean aclRuleFound = false;
    AclRule[]? aclItems = acl.items;
    if aclItems != () {
        foreach AclRule acl_item in aclItems {
            if (acl_item.id == createdAclRule.id) {
                aclRuleFound = true;
                break;
            }
        }
    }
    test:assertTrue(aclRuleFound, "Retrieved ACL does not contain the created ACL rule");
    Error? res = check client1->/calendars/[<string>createdCal.id]/acl/[<string>createdAclRule.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testGetCalendarEventInstances() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    Events instances = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id]/instances.get();
    test:assertNotEquals(instances.items, ());
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testMoveCalendarEvent() returns error? {
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
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);
    Event moveEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id]/move.post(<string>createdCal2.id);
    test:assertEquals(moveEvent.summary, eventSummary);
    Error? res = check client1->/calendars/[<string>createdCal2.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal2.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

@test:Config {}
function testDeleteCalendarFromList() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };

    Calendar createdCalendar = check client1->/calendars.post(cal);
    CalendarListEntry response = check client1->/users/me/calendarList.post({id: createdCalendar.id});
    test:assertEquals(response.id, createdCalendar.id);
    Error? res = check client1->/users/me/calendarList/[<string>createdCalendar.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCalendar.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testPatchCalendarListEntry() returns error? {
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

    CalendarListEntry updatedEntry = check client1->/users/me/calendarList/[<string>calendarUpdate.id].patch(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);

    Error? res = check client1->/users/me/calendarList/[<string>calendarUpdate.id].delete();
    test:assertEquals(res, ());
}

@test:Config {}
function testPostCalendarList() returns error? {
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

    Error? res = check client1->/users/me/calendarList/[<string>calendarUpdate.id].delete();
    test:assertEquals(res, ());
}

@test:Config {}
function testGetCalendarListEntry() returns error? {
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
    CalendarListEntry retrievedCalendarListEntry = check client1->/users/me/calendarList/[<string>createdCalendarListEntry.id].get();
    test:assertEquals(retrievedCalendarListEntry.summary, summary);
    Error? res = check client1->/users/me/calendarList/[<string>createdCalendarListEntry.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testUpdateCalendarListEntry() returns error? {
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

    CalendarListEntry updatedEntry = check client1->/users/me/calendarList/[<string>calendarUpdate.id].put(calendarListEntry);
    test:assertEquals(updatedEntry.id, calendarUpdate.id);

    Error? res = check client1->/users/me/calendarList/[<string>calendarUpdate.id].delete();
    test:assertEquals(res, ());
}

@test:Config{}
function testGetCalendarList() returns error? {
    Client client1 = check new(config);
    CalendarList calendarList = check client1->/users/me/calendarList.get();
    test:assertNotEquals(calendarList, ());
    CalendarListEntry[]? calendarListEntries = calendarList.items;
    if calendarListEntries !is () {
        test:assertTrue(calendarListEntries.length() > 0);
    }
}

@test:Config {}
function testGetColors() returns error? {
    Client client1 = check new(config);
    Colors colors = check client1->/colors.get();
    test:assertNotEquals(colors.calendar, ());
    test:assertNotEquals(colors.event, ());
    test:assertEquals(colors.kind, "calendar#colors");
}

@test:Config {}
function testFreeBusy() returns error? {
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
function testCreateCalendarEventQuickAdd() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);
    string eventText = "Event created using quickAdd";
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events/quickAdd.post(eventText);
    test:assertEquals(createdEvent.summary, eventText);
    Error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}
