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

import ballerina/config;
import ballerina/log;
import ballerina/test;
import ballerina/time;

CalendarConfiguration config = {
    oauth2Config: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshUrl: config:getAsString("REFRESH_URL"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};

CalendarClient calendarClient = new(config); 

string testEventId = "";
string testChannelId = "";
string testResourceId = "";
string testQuickAddEventId = "";

CreateEventOptional optional = {
    conferenceDataVersion: 1,
    sendUpdates: "all",
    supportsAttachments: false
};

@test:Config{}
function testCreateEvent() {
    InputEvent|error event = setEvent("Event Created");
    if (event is InputEvent) {
        log:print("calendarClient -> createEvent()");
        Event|error res = calendarClient->createEvent(config:getAsString("CALENDAR_ID"), event, optional);
        if (res is Event) {
            test:assertNotEquals(res.id, "", msg = "Expect event id");
            testEventId = <@untainted> res.id;
        } else {
            test:assertFail(res.message());
        }
    }
}

@test:Config{}
function testquickAdd() {
    log:print("calendarClient -> quickAddEvent()");
    Event|error res = calendarClient->quickAddEvent(config:getAsString("CALENDAR_ID"), "Hello", "none");
    if (res is Event) {
        test:assertNotEquals(res.id, "", msg = "Expect event id");
        testQuickAddEventId = <@untainted> res.id;
    } else {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: ["testGetEvent", "testquickAdd"]
}
function testGetEvents() {
    log:print("calendarClient -> getEvents()");
    stream<Event>|error res = calendarClient->getEvents(config:getAsString("CALENDAR_ID"));
    if (res is stream<Event>) {
        var event = res.next();
           test:assertNotEquals(event?.value, "", msg = "Found 0 records");
    } else {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: ["testCreateEvent"]
}
function testGetEvent() {
    log:print("calendarClient -> getEvent()");
    Event|error res = calendarClient->getEvent(config:getAsString("CALENDAR_ID"), testEventId);
    if (res is Event) {
        test:assertTrue(res.id == testEventId, msg = "Found 0 search records!");
    } else {
        test:assertFail(res.message()); 
    }
}

@test:Config{
    dependsOn: ["testCreateEvent"]
}
function testUpdatevent() {
    InputEvent|error event = setEvent("Event Updated");
    if (event is InputEvent) {
        log:print("calendarClient -> updateEvent()");
        Event|error res = calendarClient->updateEvent(config:getAsString("CALENDAR_ID"), testEventId, event);
        if (res is Event) {
            test:assertNotEquals(res.id, "", msg = "Expect event id");
            
        } else {
            test:assertFail(res.message());
        }
    }
}

@test:Config {
    dependsOn: ["testGetEvent", "testUpdatevent"]
}
function testDeleteEvent() {
    log:print("calendarClient -> deleteEvent()");
    boolean|error res = calendarClient->deleteEvent(config:getAsString("CALENDAR_ID"), testEventId);
    boolean|error resp = calendarClient->deleteEvent(config:getAsString("CALENDAR_ID"), testQuickAddEventId);
    if (res is boolean) {
        test:assertTrue(res, msg = "Expects true on success");
    } else {
        test:assertFail(res.message());
    }
}

WatchConfiguration watchConfig = {
    id: "abc1qwelo7815895454158ytgtyer23",
    token: "asd123",
    'type: "webhook",
    address: config:getAsString("ADDRESS"),
    params: {
        ttl: "20000"
    }
};

@test:Config{}
function testWatchEvents() {
    log:print("calendarClient -> watchEvents()");
    WatchResponse|error res = calendarClient->watchEvents(config:getAsString("CALENDAR_ID"), watchConfig);
    if (res is WatchResponse) {
        test:assertNotEquals(res.id, "", msg = "Expects channel id");
        testChannelId = <@untainted> res.id;
        testResourceId = <@untainted> res.resourceId;
    } else {
        test:assertFail(res.message());
    }
}

@test:Config{
    dependsOn: ["testWatchEvents"]
}
function testStopChannel() {
    log:print("calendarClient -> stopChannel()");
    boolean|error res = calendarClient->stopChannel(testChannelId, testResourceId);
    if (res is boolean) {
        test:assertTrue(res, msg = "Expects true on success");
    } else {
        test:assertFail(res.message());
    }
}

@test:Config {
    dependsOn: ["testGetEvent"]
}
function testGetEventResponse() {
    log:print("calendarClient -> getEventResponse()");
    EventResponse|error res = calendarClient->getEventResponse(config:getAsString("CALENDAR_ID"), 5);
    if (res is EventResponse) {
        test:assertNotEquals(res.kind, "", msg = "Expects event kind");
    } else {
        test:assertFail(res.message());
    }
}

isolated function setEvent (string summary) returns InputEvent|error {
    time:Time time = time:currentTime();
    string startTime = check time:format(time:addDuration(time, 0, 0, 0, 4, 0, 0, 0), TIME_FORMAT);
    string endTime = check time:format(time:addDuration(time, 0, 0, 0, 5, 0, 0, 0), TIME_FORMAT);
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
