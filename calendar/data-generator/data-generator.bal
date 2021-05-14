// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/os;
import ballerina/io;
import ballerina/log;
import ballerina/time;
import ballerinax/googleapis.calendar;

configurable string clientId = os:getEnv("CLIENT_ID");
configurable string clientSecret = os:getEnv("CLIENT_SECRET");
configurable string refreshToken = os:getEnv("REFRESH_TOKEN");
configurable string refreshUrl = os:getEnv("REFRESH_URL");
configurable string address = os:getEnv("ADDRESS");

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

// Connector configuration
calendar:Client calendarClient = check new (config);
string connecterVersion = "0.1.3";
string testEventId = "";
string testChannelId = "";
string testResourceId = "";
string testQuickAddEventId = "";
string testCalendarId1 = "";
string testCalendarId2 = "";
string testCalendarId3 = "";
string testCalendarName1 = "MyPersonalCalendar";
string testCalendarName2 = "MyOfficeCalendar";
string testCalendarName3 = "MyToDoListCalendar";

// Constants
string COMMA = ",";
string SQUARE_BRACKET_LEFT = "[";
string SQUARE_BRACKET_RIGHT = "]";

// Configuration related to data generation
final string rootPath = "./data/";
final string fileExtension = "_data.json";

// Output files
string CalendarResource = rootPath + "CalendarResource"+fileExtension;
string Event = rootPath + "Event"+fileExtension;
string WatchResponse = rootPath + "WatchResponse"+fileExtension;
string EventResponse = rootPath + "EventResponse"+fileExtension;
string InputEvent = rootPath + "InputEvent"+fileExtension;
string CreateEventOptional = rootPath + "CreateEventOptional"+fileExtension;

public function main() returns error? {
    _ = check generateCalendarResourceData();
    _ = check generateEventData();
    _ = check generateWatchResponseData();
    _ = check generateEventResponseData();
    _ = check generateInputEventData();
    _ = check generateCreateEventOptionalData();
}

function generateCalendarResourceData() returns error? {
    log:printInfo("SampleDataGenerator -> generateCalendarResourceData()");
    calendar:CalendarResource res1 = check calendarClient->createCalendar(testCalendarName1);
    calendar:CalendarResource res2 = check calendarClient->createCalendar(testCalendarName2);
    calendar:CalendarResource res3 = check calendarClient->createCalendar(testCalendarName3);

    testCalendarId1 = <@untainted> res1.id;
    testCalendarId2 = <@untainted> res2.id;
    testCalendarId3 = <@untainted> res3.id;

    string array = SQUARE_BRACKET_LEFT + res1.toJsonString() + COMMA + res2.toJsonString() + COMMA + res3.toJsonString() 
                    + SQUARE_BRACKET_RIGHT;
    string preparedJson = "{"+"\"ballerinax/googleapis.calendar:"+connecterVersion+":CalendarResource\""+":"+array+"}";
    check io:fileWriteJson(CalendarResource, check preparedJson.cloneWithType(json));        
}

function generateEventData() returns error? {
    log:printInfo("SampleDataGenerator -> generateEventData()");
    calendar:Event res1 = check calendarClient->quickAddEvent(testCalendarId1, "Hello", "none");
    calendar:Event res2 = check calendarClient->quickAddEvent(testCalendarId2, "Adios", "none");
    calendar:Event res3 = check calendarClient->quickAddEvent(testCalendarId3, "Holaa", "none");

    string array = SQUARE_BRACKET_LEFT + res1.toJsonString() + COMMA + res2.toJsonString() + COMMA + res3.toJsonString() 
                    + SQUARE_BRACKET_RIGHT;
    string preparedJson = "{"+"\"ballerinax/googleapis.calendar:"+connecterVersion+":Event\""+":"+array+"}";
    check io:fileWriteJson(Event, check preparedJson.cloneWithType(json));

}

