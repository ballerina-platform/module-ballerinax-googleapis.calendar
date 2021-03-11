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

import ballerina/http;
import ballerina/uuid;

# Client for Google Calendar connector.
# 
# + calendarClient - HTTP client endpoint
public client class Client {
    public http:Client calendarClient;
    CalendarConfiguration calendarConfiguration;

    public function init(CalendarConfiguration calendarConfig) returns error? {
        self.calendarConfiguration = calendarConfig;
        http:ClientSecureSocket? socketConfig = calendarConfig?.secureSocketConfig;

        self.calendarClient = check new (BASE_URL, {
            auth: calendarConfig.oauth2Config,
            secureSocket: socketConfig
        });
    }

    # Get Calendars
    # 
    # + optional - Record that contains optionals
    # + return - Stream of Calendars on success else an error
    remote function getCalendars(CalendarListOptional? optional = ()) returns @tainted stream<Calendar>|error {
        Calendar[] allCalendars = [];
        return getCalendarsStream(self.calendarClient, allCalendars, optional);
    }

    # Create a calendar.
    # 
    # + title - Calendar name
    # + return - Created Event on success else an error
    remote function createCalendar(string title) returns @tainted CalendarResource|error {
        http:Request req = new;
        string path = prepareUrl([CALENDAR_PATH, CALENDAR]);
        json payload = {
            summary: title
        };
        req.setJsonPayload(payload);
        var response = self.calendarClient->post(path, req);
        json result = check checkAndSetErrors(response);
        return toCalendar(result);
    }

    # Delete a calendar.
    # 
    # + calendarId - Calendar id
    # + return - Error on failure
    remote function deleteCalendar(string calendarId) returns @tainted error? {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId]);
        var httpResponse = self.calendarClient->delete(path);
        _ = check checkAndSetErrors(httpResponse);
    }

    # Create an event.
    # 
    # + calendarId - Calendar id
    # + event - Record that contains event information.
    # + optional - Record that contains optional query parameters
    # + return - Created Event on success else an error
    remote function createEvent(string calendarId, InputEvent event, CreateEventOptional? optional = ()) returns
                                @tainted Event|error {
        json payload = check event.cloneWithType(json);
        http:Request req = new;
        string path = prepareUrlWithEventOptional(calendarId, optional);
        req.setJsonPayload(payload);
        var response = self.calendarClient->post(path, req);
        json result = check checkAndSetErrors(response);
        return toEvent(result);
    }
           
    # Create an event based on a simple text string.
    # 
    # + calendarId - Calendar id
    # + text - Event description
    # + sendUpdates - Configuration for notifing the creation.
    # + return - Created event id on success else an error
    remote function quickAddEvent(string calendarId, string text, string? sendUpdates = ()) returns @tainted 
                                    Event|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, QUICK_ADD]);
        if (sendUpdates is string) {
            path = prepareQueryUrl([path], [TEXT, SEND_UPDATES], [text, sendUpdates]);
        } else {
            path = prepareQueryUrl([path], [TEXT], [text]);
        }
        var response = self.calendarClient->post(path, ());
        json result = check checkAndSetErrors(response);
        return toEvent(result);
    }

    # Update an existing event.
    # 
    # + calendarId - calendar id
    # + eventId - event Id
    # + event - Record that contains updated information
    # + optional - Record that contains optional query parameters
    # + return - Updated event on success else an error
    remote function updateEvent(string calendarId, string eventId, InputEvent event, CreateEventOptional? optional = ())
                                returns @tainted Event|error {
        json payload = check event.cloneWithType(json);
        http:Request req = new;
        string path = prepareUrlWithEventOptional(calendarId, optional, eventId);
        req.setJsonPayload(payload);
        var response = self.calendarClient->put(path, req);
        json result = check checkAndSetErrors(response);
        return toEvent(result);      
    }

    # Get all events.
    # 
    # + calendarId - Calendar id
    # + count - Number events required (optional)
    # + syncToken - Token for getting incremental sync
    # + pageToken - Token for retrieving next page
    # + return - Event stream on success, else an error
    remote function getEvents(string calendarId, int? count = (), string? syncToken = (), string? pageToken = ())
                                returns @tainted stream<Event>|error {
        EventStreamResponse response = check self->getEventResponse(calendarId, count, syncToken, pageToken);
        stream<Event>? events = response?.items;
        if (events is stream<Event>) {
            return events;
        }
        return error(ERR_EVENTS);       
    }

    # Get an event.
    # 
    # + calendarId - Calendar id
    # + eventId - Event id
    # + return - An Event object on success, else an error 
    remote function getEvent(string calendarId, string eventId) returns @tainted Event|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        var httpResponse = self.calendarClient->get(path);
        json resp = check checkAndSetErrors(httpResponse);
        return toEvent(resp);
    }

    # Delete an event.
    # 
    # + calendarId - Calendar id
    # + eventId - Event id
    # + return - Error on failure
    remote function deleteEvent(string calendarId, string eventId) returns @tainted error? {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        var httpResponse = self.calendarClient->delete(path);
        _ = check checkAndSetErrors(httpResponse);
    }

    # Create subscription to get notification.
    # 
    # + calendarId - Calendar id
    # + address - The address where notifications are delivered for this channel
    # + expiration - The time-to-live in seconds for the notification channel
    # + return - WatchResponse object on success else an error
    remote function watchEvents(string calendarId, string address, string? expiration = ()) returns @tainted WatchResponse|error {
        json payload;
        if (expiration is string) {
            payload = {
                id: uuid:createType1AsString(),
                token: uuid:createType1AsString(),
                'type: WEBHOOK,
                address: address,
                params: {
                    ttl: expiration
                }           
            };
        } else {
            payload = {
                id: uuid:createType1AsString(),
                token: uuid:createType1AsString(),
                'type: WEBHOOK,
                address: address         
            };
        }
        http:Request req = new;
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, WATCH]);
        req.setJsonPayload(payload);
        var response = self.calendarClient->post(path, req);
        json result = check checkAndSetErrors(response);
        return toWatchResponse(result);
    }

    # Stop channel from subscription
    # 
    # + id - Channel id
    # + resourceId - Id of resource being watched
    # + token - An arbitrary string delivered to the target address with each notification (optional)
    # + return - Error on failure
    remote function stopChannel(string id, string resourceId, string? token = ()) returns @tainted error? {
        json payload = {
            id: id,
            resourceId: resourceId,
            token: token
        };
        string path = prepareUrl([CALENDAR_PATH, CHANNELS, STOP]);
        http:Request req = new;
        req.setJsonPayload(payload);
        var response = self.calendarClient->post(path, req);
        _ = check checkAndSetErrors(response);
    }

    # Get event response.
    # 
    # + calendarId - Calendar id
    # + count - Number events required (optional)
    # + syncToken - Token for getting incremental sync
    # + pageToken - Token for retrieving next page
    # + return - List of EventResponse object on success, else an error
    remote function getEventResponse(string calendarId, int? count = (), string? syncToken = (), string? pageToken = ())
                                        returns @tainted EventStreamResponse|error {
        EventStreamResponse response = {};
        Event[] allEvents = [];
        return getEventsStream(self.calendarClient, calendarId, response, allEvents, count, syncToken, pageToken);
    }
}

# Holds the parameters used to create a `Client`.
#
# + secureSocketConfig - OAuth2 configuration
# + oauth2Config - Secure socket configuration  
public type CalendarConfiguration record {
    http:OAuth2DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
};
