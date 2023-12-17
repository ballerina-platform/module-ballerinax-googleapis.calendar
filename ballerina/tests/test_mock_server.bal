import ballerina/log;
import ballerina/test;
// Copyright (c) 2023, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerinax/googleapis.calendar.mock as _;

Client calendarClientForMockServer = test:mock(Client);

configurable string mockClientId = ?;
configurable string mockClientSecret = ?;
configurable string mockRefreshToken = ?;
configurable string mockRefreshUrl = ?;

@test:BeforeSuite
function initializeClientsForMockServer() returns error? {
    log:printInfo("Initializing client for mock server");
    calendarClientForMockServer = check new ({
            timeout: 100000,
            auth: {
                refreshToken: mockRefreshToken,
                clientId: mockClientId,
                clientSecret: mockClientSecret,
                refreshUrl: mockRefreshToken
            }
        },
        serviceUrl = "http://localhost:9090/calendar/v3"
    );
}

@test:Config {
    groups: ["mock"]
}
function testCreateCalendar() returns error? {
    string summary = "Test Calendar";
    Calendar calendar = {
        summary: summary,
        timeZone: "Asia/Colombo"
    };
    Calendar response = check calendarClientForMockServer->/calendars.post(calendar);
    test:assertEquals(response.summary, summary);
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
    groups: ["mock"]
}
function testUpdateCalendar() returns error? {
    Calendar createdCal = {
        summary: "Test Calendar"
    };
    string newSummary = "Updated Test Calendar";
    createdCal.summary = newSummary;
    string id = "default-calendar-id";
    Calendar updatedCal = check calendarClientForMockServer->/calendars/[id].put(createdCal);
    test:assertEquals(updatedCal.summary, newSummary);
}

@test:Config {
    groups: ["mock"]
}
function testDeleteCalendar() returns error? {
    string id = "default-calendar-id";
    Error? deleteRes = calendarClientForMockServer->/calendars/[id].delete();
    test:assertEquals(deleteRes, ());
}

@test:Config {
    groups: ["mock"]
}
function testPatchCalendar() returns error? {
    string summary = "Test Calendar";
    Calendar createdCal = {
        summary: summary
    };
    string newSummary = "Patched Test Calendar";
    createdCal.summary = newSummary;
    string id = "default-calendar-id";
    Calendar patchedCal = check calendarClientForMockServer->/calendars/[id].patch(createdCal);
    test:assertEquals(patchedCal.summary, newSummary);
}

