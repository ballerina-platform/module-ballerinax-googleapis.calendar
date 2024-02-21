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

import ballerina/log;
import ballerinax/googleapis.gcalendar;
import ballerina/os;

configurable string clientId = os:getEnv("CLIENT_ID");
configurable string clientSecret = os:getEnv("CLIENT_SECRET");
configurable string refreshToken = os:getEnv("REFRESH_TOKEN");
configurable string refreshUrl = os:getEnv("REFRESH_URL");

public function main() returns error? {
    gcalendar:Client calendar = check new ({
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            refreshUrl
        }
    });

    gcalendar:Calendar projectCalendar = check calendar->/calendars.post({
        summary: "Software Project"
    });
    string calendarId = <string>projectCalendar.id;

    gcalendar:Event codingSession = check calendar->/calendars/[calendarId]/events.post({
        'start: {
            dateTime: "2023-10-20T10:00:00+00:00",
            timeZone: "UTC"
        },
        end: {
            dateTime: "2023-10-20T12:00:00+00:00",
            timeZone: "UTC"
        },
        summary: "Code Review"
    });
    string codingSessionId = <string>codingSession.id;

    gcalendar:Event|gcalendar:Error designReview = calendar->/calendars/[calendarId]/events.post({
        'start: {
            dateTime: "2023-10-25T14:00:00+00:00",
            timeZone: "UTC"
        },
        end: {
            dateTime: "2023-10-25T16:00:00+00:00",
            timeZone: "UTC"
        },
        summary: "Design Review"
    });

    if designReview is gcalendar:Error {
        log:printError(designReview.message());
    }

    gcalendar:Event|gcalendar:Error updatedCodingSession = calendar->/calendars/[calendarId]/events/[codingSessionId].put({
        'start: {
            dateTime: "2023-10-20T10:00:00+00:00",
            timeZone: "UTC"
        },
        end: {
            dateTime: "2023-10-20T12:00:00+00:00",
            timeZone: "UTC"
        },
        summary: "Code Review - Team A",
        attendees: [
            {
                "email": "team-member1@gmail.com"
            },
            {
                "email": "team-member2@gmail.com"
            }
        ]
    });

    if updatedCodingSession is gcalendar:Error {
        log:printError(updatedCodingSession.message());
    }

    gcalendar:Event|gcalendar:Error milestoneEvent = calendar->/calendars/[calendarId]/events.post({
        'start: {
            dateTime: "2023-11-15T09:00:00+00:00",
            timeZone: "UTC"
        },
        end: {
            dateTime: "2023-11-15T17:00:00+00:00",
            timeZone: "UTC"
        },
        summary: "Project Beta Release",
        reminders: {
            useDefault: false,
            overrides: [
                {
                    method: "popup",
                    minutes: 60
                },
                {
                    method: "email",
                    minutes: 1440
                }
            ]
        }
    });

    if milestoneEvent is gcalendar:Error {
        log:printError(milestoneEvent.message());
    }

    gcalendar:Events|gcalendar:Error projectEvents = calendar->/calendars/[calendarId]/events.get();
    if projectEvents is gcalendar:Error {
        log:printError(projectEvents.message());
    }
}
