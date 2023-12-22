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

import ballerinax/googleapis.gcalendar;
import ballerina/log;
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

    // create new calendar
    gcalendar:Calendar calendarResult = check calendarClient->/calendars.post({
        summary: "Work Schedule"
    });

    // create new event
    gcalendar:Event event = check calendarClient->/calendars/[<string>calendarResult.id]/events.post({
        'start: {
            dateTime: "2023-10-19T09:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-19T09:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: "Project Kickoff Meeting"
    });

    // update event to invite attendees by email
    gcalendar:Event updatedEvent = check calendarClient->/calendars/[<string>calendarResult.id]/events/[<string>event.id].put({
        'start: {
            dateTime: "2023-10-19T09:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-19T09:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        summary: "Team Meeting",
        location: "Conference Room",
        description: "Weekly team meeting to discuss project status.",
        attendees: [
            {
                "email": "team-member1@gmail.com"
            },
            {
                "email": "team-member2@gmail.com"
            }
        ]
    });

    // update event to add reminders to send timely notifications to attendees before the meeting
    gcalendar:Event|error reminderEvent = calendarClient->/calendars/[<string>calendarResult.id]/events/[<string>updatedEvent.id].put({
        'start: {
            dateTime: "2023-10-19T03:00:00+05:30",
            timeZone: "Asia/Colombo"
        },
        end: {
            dateTime: "2023-10-19T03:30:00+05:30",
            timeZone: "Asia/Colombo"
        },
        reminders: {
            useDefault: false,
            overrides: [
                {method: "popup", minutes: 15},
                {method: "email", minutes: 30}
            ]
        }
    });

    if reminderEvent is error {
        log:printError(reminderEvent.message());
    }

    // create access control rule and assign it to a team member
    gcalendar:AclRule acl = check calendarClient->/calendars/[<string>calendarResult.id]/acl.post({
        scope: {
            'type: "user",
            value: "team_member@gmail.com"
        },
        role: "reader"
    });

    // change access control rule
    gcalendar:AclRule|error response = calendarClient->/calendars/[<string>calendarResult.id]/acl/[<string>acl.id].put({
        scope: {
            'type: "user",
            value: "team_member@gmail.com"
        },
        role: "writer"
    });
    if response is error {
        log:printError(response.message());
    }
}
