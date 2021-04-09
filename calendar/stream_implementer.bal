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

import ballerina/http;

class EventStream {
    private Event[] currentEntries = [];
    private int index = 0;
    private final http:Client httpClient;
    private final int? count;
    private final string? syncToken;
    private string? pageToken;
    private final string calendarId;

    isolated function init(http:Client httpClient, string calendarId, int? count, string? syncToken, string? pageToken)
        {
        self.httpClient = httpClient;
        self.count = count;
        self.syncToken = syncToken;
        self.pageToken = pageToken;
        self.calendarId = calendarId;
        self.currentEntries = checkpanic self.fetchEvents();
    }

    public isolated function next() returns @tainted record {| Event value; |}|error? {
        if (self.index < self.currentEntries.length()) {
            record {| Event value; |} document = {value: self.currentEntries[self.index]};
            self.index += 1;
            return document;
        }
        if (self.pageToken is string) {
            self.index = 0;
            self.currentEntries = check self.fetchEvents();
            record {| Event value; |} event = {value: self.currentEntries[self.index]};
            self.index += 1;
            return event;
        }
    }

    isolated function fetchEvents() returns @tainted Event[]|error {
        string path = <@untainted>prepareUrlWithEventsOptional(self.calendarId, self.count, self.syncToken, self.
            pageToken);
        var httpResponse = check self.httpClient->get(path);
        json resp = check checkAndSetErrors(httpResponse);
        EventResponse|error res = resp.cloneWithType(EventResponse);
        if (res is EventResponse) {
            self.pageToken = res?.nextPageToken;
            return res.items;
        } else {
            return error(ERR_EVENT_RESPONSE, res);
        }
    }
}

class CalendarStream {
    private Calendar[] currentEntries = [];
    int index = 0;
    private final http:Client httpClient;
    private CalendarListOptional? optional;
    private string? pageToken;

    isolated function init(http:Client httpClient, CalendarListOptional? optional = ()) {
        self.httpClient = httpClient;
        self.optional = optional;
        self.pageToken = EMPTY_STRING;
        self.currentEntries = checkpanic self.fetchCalendars();
    }

    public isolated function next() returns @tainted record {| Calendar value; |}|error? {
        if (self.index < self.currentEntries.length()) {
            record {| Calendar value; |} calendar = {value: self.currentEntries[self.index]};
            self.index += 1;
            return calendar;
        }

        if (self.pageToken is string) {
            self.index = 0;
            self.currentEntries = check self.fetchCalendars();
            record {| Calendar value; |} calendar = {value: self.currentEntries[self.index]};
            self.index += 1;
            return calendar;
        }
    }

    isolated function fetchCalendars() returns @tainted Calendar[]|error {
        string path = <@untainted>prepareUrlWithCalendarOptional(self.pageToken, self.optional);
        var httpResponse = check self.httpClient->get(path);
        json resp = check checkAndSetErrors(httpResponse);
        CalendarResponse|error res = resp.cloneWithType(CalendarResponse);
        if (res is CalendarResponse) {
            self.pageToken = res?.nextPageToken;
            return res.items;
        } else {
            return error(ERR_CALENDAR_RESPONSE, res);
        }
    }
}
