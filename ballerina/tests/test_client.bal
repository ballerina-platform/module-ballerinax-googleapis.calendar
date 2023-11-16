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

    error? res = check client1->/calendars/[<string>unionResult.id].delete();
    test:assertEquals(res, ());
}

// Define the test configuration
@test:Config{}
function testGetCalendar() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Get the calendar
    Calendar retrievedCal = check client1->/calendars/[<string>createdCal.id].get();

    // Assert that the retrieved calendar matches the created calendar
    test:assertEquals(retrievedCal.summary, summary);

    // Delete the calendar
    error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// // Test case for updating a calendar
@test:Config{}
function testUpdateCalendar() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Update the calendar
    string newSummary = "Updated Test Calendar";
    createdCal.summary = newSummary;
    Calendar updatedCal = check client1->/calendars/[<string>createdCal.id].put(createdCal);

    // Assert that the retrieved calendar matches the updated calendar
    test:assertEquals(updatedCal.summary, newSummary);

    // Delete the calendar
    error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for patching a calendar
@test:Config{}
function testPatchCalendar() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Patch the calendar
    string newSummary = "Patched Test Calendar";
    createdCal.summary = newSummary;
    Calendar patchedCal = check client1->/calendars/[<string>createdCal.id].patch(createdCal);

    // Assert that the retrieved calendar matches the patched calendar
    test:assertEquals(patchedCal.summary, newSummary);

    // Delete the calendar
    error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for getting the ACL of a calendar
@test:Config{}
function testGetCalendarAcl() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Get the ACL of the calendar
    Acl acl = check client1->/calendars/[<string>createdCal.id]/acl.get();

    AclRule[]? aclRules = acl.items;

    if aclRules !is () {
        // Assert that the retrieved ACL has at least one rule
        test:assertTrue(aclRules.length() > 0);
    }

    // Delete the calendar
    error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for getting the events of a calendar
@test:Config{}
function testGetCalendarEvents() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an event
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

    // Get the events of the calendar
    Events events = check client1->/calendars/[<string>createdCal.id]/events.get();
    
    // Assert that the retrieved events contain the created event
    boolean eventFound = false;
    Event[]? eventItems = events.items;
    if eventItems != () {
        foreach Event event_item in eventItems {
            if (event_item.summary != eventSummary) {
                eventFound = true;
                break;
            }
        }
    }
    test:assertTrue(eventFound, "Retrieved events do not contain the created event");

    // Delete the calendar
    error? res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for getting a single event of a calendar
@test:Config{}
function testGetCalendarEvent() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an event
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

    // Get the event
    Event retrievedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].get();

    // Assert that the retrieved event matches the created event
    test:assertEquals(retrievedEvent.summary, eventSummary);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for creating an event in a calendar
@test:Config{}
function testCreateCalendarEvent() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an event
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

    // Get the event
    Event retrievedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].get();

    // Assert that the retrieved event matches the created event
    test:assertEquals(retrievedEvent.summary, eventSummary);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for updating an event in a calendar
@test:Config{}
function testUpdateCalendarEvent() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an event
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

    // Update the event
    string newSummary = "Updated Test Event";
    createdEvent.summary = newSummary;
    Event updatedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].put(createdEvent);

    // Assert that the retrieved event matches the updated event
    test:assertEquals(updatedEvent.summary, newSummary);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for patching an event in a calendar
@test:Config{}
function testPatchCalendarEvent() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an event
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

    // Patch the event
    string newSummary = "Patched Test Event";
    createdEvent.summary = newSummary;
    Event patchedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].patch(createdEvent);

    // Assert that the retrieved event matches the patched event
    test:assertEquals(patchedEvent.summary, newSummary);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for deleting an event from a calendar
@test:Config{}
function testDeleteCalendarEvent() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an event
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

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for creating an event in a calendar
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

// Test case for updating an event in a calendar
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

    // Update the event
    string newSummary = "Updated Test Meeting 110";
    createdEvent.summary = newSummary;
    Event updatedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].put(createdEvent);

    test:assertEquals(updatedEvent.summary, newSummary);

    // Assert that the retrieved event matches the updated event
    test:assertEquals(updatedEvent.summary, newSummary);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

