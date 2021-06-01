// Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/log;
import ballerina/test;
import ballerina/time;
import ballerina/os;

configurable string clientId = os:getEnv("CLIENT_ID");
configurable string clientSecret = os:getEnv("CLIENT_SECRET");
configurable string refreshToken = os:getEnv("REFRESH_TOKEN");
configurable string refreshUrl = os:getEnv("REFRESH_URL");
configurable string address = os:getEnv("ADDRESS");

CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

Client calendarClient = check new (config); 

string testEventId = "";
string testQuickAddEventId = "";
string testCalendarId = "";

@test:Config {
    dependsOn: [testCreateCalendar]
}
function testGetCalendars() {
    log:printInfo("calendarClient -> getCalendars()");
    stream<Calendar,error>|error resultStream = calendarClient->getCalendars();
    if (resultStream is stream<Calendar,error>) {
        record {|Calendar value;|}|error res = resultStream.next();
        test:assertTrue(res is record {|Calendar value;|}, msg = "Found 0 records");
    } else {
        test:assertFail(resultStream.message());
    }
   
}

EventsToAccess optional = {
    conferenceDataVersion: 1,
    sendUpdates: "all",
    supportsAttachments: false
};

@test:Config {}
function testCreateCalendar() {
    log:printInfo("calendarClient -> createCalendar()");
    CalendarResource|error res = calendarClient->createCalendar("testCalendar");
    if (res is CalendarResource) {
        test:assertNotEquals(res.id, "", msg = "Expect event id");
        testCalendarId = <@untainted> res.id;
    } else {
        test:assertFail(res.message());
    }
}

@test:AfterSuite {}
function testDeleteCalendar() {
    log:printInfo("calendarClient -> deleteCalendar()");
    error? res = calendarClient->deleteCalendar(testCalendarId);
    if (res is error) {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: [testCreateCalendar]
}
function testCreateEvent() {
    InputEvent event = setEvent("Event Created");
    log:printInfo("calendarClient -> createEvent()");
    Event|error res = calendarClient->createEvent(testCalendarId, event, optional);
    if (res is Event) {
        test:assertNotEquals(res.id, "", msg = "Expect event id");
        testEventId = <@untainted> res.id;
    } else {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: [testCreateCalendar]
}
function testquickAdd() {
    log:printInfo("calendarClient -> quickAddEvent()");
    Event|error res = calendarClient->quickAddEvent(testCalendarId, "Hello", "none");
    if (res is Event) {
        test:assertNotEquals(res.id, "", msg = "Expect event id");
        testQuickAddEventId = <@untainted> res.id;
    } else {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: [testGetEvent, testquickAdd]
}
function testGetEvents() {
    log:printInfo("calendarClient -> getEvents()");
    stream<Event,error>|error resultStream = calendarClient->getEvents(testCalendarId);
        if (resultStream is stream<Event,error>) {
            record {|Event value;|}|error res = resultStream.next();
            test:assertTrue(res is record {|Event value;|}, msg = "Found 0 records");
        } else {
        test:assertFail(resultStream.message());
    }
}

@test:Config {
    dependsOn: [testCreateEvent]
}
function testGetEvent() {
    log:printInfo("calendarClient -> getEvent()");
    Event|error res = calendarClient->getEvent(testCalendarId, testEventId);
    if (res is Event) {
        test:assertTrue(res.id == testEventId, msg = "Found 0 search records!");
    } else {
        test:assertFail(res.message()); 
    }
}

@test:Config{
    dependsOn: [testCreateEvent]
}
function testUpdateEvent() {
    InputEvent event = setEvent("Event Updated");
    log:printInfo("calendarClient -> updateEvent()");
    Event|error res = calendarClient->updateEvent(testCalendarId, testEventId, event);
    if (res is Event) {
        test:assertNotEquals(res.id, "", msg = "Expect event id");
    } else {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: [testGetEvent, testUpdateEvent]
}
function testDeleteEvent() {
    log:printInfo("calendarClient -> deleteEvent()");
    error? res = calendarClient->deleteEvent(testCalendarId, testEventId);
    error? resp = calendarClient->deleteEvent(testCalendarId, testQuickAddEventId);
    if (res is error) {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: [testGetEvent]
}
function testGetEventsResponse() {
    log:printInfo("calendarClient -> getEventsResponse()");
    EventResponse|error res = calendarClient->getEventsResponse(testCalendarId);
    if (res is EventResponse) {
        test:assertNotEquals(res?.kind, "", msg = "Expects event kind");
    } else {
        test:assertFail(res.message());
    }
}

isolated function setEvent(string summary) returns InputEvent {
    time:Utc time = time:utcNow();
    string startTime =  time:utcToString(time:utcAddSeconds(time, 3600));
    string endTime = time:utcToString(time:utcAddSeconds(time, 7200));
    InputEvent event = {
        'start: {
            dateTime: startTime
        },
        end: {
            dateTime: endTime
        },
        summary: summary
    };
    return event;  
}