function generateWatchResponseData() returns error? {
    log:printInfo("SampleDataGenerator -> generateWatchResponseData()");
    calendar:WatchResponse res1 = check calendarClient->watchEvents(testCalendarId1, address);
    calendar:WatchResponse res2 = check calendarClient->watchEvents(testCalendarId1, address);
    calendar:WatchResponse res3 = check calendarClient->watchEvents(testCalendarId1, address);

    string array = SQUARE_BRACKET_LEFT + res1.toJsonString() + COMMA + res2.toJsonString() + COMMA + res3.toJsonString() 
                    + SQUARE_BRACKET_RIGHT;
    string preparedJson = "{"+"\"ballerinax/googleapis.calendar:"+connecterVersion+":WatchResponse\""+":"+array+"}";
    check io:fileWriteJson(WatchResponse, check preparedJson.cloneWithType(json));
}

function generateEventResponseData() returns error? {
    log:printInfo("SampleDataGenerator -> generateEventResponseData()");
    calendar:EventResponse res1 = check calendarClient->getEventsResponse(testCalendarId1);
    calendar:EventResponse res2 = check calendarClient->getEventsResponse(testCalendarId2);
    calendar:EventResponse res3 = check calendarClient->getEventsResponse(testCalendarId3);

    string array = SQUARE_BRACKET_LEFT + res1.toJsonString() + COMMA + res2.toJsonString() + COMMA + res3.toJsonString() 
                    + SQUARE_BRACKET_RIGHT;
    string preparedJson = "{"+"\"ballerinax/googleapis.calendar:"+connecterVersion+":EventResponse\""+":"+array+"}";
    check io:fileWriteJson(EventResponse, check preparedJson.cloneWithType(json));
}

function generateInputEventData() returns error? {
    log:printInfo("SampleDataGenerator -> generateInputEventData()");

    string array = SQUARE_BRACKET_LEFT + setEvent("Summary1").toJsonString() + COMMA + setEvent("Summary2").toJsonString() 
                    + COMMA + setEvent("Summary3").toJsonString() + SQUARE_BRACKET_RIGHT;
    string preparedJson = "{"+"\"ballerinax/googleapis.calendar:"+connecterVersion+":InputEvent\""+":"+array+"}";
    check io:fileWriteJson(InputEvent, check preparedJson.cloneWithType(json));
}

isolated function setEvent(string data) returns calendar:InputEvent {
    time:Utc time = time:utcNow();
    string startTime =  time:utcToString(time:utcAddSeconds(time, 3600));
    string endTime = time:utcToString(time:utcAddSeconds(time, 7200));
    calendar:InputEvent event = {
        'start: {
            dateTime: startTime
        },
        end: {
            dateTime: endTime
        },
        summary: data,
        description: "Sample description",
        location: "Colombo-LK",
        colorId: "1", //https://lukeboyle.com/blog-posts/2016/04/google-calendar-api---color-id
        id : "12",
        recurrence: ["RRULE:FREQ=WEEKLY;UNTIL=20110701T170000Z"],
        originalStartTime: {dateTime: startTime},
        transparency : "opaque",
        visibility : "default",
        sequence: 1
    };
    return event;  
}

function generateCreateEventOptionalData() returns error? {
    calendar:CreateEventOptional optional1 = {
        conferenceDataVersion: 1,
        sendUpdates: "all",
        supportsAttachments: false,
        maxAttendees : 123
    };

    calendar:CreateEventOptional optional2 = {
        conferenceDataVersion: 2,
        sendUpdates: "all",
        supportsAttachments: false,
        maxAttendees : 423
    };

    calendar:CreateEventOptional optional3 = {
        conferenceDataVersion: 3,
        sendUpdates: "all",
        supportsAttachments: false,
        maxAttendees : 324
    };
    string array = SQUARE_BRACKET_LEFT + optional1.toJsonString() + COMMA + optional2.toJsonString() 
                    + COMMA + optional3.toJsonString() + SQUARE_BRACKET_RIGHT;
    string preparedJson = "{"+"\"ballerinax/googleapis.calendar:"+connecterVersion+":CreateEventOptional\""+":"+array+"}";
    check io:fileWriteJson(CreateEventOptional, check preparedJson.cloneWithType(json));
}