@test:Config {
    groups: ["mock"]
}
function testGetCalendarEvents() returns error? {
    string id = "default-calendar-id";
    Events events = check calendarClientForMockServer->/calendars/[id]/events.get();
    Event[]? eventItems = events.items;
    test:assertNotEquals(eventItems, ());
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
    groups: ["mock"]
}
function testGetCalendarEvent() returns error? {
    string id = "default-calendar-id";
    string eventId = "default-event-id";
    Event retrievedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].get();
    test:assertEquals(retrievedEvent.id, eventId);
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
    groups: ["mock"]
}
function testUpdateCalendarEvent() returns error? {
    Event createdEvent = {
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
    string eventId = "default-event-id";
    string newSummary = "Updated Test Event";
    createdEvent.summary = newSummary;
    Event updatedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
}

@test:Config {
    groups: ["mock"]
}
function testPatchCalendarEvent() returns error? {
    Event createdEvent = {
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
    string newSummary = "Patched Test Event";
    createdEvent.summary = newSummary;
    string eventId = "default-event-id";
    Event patchedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
}

@test:Config {
    groups: ["mock"]
}
function testDeleteCalendarEvent() returns error? {
    string id = "default-calendar-id";
    string eventId = "default-event-id";
    Error? deleteEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    test:assertEquals(deleteEvent, ());
}

@test:Config {
    groups: ["mock"]
}
function testCreateEvent() returns error? {
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
}

@test:Config {
    groups: ["mock"]
}
function testImportEvent() returns error? {
    string id = "default-calendar-id";
    string summary = "Test Meeting";
    Event createdEvent = {
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
    Event importedEvent = check calendarClientForMockServer->/calendars/[id]/events/'import.post(createdEvent);
    test:assertEquals(importedEvent.summary, summary);
}

@test:Config {
    groups: ["mock"]
}
function testUpdateEvent() returns error? {
    string summary = "Test Meeting 110";
    Event createdEvent = {
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
    string id = "default-calendar-id";
    string newSummary = "Updated Test Meeting 110";
    createdEvent.summary = newSummary;
    string eventId = "default-event-id";
    Event updatedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].put(createdEvent);
    test:assertEquals(updatedEvent.summary, newSummary);
}

@test:Config {
    groups: ["mock"]
}
function testPatchEvent() returns error? {
    string summary = "Test Meeting";
    Event createdEvent = {
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
    string id = "default-calendar-id";
    string newSummary = "Patched Test Meeting";
    createdEvent.summary = newSummary;
    string eventId = "default-event-id";
    Event patchedEvent = check calendarClientForMockServer->/calendars/[id]/events/[eventId].patch(createdEvent);
    test:assertEquals(patchedEvent.summary, newSummary);
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
    groups: ["mock"]
}
function testDeleteEvent() returns error? {
    string id = "default-calendar-id";
    string eventId = "default-event-id";
    Error? deleteRes = calendarClientForMockServer->/calendars/[id]/events/[eventId].delete();
    test:assertEquals(deleteRes, ());
}

@test:Config {
    groups: ["mock"]
}
function testCreateAclRule() returns error? {
    string id = "default-calendar-id";
    json acl = {
        role: "owner",
        scope: {
            'type: "user",
            value: "user@example.com"
        }
    };
    AclRule res = check calendarClientForMockServer->/calendars/[id]/acl.post(check acl.cloneWithType(AclRule));
    test:assertEquals(res.role, check acl.role);
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
    groups: ["mock"]
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
    groups: ["mock"]
}
function testGetCalendarEventInstances() returns error? {
    string id = "default-calendar-id";
    string eventId = "default-event-id";
    Events instances = check calendarClientForMockServer->/calendars/[id]/events/[eventId]/instances.get();
    test:assertNotEquals(instances.items, ());
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
    groups: ["mock"]
}
function testDeleteCalendarFromList() returns error? {
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCalendar = check calendarClientForMockServer->/calendars.post(cal);
    CalendarListEntry response = check calendarClientForMockServer->/users/me/calendarList.post({id: createdCalendar.id});
    test:assertEquals(response.id, createdCalendar.id);
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
    groups: ["mock"]
}
function testGetCalendarListEntry() returns error? {
    string id = "default-calendar-id";
    CalendarListEntry calendarListEntry = {
        id: id
    };
    CalendarListEntry createdCalendarListEntry = check calendarClientForMockServer->/users/me/calendarList.post(calendarListEntry);
    test:assertEquals(createdCalendarListEntry.id, id);
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
    groups: ["mock"]
}
function testGetCalendarList() returns error? {
    CalendarList calendarList = check calendarClientForMockServer->/users/me/calendarList.get();
    test:assertNotEquals(calendarList, ());
    CalendarListEntry[]? calendarListEntries = calendarList.items;
    test:assertTrue(calendarListEntries is () || calendarListEntries.length() > 0);
}

@test:Config {
    groups: ["mock"]
}
function testGetColors() returns error? {
    Colors colors = check calendarClientForMockServer->/colors.get();
    test:assertNotEquals(colors.calendar, ());
    test:assertNotEquals(colors.event, ());
    test:assertEquals(colors.kind, "calendar#colors");
}

@test:Config {
    groups: ["mock"]
}
function testFreeBusyInfo() returns error? {
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
    test:assertEquals(freeBusyResponse.kind, "calendar#freeBusy");
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