// Test case for patching an event in a calendar
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

    // Patch the event
    string newSummary = "Patched Test Meeting 110";
    createdEvent.summary = newSummary;
    Event patchedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].patch(createdEvent);

    // Assert that the retrieved event matches the patched event
    test:assertEquals(patchedEvent.summary, newSummary);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

// Test case for getting an event from a calendar
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

    // Get the event
    Event retrievedEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].get();

    // Assert that the retrieved event matches the created event
    test:assertEquals(retrievedEvent.summary, summary);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

// Test case for deleting an event from a calendar
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

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());
}

// Test case for posting the ACL of a calendar
@test:Config{}
function testPostCalendarAcl() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an ACL
    json acl = {
        role: "owner", // replace with actual role
        scope: {
            'type: "user", // replace with actual type
            value: "user@example.com" // replace with actual value
        }
    };

    // Post the ACL to the calendar
    AclRule res = check client1->/calendars/[<string>createdCal.id]/acl.post(check acl.cloneWithType(AclRule));

    // Test the AclRule response
    test:assertEquals(res.role, check acl.role);
    test:assertEquals((<AclRule_scope>res.scope).value, check acl.scope.value);

    // Delete the calendar
    error? delRes = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(delRes, ());
}

// Test case for creating an access control rule
@test:Config{}
function testCreateAclRule() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an ACL rule
    AclRule aclRule = {
        role: "reader",
        scope: {
            'type: "user",
            value: "testuser@gmail.com"
        }
    };
    AclRule createdAclRule = check client1->/calendars/[<string>createdCal.id]/acl.post(aclRule);

    // Get the ACL of the calendar
    Acl acl = check client1->/calendars/[<string>createdCal.id]/acl.get();

    // Assert that the retrieved ACL contains the created ACL rule
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

    // Delete the ACL rule
    error? res = check client1->/calendars/[<string>createdCal.id]/acl/[<string>createdAclRule.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// // Test case for getting instances of an event in a calendar
// @test:Config{}
// function testGetCalendarEventInstances() returns error? {
//     Client client1 = check new(config);

//     // Create a calendar
//     string summary = "Test Calendar";
//     Calendar cal = {
//         summary: summary
//     };
//     Calendar createdCal = check client1->/calendars.post(cal);

//     // Create an event
//     string eventSummary = "Test Event";
//     Event event = {
//         'start: {
//             dateTime: "2023-10-28T03:00:00+05:30",
//             timeZone: "Asia/Colombo"
//         },
//         end: {
//             dateTime: "2023-10-28T03:30:00+05:30",
//             timeZone: "Asia/Colombo"
//         },
//         summary: eventSummary
//     };
//     Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events.post(event);

//     // Get the instances of the event
//     Events instances = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id]/instances.get();

//     // Assert that the retrieved instances contain the created event
//     boolean eventFound = false;
//     Event[]? eventItems = instances.items;
//     if eventItems != () {
//         foreach Event event_item in eventItems {
//             if (event_item.summary != eventSummary) {
//                 eventFound = true;
//                 break;
//             }
//         }
//     }
//     test:assertTrue(eventFound, "Retrieved instances do not contain the created event");

//     // Delete the event
//     error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
//     test:assertEquals(res, ());

//     // Delete the calendar
//     res = check client1->/calendars/[<string>createdCal.id].delete();
//     test:assertEquals(res, ());
// }

// Test case for moving an event to another calendar
@test:Config{}
function testMoveCalendarEvent() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create another calendar
    string summary2 = "Test Calendar 2";
    Calendar cal2 = {
        summary: summary2
    };
    Calendar createdCal2 = check client1->/calendars.post(cal2);

    // Create an event in the first calendar
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

    // Move the event to the second calendar
    Event moveEvent = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id]/move.post(<string>createdCal2.id);

    // Assert that the retrieved event matches the moved event
    test:assertEquals(moveEvent.summary, eventSummary);

    // Delete the event from the second calendar
    error? res = check client1->/calendars/[<string>createdCal2.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());

    // Delete the second calendar
    res = check client1->/calendars/[<string>createdCal2.id].delete();
    test:assertEquals(res, ());

    // Delete the first calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}

