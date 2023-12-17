// Copyright (c) 2023, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

listener http:Listener ep0 = new (9090, config = {host: "localhost"});

service /calendar/v3 on ep0 {

    resource function post calendars("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, @http:Payload Calendar payload) returns OkCalendar {
        OkCalendar okCalendar = {
            body: {
                conferenceProperties: {
                    allowedConferenceSolutionTypes: ["hangoutsMeet"]
                },
                description: "calendar description",
                etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
                id: "b8f24cd945da8adf629e1e680d3a423c197354709c50563e90bbaf9a5a911684@group.calendar.google.com",
                kind: "calendar#calendar",
                location: "Sri Lanka",
                summary: payload.summary,
                timeZone: "UTC"
            }
        };
        return okCalendar;
    }

    resource function get calendars/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns Calendar {
        Calendar calendar = {
            conferenceProperties: {
                allowedConferenceSolutionTypes: ["hangoutsMeet"]
            },
            description: "calendar description",
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            id: calendarId,
            kind: "calendar#calendar",
            location: "Sri Lanka",
            summary: "calendar summary",
            timeZone: "UTC"
        };
        return calendar;
    }

    resource function put calendars/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, @http:Payload Calendar payload) returns Calendar {
        Calendar calendar = {
            conferenceProperties: {
                allowedConferenceSolutionTypes: ["hangoutsMeet"]
            },
            description: payload.description,
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            id: calendarId,
            kind: "calendar#calendar",
            location: payload.location ?: "Sri Lanka",
            summary: payload.summary,
            timeZone: payload.timeZone
        };
        return calendar;
    }

    resource function delete calendars/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns http:Ok {
        return http:OK;
    }

    resource function patch calendars/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, @http:Payload Calendar payload) returns Calendar {
        Calendar calendar = {
            conferenceProperties: {
                allowedConferenceSolutionTypes: ["hangoutsMeet"]
            },
            description: payload.description ?: "calendar description",
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            id: calendarId,
            kind: "calendar#calendar",
            location: payload.location ?: "Sri Lanka",
            summary: payload.summary,
            timeZone: payload.timeZone ?: "UTC"
        };
        calendar.id = calendarId;
        return calendar;
    }

    resource function get calendars/[string calendarId]/acl("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? maxResults, string? pageToken, boolean? showDeleted, string? syncToken) returns Acl {
        Acl acl = {
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            items: [],
            kind: "calendar#acl",
            nextPageToken: "",
            nextSyncToken: ""
        };
        return acl;
    }

    resource function post calendars/[string calendarId]/acl("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, boolean? sendNotifications, @http:Payload AclRule payload) returns OkAclRule {
        OkAclRule okAclRule = {
            body: payload
        };
        return okAclRule;
    }

    resource function get calendars/[string calendarId]/acl/[string ruleId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns AclRule {
        AclRule aclRule = {
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            id: ruleId,
            kind: "calendar#aclRule",
            role: "reader",
            scope: {}
        };
        return aclRule;
    }

    resource function put calendars/[string calendarId]/acl/[string ruleId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, @http:Payload AclRule payload) returns AclRule {
        AclRule aclRule = {
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            id: ruleId,
            kind: "calendar#aclRule",
            role: payload.role,
            scope: payload.scope
        };
        return aclRule;
    }

    resource function delete calendars/[string calendarId]/acl/[string ruleId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns http:Ok {
        return http:OK;
    }

    resource function patch calendars/[string calendarId]/acl/[string ruleId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, boolean? sendNotifications, @http:Payload AclRule payload) returns AclRule {
        AclRule aclRule = {
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            id: ruleId,
            kind: "calendar#aclRule",
            role: payload.role,
            scope: payload.scope
        };
        return aclRule;
    }

    resource function post calendars/[string calendarId]/clear("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns http:Ok {
        return http:OK;
    }

    resource function get calendars/[string calendarId]/events("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, string[]? eventTypes, string? iCalUID, int? maxAttendees, int? maxResults, "startTime"|"updated"? orderBy, string? pageToken, string[]? privateExtendedProperty, string? q, string[]? sharedExtendedProperty, boolean? showDeleted, boolean? showHiddenInvitations, boolean? singleEvents, string? syncToken, string? timeMax, string? timeMin, string? timeZone, string? updatedMin) returns Events {
        Events events = {
            accessRole: "reader",
            defaultReminders: [],
            description: "Calendar Description",
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            items: [
                {
                    anyoneCanAddSelf: false,
                    attachments: [],
                    attendees: [],
                    attendeesOmitted: false,
                    colorId: "1",
                    conferenceData: {
                        conferenceId: "conference_id",
                        conferenceSolution: {
                            iconUri: "https://www.gstatic.com/images/icons/material/product/2x/hangoutsMeet_48dp.png",
                            key: {
                                'type: "hangoutsMeet"
                            },
                            name: "Hangouts Meet"
                        },
                        createRequest: {
                            conferenceSolutionKey: {
                                'type: "hangoutsMeet"
                            },
                            requestId: "request_id"
                        },
                        entryPoints: [
                            {
                                accessCode: "access_code",
                                entryPointFeatures: ["video", "phone"],
                                entryPointType: "video",
                                label: "label",
                                meetingCode: "meeting_code",
                                passcode: "passcode",
                                password: "password",
                                pin: "pin",
                                regionCode: "region_code",
                                uri: "https://meet.google.com/abc-defg-hij"
                            }
                        ],
                        notes: "notes",
                        signature: "signature"
                    },
                    created: "2022-01-01T00:00:00Z",
                    creator: {
                        displayName: "creator display name",
                        email: ""
                    }
                }
            ],
            kind: "calendar#events",
            nextPageToken: "",
            nextSyncToken: "",
            summary: "Calendar Summary",
            timeZone: "GMT",
            updated: "2022-01-01T00:00:00Z"
        };
        return events;
    }

    resource function post calendars/[string calendarId]/events("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? conferenceDataVersion, int? maxAttendees, "all"|"externalOnly"|"none"? sendUpdates, boolean? supportsAttachments, @http:Payload Event payload) returns OkEvent {
        OkEvent okEvent = {
            body: payload
        };
        okEvent.body.id = calendarId;
        return okEvent;
    }

    resource function post calendars/[string calendarId]/events/'import("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? conferenceDataVersion, boolean? supportsAttachments, @http:Payload Event payload) returns OkEvent {
        OkEvent okEvent = {
            body: payload
        };
        return okEvent;
    }

    resource function post calendars/[string calendarId]/events/quickAdd("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, string text, "all"|"externalOnly"|"none"? sendUpdates) returns OkEvent {
        OkEvent okEvent = {
            body: {
                summary: text
            }
        };
        return okEvent;
    }

    resource function put calendars/[string calendarId]/events/[string eventId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? conferenceDataVersion, int? maxAttendees, "all"|"externalOnly"|"none"? sendUpdates, boolean? supportsAttachments, @http:Payload Event payload) returns Event {
        Event event = payload;
        event.id = eventId;
        event.iCalUID = calendarId;
        return event;
    }

    resource function delete calendars/[string calendarId]/events/[string eventId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, "all"|"externalOnly"|"none"? sendUpdates) returns http:Ok {
        return http:OK;
    }

    resource function patch calendars/[string calendarId]/events/[string eventId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? conferenceDataVersion, int? maxAttendees, "all"|"externalOnly"|"none"? sendUpdates, boolean? supportsAttachments, @http:Payload Event payload) returns Event {
        Event event = payload;
        event.id = eventId;
        event.iCalUID = calendarId;
        return event;
    }

    resource function get calendars/[string calendarId]/events/[string eventId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? maxAttendees, int? maxResults, string? originalStart, string? pageToken, boolean? showDeleted, string? timeMax, string? timeMin, string? timeZone) returns Event {
        Event event = {
            id: eventId,
            anyoneCanAddSelf: false,
            attachments: [],
            attendees: [],
            attendeesOmitted: false,
            colorId: "1",
            conferenceData: {
                conferenceId: "conference_id",
                conferenceSolution: {
                    iconUri: "https://www.gstatic.com/images/icons/material/product/2x/hangoutsMeet_48dp.png",
                    key: {
                        'type: "hangoutsMeet"
                    },
                    name: "Hangouts Meet"
                },
                createRequest: {
                    conferenceSolutionKey: {
                        'type: "hangoutsMeet"
                    },
                    requestId: "request_id"
                },
                entryPoints: [
                    {
                        accessCode: "access_code",
                        entryPointFeatures: ["video", "phone"],
                        entryPointType: "video",
                        label: "label",
                        meetingCode: "meeting_code",
                        passcode: "passcode",
                        password: "password",
                        pin: "pin",
                        regionCode: "region_code",
                        uri: "https://meet.google.com/abc-defg-hij"
                    }
                ],
                notes: "notes",
                signature: "signature"
            },
            created: "2022-01-01T00:00:00Z",
            creator: {
                displayName: "creator display name",
                email: ""
            }
        };
        return event;
    }

    resource function get calendars/[string calendarId]/events/[string eventId]/instances("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? maxAttendees, int? maxResults, string? originalStart, string? pageToken, boolean? showDeleted, string? timeMax, string? timeMin, string? timeZone) returns Events {
        Events events = {
            accessRole: "reader",
            defaultReminders: [],
            description: "Calendar Description",
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            items: [
                {
                    anyoneCanAddSelf: false,
                    attachments: [],
                    attendees: [],
                    attendeesOmitted: false,
                    colorId: "1",
                    conferenceData: {
                        conferenceId: "conference_id",
                        conferenceSolution: {
                            iconUri: "https://www.gstatic.com/images/icons/material/product/2x/hangoutsMeet_48dp.png",
                            key: {
                                'type: "hangoutsMeet"
                            },
                            name: "Hangouts Meet"
                        },
                        createRequest: {
                            conferenceSolutionKey: {
                                'type: "hangoutsMeet"
                            },
                            requestId: "request_id"
                        },
                        entryPoints: [
                            {
                                accessCode: "access_code",
                                entryPointFeatures: ["video", "phone"],
                                entryPointType: "video",
                                label: "label",
                                meetingCode: "meeting_code",
                                passcode: "passcode",
                                password: "password",
                                pin: "pin",
                                regionCode: "region_code",
                                uri: "https://meet.google.com/abc-defg-hij"
                            }
                        ],
                        notes: "notes",
                        signature: "signature"
                    },
                    created: "2022-01-01T00:00:00Z",
                    creator: {
                        displayName: "creator display name",
                        email: ""
                    }
                }
            ],
            kind: "calendar#events",
            nextPageToken: "",
            nextSyncToken: "",
            summary: "Calendar Summary",
            timeZone: "GMT",
            updated: "2022-01-01T00:00:00Z"
        };
        return events;
    }

    resource function post calendars/[string calendarId]/events/[string eventId]/move("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, string destination, "all"|"externalOnly"|"none"? sendUpdates) returns OkEvent {
        OkEvent okEvent = {
            body: {
                iCalUID: destination,
                id: eventId
            }
        };
        return okEvent;
    }

    resource function get colors("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns Colors {
        Colors colors = {
            calendar: {},
            event: {},
            kind: "calendar#colors",
            updated: "2022-01-01T00:00:00Z"
        };
        return colors;
    }

    resource function post freeBusy("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, @http:Payload FreeBusyRequest payload) returns OkFreeBusyResponse {
        OkFreeBusyResponse response = {
            body: {
                calendars: {},
                groups: {},
                kind: "calendar#freeBusy",
                timeMax: "2022-01-01T00:00:00Z",
                timeMin: "2022-01-01T00:00:00Z"
            }
        };
        return response;
    }

    resource function get users/me/calendarList("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, int? maxResults, "freeBusyReader"|"owner"|"reader"|"writer"? minAccessRole, string? pageToken, boolean? showDeleted, boolean? showHidden, string? syncToken) returns CalendarList {
        CalendarList calendarList = {
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            items: [
                {
                    accessRole: "reader",
                    backgroundColor: "#ffffff",
                    colorId: "1",
                    conferenceProperties: {
                        allowedConferenceSolutionTypes: ["hangoutsMeet"]
                    },
                    defaultReminders: [],
                    deleted: false,
                    description: "Calendar Description",
                    etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
                    foregroundColor: "#000000",
                    hidden: false,
                    id: ""
                }
            ],
            kind: "calendar#calendarList",
            nextPageToken: "",
            nextSyncToken: ""
        };
        return calendarList;
    }

    resource function post users/me/calendarList("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, boolean? colorRgbFormat, @http:Payload CalendarListEntry payload) returns OkCalendarListEntry {
        OkCalendarListEntry okEntry = {
            body: payload
        };
        return okEntry;
    }

    resource function get users/me/calendarList/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns CalendarListEntry {
        CalendarListEntry entry = {
            accessRole: "reader",
            backgroundColor: "#ffffff",
            colorId: "1",
            conferenceProperties: {
                allowedConferenceSolutionTypes: ["hangoutsMeet"]
            },
            defaultReminders: [],
            deleted: false,
            description: "Calendar Description",
            etag: "\"Syw9JucVAl83XRddaXunDD-xXrY\"",
            foregroundColor: "#000000",
            hidden: false,
            id: calendarId,
            kind: "calendar#calendarListEntry",
            location: "Sri Lanka",
            notificationSettings: {
                notifications: []
            },
            primary: false,
            selected: true,
            summary: "Calendar Summary",
            summaryOverride: "Calendar Summary Override",
            timeZone: "GMT"
        };
        return entry;
    }

    resource function put users/me/calendarList/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, boolean? colorRgbFormat, @http:Payload CalendarListEntry payload) returns CalendarListEntry {
        CalendarListEntry entry = payload;
        return entry;
    }

    resource function delete users/me/calendarList/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser) returns http:Ok {
        return http:OK;
    }

    resource function patch users/me/calendarList/[string calendarId]("json"? alt, string? fields, string? 'key, string? oauth_token, boolean? prettyPrint, string? quotaUser, boolean? colorRgbFormat, @http:Payload CalendarListEntry payload) returns CalendarListEntry {
        CalendarListEntry entry = payload;
        return entry;
    }
}
