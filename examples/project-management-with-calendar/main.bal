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
    gcalendar:Client calendarClient = check new ({
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            refreshUrl
        }
    });

    gcalendar:Calendar projectCalendar = check calendarClient->/calendars.post({
        summary: "Software Project - Alex"
    });

    gcalendar:Event codingSession = check calendarClient->/calendars/[<string>projectCalendar.id]/events.post({
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

    gcalendar:Event|error designReview = calendarClient->/calendars/[<string>projectCalendar.id]/events.post({
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

    if designReview is error {
        log:printError(designReview.message());
    }

    gcalendar:Event|error updatedCodingSession = calendarClient->/calendars/[<string>projectCalendar.id]/events/[<string>codingSession.id].put({
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

    if updatedCodingSession is error {
        log:printError(updatedCodingSession.message());
    }

    gcalendar:Event|error milestoneEvent = calendarClient->/calendars/[<string>projectCalendar.id]/events.post({
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

    if milestoneEvent is error {
        log:printError(milestoneEvent.message());
    }
    gcalendar:Events|error projectEvents = calendarClient->/calendars/[<string>projectCalendar.id]/events.get();

    if projectEvents is error {
        log:printError(projectEvents.message());
    }
}