// Test case for deleting a calendar from the calendar list
@test:Config {}
function testDeleteCalendarFromList() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };

    Calendar createdCalendar = check client1->/calendars.post(cal);
    CalendarListEntry response = check client1->/users/me/calendarList.post({id: createdCalendar.id});
    test:assertEquals(response.id, createdCalendar.id);

    // Delete the calendar from the list
    error? res = check client1->/users/me/calendarList/[<string>createdCalendar.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCalendar.id].delete();
    test:assertEquals(res, ());
}

// // Test case for patching a calendar list entry
// @test:Config{}
// function testPatchCalendarListEntry() returns error? {
//     Client client1 = check new(config);

//     // Create a calendar list entry
//     string calendarId = "test-calendar-id";
//     CalendarListEntry calendarListEntry = {
//         id: calendarId,
//         summary: "Test Calendar List Entry"
//     };
//     CalendarListEntry createdCalendarListEntry = check client1->/users/me/calendarList.post(calendarListEntry);

//     // Update the calendar list entry
//     string newSummary = "Updated Test Calendar List Entry";
//     createdCalendarListEntry.summary = newSummary;
//     CalendarListEntry updatedCalendarListEntry = check client1->/users/me/calendarList/[<string>calendarId].patch(createdCalendarListEntry);

//     // Assert that the retrieved calendar list entry matches the updated calendar list entry
//     test:assertEquals(updatedCalendarListEntry.summary, newSummary);

//     // Delete the calendar list entry
//     error? res = check client1->/users/me/calendarList/[<string>calendarId].delete();
//     test:assertEquals(res, ());
// }

// // Define the test configuration
// @test:Config{}
// function testSettingsAPIs() returns error? {
//     Client client1 = check new(config);

//     // Test case for getting all user settings
//     Settings settings = check client1->/users/me/settings.get();
//     test:assertNotEquals(settings, ());

//     // Test case for watching changes to user settings
//     Setting channel = check client1->/users/me/settings/watch(check new, "json");
//     test:assertNotEquals(channel, ());

//     // Test case for getting a single user setting
//     Setting|error setting = client1->/users/me/settings/[<string>(<Setting[]>settings.items[0]).id].get();
//     test:assertNotNull(setting);

//     // Delete the channel
//     error? res = check client1->/channels/[<string>channel.id].delete();
//     test:assertEquals(res, ());
// }

// @test:Config {}
// function testPostCalendarList() returns error? {
//     Client client1 = check new(config);
//     string summary = "Test Calendar List";
//     CalendarListEntry calListEntry = {
//         summary: summary
//     };
//     CalendarListEntry unionResult = check client1->/users/me/calendarList.post(calListEntry);
//     test:assertEquals(unionResult.summary, summary);

//     error? res = check client1->/users/me/calendarList/[<string>unionResult.id].delete();
//     test:assertEquals(res, ());
// }

// @test:Config {}
// function testGetCalendarListEntry() returns error? {
//     Client client1 = check new(config);

//     // Create a calendar list entry
//     string summary = "Test Calendar List Entry";
//     CalendarListEntry calendarListEntry = {
//         summary: summary
//     };
//     CalendarListEntry createdCalendarListEntry = check client1->/users/me/calendarList.post(calendarListEntry);

//     // Get the calendar list entry
//     CalendarListEntry retrievedCalendarListEntry = check client1->/users/me/calendarList/[<string>createdCalendarListEntry.id].get();

//     // Assert that the retrieved calendar list entry matches the created calendar list entry
//     test:assertEquals(retrievedCalendarListEntry.summary, summary);

//     // Delete the calendar list entry
//     error? res = check client1->/users/me/calendarList/[<string>createdCalendarListEntry.id].delete();
//     test:assertEquals(res, ());
// }

