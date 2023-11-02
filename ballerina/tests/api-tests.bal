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

import ballerina/http;
import ballerina/os;
import ballerina/test;

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

const summary = "Test Calendar 1";

@test:Config {
    groups: ["calendar", "create", "delete"]
}
function testCreateAndDeleteCalendar() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    test:assertEquals(calendarInstance.summary, summary);
    http:Response res = check client1->deleteCalendar(<string>calendarInstance.id);
    test:assertEquals(res.statusCode, 204);
}

@test:Config {
    groups: ["calendar", "clear"]
}
function testClearCalendar() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calendarId = <string>calendarInstance.id;
    test:assertEquals(calendarInstance.summary, summary);
    CalendarListEntry calListEntry = {
        id: calendarId
    };
    CalendarListEntry calendarInsert = check client1->insertCalendarIntoCalendarList(calListEntry);
    test:assertEquals(calendarInsert.id, calendarId);
    http:Response|error clearResponse = client1->clearCalendar(calendarId);
    test:assertTrue(clearResponse !is error);
    Events allEvents = check client1->getEvents(calendarId);
    test:assertEquals((<Event[]>allEvents.items).length(), 0);
}

@test:Config {
    groups: ["calendar", "patch"]
}
function testPatchCalendar() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    Calendar patchCalendar = check client1->patchCalendar(calId, calendarInstance);
    test:assertEquals(patchCalendar.summary, summary);
    http:Response res = check client1->deleteCalendar(<string>patchCalendar.id);
    test:assertEquals(res.statusCode, 204);
}

@test:Config {
    groups: ["calendar", "get"]
}
function testGetCalendars() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    CalendarList calendars = check client1->getCalendars();
    test:assertTrue(calendars.items !is ());
    CalendarListEntry[] calendarEntries = <CalendarListEntry[]>calendars.items;
    boolean includedCalendar = false;
    foreach CalendarListEntry calendarEntry in calendarEntries {
        if calendarEntry.summary == calendarInstance.summary {
            includedCalendar = true;
            break;
        }
    }
    if includedCalendar is false {
        return error("The created calendar is not included.");
    }
}

@test:Config {
    groups: ["calendar", "update"]
}
function testUpdateCalendar() returns error? {
    Client client1 = check new (config);
    string newSummary = "Test Calendar 2";
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    test:assertEquals(calendarInstance.summary, summary);
    calendar = {
        summary: newSummary
    };
    Calendar updatedCalendar = check client1->updateCalendar(<string>calendarInstance.id, calendar);
    test:assertEquals(updatedCalendar.summary, newSummary);
}

@test:Config {
    groups: ["event", "create"]
}
function testCreateAndDeleteEvent() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    Event payload = {
        'start: {
            dateTime: "2023-10-19T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-19T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary
    };
    Event events = check client1->createEvent(calId, payload);
    test:assertEquals(events.summary, summary);
    http:Response event = check client1->deleteEvent(calId, <string>events.id);
    test:assertEquals(event.statusCode, 204);
    http:Response response = check client1->deleteCalendar(<string>calendarInstance.id);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["event", "get"]
}
function testGetEvent() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    Event payload = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary
    };
    Event event = check client1->createEvent(calId, payload);
    test:assertEquals(event.summary, summary);
    Event getEvent = check client1->getEvent(calId, <string>event.id);
    test:assertEquals(getEvent.id, <string>event.id);
    http:Response deleteEvent = check client1->deleteEvent(calId, <string>getEvent.id);
    test:assertEquals(deleteEvent.statusCode, 204);
    http:Response response = check client1->deleteCalendar(<string>calendarInstance.id);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["event", "quickAdd"]
}
function testQuickAddEvent() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    Event unionResult = check client1->quickaddEvent(calId, "Test Quick Add Event");
    test:assertEquals(unionResult.summary, "Test Quick Add Event");
    http:Response calendarEventsDelete = check client1->deleteEvent(calId, <string>unionResult.id);
    test:assertEquals(calendarEventsDelete.statusCode, 204);
}

@test:Config {
    groups: ["event", "instance"]
}
function testInstanceEvent() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    Event payload = {
        iCalUID: calId,
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary,
        recurrence: [
            "RRULE:FREQ=WEEKLY;COUNT=10" // Example: Weekly recurrence for 10 instances
        ]
    };
    Event event = check client1->createEvent(calId, payload);
    test:assertEquals(event.summary, summary);
    Events instances = check client1->getEventInstances(calId, <string>event.id);
    test:assertEquals((<Event[]>instances.items)[0].summary, summary);
    http:Response deleteEvent = check client1->deleteEvent(calId, <string>event.id);
    test:assertEquals(deleteEvent.statusCode, 204);
    http:Response response = check client1->deleteCalendar(<string>calendarInstance.id);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["event", "import"]
}
function testImportEvents() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    Event payload = {
        iCalUID: calId,
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary
    };
    Event event = check client1->createEvent(calId, payload);
    test:assertEquals(event.summary, summary);
    Event importedEvent = check client1->importEvent(calId, payload);
    test:assertEquals(importedEvent.summary, summary);
    http:Response deleteEvent = check client1->deleteEvent(calId, <string>event.id);
    test:assertEquals(deleteEvent.statusCode, 204);
    http:Response response = check client1->deleteCalendar(<string>calendarInstance.id);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["event", "update"]
}
function testUpdateEvent() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    string updatedSummary = "Test Event 101";
    Event payload = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary
    };
    Event event = check client1->createEvent(calId, payload);
    test:assertEquals(event.summary, summary);
    payload = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: updatedSummary
    };

    Event updatedEvent = check client1->updateEvent(calId, <string>event.id, payload);
    test:assertEquals(updatedEvent.summary, updatedSummary);
}

