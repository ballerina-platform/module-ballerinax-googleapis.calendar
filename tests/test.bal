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
string testChannelId = "";
string testResourceId = "";
string testQuickAddEventId = "";
string testCalendarId = "";

@test:Config {
    dependsOn: [testCreateCalendar]
}
function testGetCalendars() {
    log:print("calendarClient -> getCalendars()");
    stream<Calendar>|error res = calendarClient->getCalendars();
    if (res is stream<Calendar>) {
        var calendar = res.next();
        test:assertNotEquals(calendar?.value?.id, "", msg = "Found 0 records");
    } else {
        test:assertFail(res.message());
    }
}

CreateEventOptional optional = {
    conferenceDataVersion: 1,
    sendUpdates: "all",
    supportsAttachments: false
};

@test:Config {}
function testCreateCalendar() {
    log:print("calendarClient -> createCalendar()");
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
    log:print("calendarClient -> deleteCalendar()");
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
    log:print("calendarClient -> createEvent()");
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
    log:print("calendarClient -> quickAddEvent()");
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
    log:print("calendarClient -> getEvents()");
    stream<Event>|error res = calendarClient->getEvents(testCalendarId);
    if (res is stream<Event>) {
        var event = res.next();
        test:assertNotEquals(event?.value, "", msg = "Found 0 records");
    } else {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: [testCreateEvent]
}
function testGetEvent() {
    log:print("calendarClient -> getEvent()");
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
    log:print("calendarClient -> updateEvent()");
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
    log:print("calendarClient -> deleteEvent()");
    error? res = calendarClient->deleteEvent(testCalendarId, testEventId);
    error? resp = calendarClient->deleteEvent(testCalendarId, testQuickAddEventId);
    if (res is error) {
        test:assertFail(res.message());
    }
}

@test:Config{
    dependsOn: [testCreateCalendar]
}
function testWatchEvents() {
    log:print("calendarClient -> watchEvents()");
    WatchResponse|error res = calendarClient->watchEvents(testCalendarId, address);
    if (res is WatchResponse) {
        test:assertNotEquals(res.id, "", msg = "Expects channel id");
        testChannelId = <@untainted> res.id;
        testResourceId = <@untainted> res.resourceId;
    } else {
        test:assertFail(res.message());
    }
}

@test:Config{
    dependsOn: [testWatchEvents]
}
function testStopChannel() {
    log:print("calendarClient -> stopChannel()");
    error? res = calendarClient->stopChannel(testChannelId, testResourceId);
    if (res is error) {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: [testGetEvent]
}
function testGetEventResponse() {
    log:print("calendarClient -> getEventResponse()");
    EventStreamResponse|error res = calendarClient->getEventResponse(testCalendarId);
    if (res is EventStreamResponse) {
        test:assertNotEquals(res?.kind, "", msg = "Expects event kind");
    } else {
        test:assertFail(res.message());
    }
}

isolated function setEvent (string summary) returns InputEvent {
    time:Time time = time:currentTime();
    string startTime = checkpanic time:format(checkpanic time:addDuration(time, {hours: 4}), TIME_FORMAT);
    string endTime = checkpanic time:format(checkpanic time:addDuration(time, {hours: 5}), TIME_FORMAT);
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