// Test case for updating a calendar list entry
@test:Config{}
function testUpdateCalendarListEntry() returns error? {
    Client client1 = check new(config);

    // Create a calendar list entry
    string summary = "Test Calendar List Entry";
    CalendarListEntry entry = {
        summary: summary
    };
    CalendarListEntry createdEntry = check client1->/users/me/calendarList.post(entry);

    // Update the calendar list entry
    string newSummary = "Updated Test Calendar List Entry";
    createdEntry.summary = newSummary;
    CalendarListEntry updatedEntry = check client1->/users/me/calendarList/[<string>createdEntry.id].put(createdEntry);

    // Assert that the retrieved calendar list entry matches the updated calendar list entry
    test:assertEquals(updatedEntry.summary, newSummary);

    // Delete the calendar list entry
    error? res = check client1->/users/me/calendarList/[<string>createdEntry.id].delete();
    test:assertEquals(res, ());
}

// Test case for getting the calendar list of the authenticated user
@test:Config{}
function testGetCalendarList() returns error? {
    Client client1 = check new(config);

    // Get the calendar list
    CalendarList calendarList = check client1->/users/me/calendarList.get();

    // Assert that the calendar list is not null
    test:assertNotEquals(calendarList, ());

    CalendarListEntry[]? calendarListEntries = calendarList.items;
    if calendarListEntries !is () {
        // Assert that the calendar list has at least one calendar list entry
        test:assertTrue(calendarListEntries.length() > 0);
    }
}

@test:Config {}
function testGetColors() returns error? {
    Client client1 = check new(config);

    // Get the colors
    Colors colors = check client1->/colors.get();

    // Assert that the response contains the expected fields
    test:assertNotEquals(colors.calendar, ());

    // Assert that the response contains the expected number of event colors
    test:assertNotEquals(colors.event, ());
    test:assertEquals(colors.kind, "calendar#colors");
}

@test:Config {}
function testFreeBusy() returns error? {
    Client client1 = check new(config);

    // Create a free busy request
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

    // Get the free busy response
    FreeBusyResponse freeBusyResponse = check client1->/freeBusy.post(freeBusyRequest);

    // Assert that the response contains the expected fields
    test:assertNotEquals(freeBusyResponse.kind, ());
    test:assertNotEquals(freeBusyResponse.calendars, ());
}

// // Test case for stopping a channel
// @test:Config{}
// function testStopChannel() returns error? {
//     Client client1 = check new(config);

//     // Create a channel
//     Channel channel = {
//         id: "test-channel-id",
//         resourceId: "test-resource-id",
//         token: "test-token",
//         expiration: "test-expiration"
//     };
//     Channel createdChannel = client1->/channels.post(channel);
//     error? response = check client1->/channels/stop.post(channel);

//     // Assert that the response status code is 200
//     test:assertEquals(response, ());
// }

@test:Config {}
function testGetUserSettings() returns error? {
    Client client1 = check new(config);

    // Get the user settings
    Settings settings = check client1->/users/me/settings.get();

    // Assert that the response is not null
    test:assertNotEquals(settings, ());
}

// Test case for getting a setting
@test:Config{}
function testGetSetting() returns error? {
    Client client1 = check new(config);

    // Get the setting
    Setting setting = check client1->/users/me/settings/[<string>"test_setting"].get();

    // Assert that the retrieved setting matches the expected value
    test:assertEquals(setting.value, "test_value");
}

// Test case for creating an event using quickAdd in a calendar
@test:Config{}
function testCreateCalendarEventQuickAdd() returns error? {
    Client client1 = check new(config);

    // Create a calendar
    string summary = "Test Calendar";
    Calendar cal = {
        summary: summary
    };
    Calendar createdCal = check client1->/calendars.post(cal);

    // Create an event using quickAdd
    string eventText = "Event created using quickAdd";
    Event createdEvent = check client1->/calendars/[<string>createdCal.id]/events/quickAdd.post(eventText);

    // Assert that the retrieved event matches the created event
    test:assertEquals(createdEvent.summary, eventText);

    // Delete the event
    error? res = check client1->/calendars/[<string>createdCal.id]/events/[<string>createdEvent.id].delete();
    test:assertEquals(res, ());

    // Delete the calendar
    res = check client1->/calendars/[<string>createdCal.id].delete();
    test:assertEquals(res, ());
}