@test:Config {
    groups: ["event", "list"]
}
function testListEvents() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    Event payload = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary
    };
    Event event = check client1->createEvent(calId, payload);
    Events allEvents = check client1->getEvents(calId);
    test:assertEquals((<Event[]>allEvents.items)[0].summary, event.summary);
}

@test:Config {
    groups: ["event", "move"]
}
function testMoveEvents() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    string summary2 = "Test Calendar 101";
    Calendar calendarInstance = check client1->createCalendar(calendar);
    Calendar calendar2 = {
        summary: summary2
    };
    Calendar calendarInstance2 = check client1->createCalendar(calendar2);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    Event payload = {
        iCalUID: calId,
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary
    };
    Event event = check client1->createEvent(calId, payload);
    test:assertEquals((<Event_organizer>event.organizer).displayName, calendarInstance.summary);
    Event movedEvent = check client1->moveEvent(calId, <string>event.id, <string>calendarInstance2.id);
    test:assertEquals((<Event_organizer>movedEvent.organizer).displayName, calendarInstance2.summary);
}

@test:Config {
    groups: ["event", "patch"]
}
function testPatchEvent() returns error? {
    Client client1 = check new (config);
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    string calId = <string>calendarInstance.id;
    string summary = "Test Event 1";
    string updatedSummary = "Test Event 101";
    Event payload = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: summary
    };
    Event event = check client1->createEvent(calId, payload);
    test:assertEquals(event.summary, summary);
    payload = {
        'start: {
            dateTime: "2023-10-28T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-28T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: updatedSummary
    };
    Event updatedEvent = check client1->patchEvent(calId, <string>event.id, payload);
    test:assertEquals(updatedEvent.summary, updatedSummary);
}

@test:Config {
    groups: ["calendarList", "insert", "delete"]
}
function testInsertAndDeleteCalendarList() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar 1";
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    test:assertEquals(calendarInstance.summary, summary);
    CalendarListEntry calListEntry = {
        id: calendarInstance.id
    };
    CalendarListEntry calendarInsert = check client1->insertCalendarIntoCalendarList(calListEntry);
    test:assertEquals(calendarInsert.id, calendarInstance.id);
    http:Response res = check client1->deleteCalendarFromCalendarlist(<string>calendarInstance.id);
    test:assertEquals(res.statusCode, 204);
}

@test:Config {
    groups: ["calendarList", "calendar", "get"]
}
function testGetCalendarFromCalendarList() returns error? {
    Client client1 = check new(config);
    string calId = "calendartest58@gmail.com";
    Calendar unionResult = check client1->getCalendarFromCalendarList(calId);
    test:assertEquals(unionResult.summary, "Test Calendar 1");
}

@test:Config {
    groups: ["calendarList", "calendar", "update"]
}
function testUpdateCalendarFromCalendarList() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar 1";
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    test:assertEquals(calendarInstance.summary, summary);
    CalendarListEntry calListEntry = {
        id: calendarInstance.id,
        summary: summary
    };
    CalendarListEntry calendarUpdate = check client1->updateCalendarFromCalendarList(<string>calendarInstance.id, calListEntry);
    test:assertEquals(calendarUpdate.id, calendarInstance.id);
    http:Response res = check client1->deleteCalendarFromCalendarlist(<string>calendarInstance.id);
    test:assertEquals(res.statusCode, 204);
}

@test:Config {
    groups: ["calendarList", "calendar", "patch"]
}
function testPatchCalendarFromCalendarList() returns error? {
    Client client1 = check new(config);
    string summary = "Test Calendar 1";
    Calendar calendar = {
        summary: summary
    };
    Calendar calendarInstance = check client1->createCalendar(calendar);
    test:assertEquals(calendarInstance.summary, summary);
    CalendarListEntry calListEntry = {
        id: calendarInstance.id,
        summary: summary
    };
    CalendarListEntry calendarPatch = check client1->patchCalendarFromCalendarList(<string>calendarInstance.id, calListEntry);
    test:assertEquals(calendarPatch.id, calendarInstance.id);
    http:Response res = check client1->deleteCalendar(<string>calendarInstance.id);
    test:assertEquals(res.statusCode, 204);
}

@test:Config {
    groups: ["calendarList", "list"]
}
function testListCalendarList() returns error? {
    Client client1 = check new(config);
    CalendarList unionResult = check client1->getCalendars();
    test:assertEquals((<CalendarListEntry[]>unionResult.items)[0].summary, "Test Calendar 1");
}

@test:Config {
    groups: ["acl", "list"]
}
function testListAcl() returns error? {
    Client client1 = check new(config);
    string calId = "calendartest58@gmail.com";
    Acl unionResult = check client1->getAclRulesList(calId);
    test:assertEquals(unionResult.kind, "calendar#acl");
}

@test:Config {
    groups: ["acl", "get"]
}
function testGetAcl() returns error? {
    Client client1 = check new(config);
    string calId = "calendartest58@gmail.com";
    Acl aclResults = check client1->getAclRulesList(calId);
    AclRule listResult = (<AclRule[]>aclResults.items)[0];
    AclRule unionResult = check client1->getAclRule(calId, <string>listResult.id);
    test:assertEquals(unionResult.id, listResult.id);
}

@test:Config {
    groups: ["acl", "create"]
}
function testCreateAcl() returns error? {
    Client client1 = check new(config);
    string calId = "calendartest58@gmail.com";
    AclRule aclRule = {
        "kind": "calendar#aclRule",
        "role": "freeBusyReader",
        "scope": {
            "type": "default"
        }
    };
    AclRule unionResult = check client1->createAclRule(calId, aclRule);
    test:assertEquals(unionResult.role, "freeBusyReader");
    test:assertEquals(unionResult.kind, "calendar#aclRule");
}

@test:Config {
    groups: ["acl", "delete"]
}
function testDeleteAcl() returns error? {
    Client client1 = check new(config);
    string calId = "calendartest58@gmail.com";
    AclRule aclRule = {
        "kind": "calendar#aclRule",
        "role": "freeBusyReader",
        "scope": {
            "type": "default"
        }
    };
    AclRule unionResult = check client1->createAclRule(calId, aclRule);
    test:assertEquals(unionResult.kind, "calendar#aclRule");
    http:Response response = check client1->deleteAclRule(calId, <string>unionResult.id);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["acl", "update"]
}
function testUpdateAcl() returns error? {
    Client client1 = check new(config);
    string calId = "calendartest58@gmail.com";
    AclRule aclRule = {
        "kind": "calendar#aclRule",
        "role": "freeBusyReader",
        "scope": {
            "type": "default"
        }
    };
    AclRule unionResult = check client1->createAclRule(calId, aclRule);
    test:assertEquals(unionResult.role, "freeBusyReader");
    aclRule = {
        "kind": "calendar#aclRule",
        "role": "none",
        "scope": {
            "type": "default"
        }
    };
    AclRule response = check client1->updateAclRule(calId, <string>unionResult.id, aclRule);
    test:assertEquals(response.role, "none");
}

@test:Config {
    groups: ["acl", "patch"]
}
function testPatchAcl() returns error? {
    Client client1 = check new(config);
    string calId = "calendartest58@gmail.com";
    AclRule aclRule = {
        "kind": "calendar#aclRule",
        "role": "freeBusyReader",
        "scope": {
            "type": "default"
        }
    };
    AclRule unionResult = check client1->createAclRule(calId, aclRule);
    test:assertEquals(unionResult.role, "freeBusyReader");
    aclRule = {
        "kind": "calendar#aclRule",
        "role": "none",
        "scope": {
            "type": "default"
        }
    };
    AclRule response = check client1->patchAclRule(calId, <string>unionResult.id, aclRule);
    test:assertEquals(response.role, "none");
}

@test:Config {
    groups: ["settings", "get"]
}
function testGetSetting() returns error? {
    Client client1 = check new(config);
    Settings settings = check client1->getAllUserSettings();
    string id = <string>(<Setting[]>settings.items)[0].id;
    Setting setting = check client1->getUserSetting(id);
    test:assertEquals(setting.id, id);
}

@test:Config {
    groups: ["settings", "list"]
}
function testListSettings() returns error? {
    Client client1 = check new(config);
    Settings unionResult = check client1->getAllUserSettings();
    test:assertEquals(unionResult.kind, "calendar#settings");
}

@test:Config {
    groups: ["colors"]
}
function testColors() returns error? {
    Client client1 = check new(config);
    Colors|error unionResult = client1->getColors();
    test:assertTrue(unionResult !is error);
    if unionResult !is error {
        test:assertEquals(unionResult.kind, "calendar#colors");
        json cal = {background:"#ac725e", foreground:"#1d1d1d"};
        test:assertEquals(unionResult.calendar["1"], cal);
    }
}

@test:Config {
    groups: ["freeBusy"]
}
function testFreeBusy() returns error? {
    Client client1 = check new(config);
    FreeBusyRequest freeBusyReq = {
        timeMin: "2023-10-24T00:00:00+05:30",
        timeMax: "2023-10-24T23:59:59+05:30"
    };
    FreeBusyResponse unionResult = check client1->queryFreebusy(freeBusyReq);
    test:assertEquals(unionResult.kind, "calendar#freeBusy");
}
