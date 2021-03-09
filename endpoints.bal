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

# Client for Google Calendar connector.
# 
# + calendarClient - HTTP client endpoint
@display {
    label: "Google Calendar Client"
}
public client class Client {
    public http:Client calendarClient;
    CalendarConfiguration calendarConfiguration;

    public function init(CalendarConfiguration calendarConfig) {
        self.calendarConfiguration = calendarConfig;
        http:ClientSecureSocket? socketConfig = calendarConfig?.secureSocketConfig;

        self.calendarClient = checkpanic new (BASE_URL, {
            auth: calendarConfig.oauth2Config,
            secureSocket: socketConfig
        });
    }

    # Get Calendars
    # 
    # + optional - Record that contains optionals
    # + return - Stream of Calendars on success else an error
    @display {
        label: "Get calendars"
    }
    remote function getCalendars(@display{label: "Optional query parameters"} CalendarListOptional? optional = ()) 
                                 returns @tainted @display{label: "Stream of Calendars"} stream<Calendar>|error {
        Calendar[] allCalendars = [];
        return getCalendarsStream(self.calendarClient, allCalendars, optional);
    }

    # Create a calendar.
    # 
    # + title - Calendar name
    # + return - Created Event on success else an error
    @display {
        label: "Create calendar"
    }
    remote function createCalendar(@display{label: "Calendar name"} string title) 
                                   returns @tainted @display{label: "Calendar"} CalendarResource|error {
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
    # + return - True on success, else an error
    @display {
        label: "Delete calendar"
    }
    remote function deleteCalendar(@display{label: "Calendar id"} string calendarId) 
                                   returns @tainted @display{label: "Result"} boolean|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId]);
        var httpResponse = self.calendarClient->delete(path);
        json resp = check checkAndSetErrors(httpResponse);
        return true;
    }

    # Create an event.
    # 
    # + calendarId - Calendar id
    # + event - Record that contains event information.
    # + optional - Record that contains optional query parameters
    # + return - Created Event on success else an error
    @display {
        label: "Create event"
    }
    remote function createEvent(@display{label: "Calendar id"} string calendarId, 
                                @display{label: "Event details"} InputEvent event, 
                                @display{label: "Optional query parameters"} CreateEventOptional? optional = ()) 
                                returns @tainted @display{label: "Event"} Event|error {
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
    @display {
        label: "Create quick add event"
    }
    remote function quickAddEvent(@display{label: "Calendar id"} string calendarId, 
                                  @display{label: "Event description"}string text, 
                                  @display{label: "Send updates of creation"} string? sendUpdates = ()) 
                                  returns @tainted @display{label: "Event"} Event|error {
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
    @display {
        label: "Update existing event"
    }
    remote function updateEvent(@display{label: "Calendar id"} string calendarId, 
                                @display{label: "Event id"} string eventId, 
                                @display{label: "Event details"} InputEvent event, 
                                @display{label: "Optional query parameters"} CreateEventOptional? optional = ())
                                returns @tainted @display{label: "Event"} Event|error {
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
    @display {
        label: "Get events"
    }
    remote function getEvents(@display{label: "Calendar id"} string calendarId, 
                              @display{label: "Number of events required (optional)"} int? count = (), 
                              @display{label: "Token for incremental sync (optional)"}string? syncToken = (), 
                              @display{label: "Token for retrieving next page (optional)"} string? pageToken = ())
                              returns @tainted @display{label: "Stream of Event"} stream<Event>|error {
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
    @display {
        label: "Get an event"
    }
    remote function getEvent(@display{label: "Calendar id"} string calendarId, 
                             @display{label: "Event id"} string eventId) 
                             returns @tainted @display{label: "Event"} Event|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        var httpResponse = self.calendarClient->get(path);
        json resp = check checkAndSetErrors(httpResponse);
        return toEvent(resp);
    }

    # Delete an event.
    # 
    # + calendarId - Calendar id
    # + eventId - Event id
    # + return - True on success, else an error
    @display {
        label: "Delete event"
    }
    remote function deleteEvent(@display{label: "Calendar id"} string calendarId, 
                                @display{label: "Event id"} string eventId) 
                                returns @tainted @display{label: "Result"} boolean|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        var httpResponse = self.calendarClient->delete(path);
        json resp = check checkAndSetErrors(httpResponse);
        return true;
    }

    # Create subscription to get notification.
    # 
    # + calendarId - Calendar id
    # + config - Configuration for the subscription
    # + return - WatchResponse object on success else an error
    @display {
        label: "Create notification subscription"
    }
    remote function watchEvents(@display{label: "Calendar id"} string calendarId, 
                                @display{label: "Subscription configuration"} WatchConfiguration config) 
                                returns @tainted @display{label: "Subscription result"} WatchResponse|error {
        json payload = check config.cloneWithType(json);
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
    # + return - true on success else an error
    @display {
        label: "Stop channel from subscription"
    }
    remote function stopChannel(@display{label: "Channel id"} string id, 
                                @display{label: "Resource id"} string resourceId, 
                                @display{label: "An arbitrary string to not being spoofed (optional)"} string? token = 
                                ()) returns @tainted @display{label: "Result"} boolean|error {
        json payload = {
            id: id,
            resourceId: resourceId,
            token: token
        };
        string path = prepareUrl([CALENDAR_PATH, CHANNELS, STOP]);
        http:Request req = new;
        req.setJsonPayload(payload);
        var response = self.calendarClient->post(path, req);
        json result = check checkAndSetErrors(response);
        return true;
    }

    # Get event response.
    # 
    # + calendarId - Calendar id
    # + count - Number events required (optional)
    # + syncToken - Token for getting incremental sync
    # + pageToken - Token for retrieving next page
    # + return - List of EventResponse object on success, else an error
    @display {
        label: "Get event response"
    }
    remote function getEventResponse(@display{label: "Calendar id"} string calendarId, 
                                    @display{label: "Number of events required (optional)"} int? count = (), 
                                    @display{label: "Token for incremental sync (optional)"} string? syncToken = (), 
                                    @display{label: "Token for retrieving next page (optional)"} string? pageToken = ())
                                    returns @tainted @display{label: "Event response"} EventStreamResponse|error {
        EventStreamResponse response = {};
        Event[] allEvents = [];
        return getEventsStream(self.calendarClient, calendarId, response, allEvents, count, syncToken, pageToken);
    }
}

public type CalendarConfiguration record {
    http:OAuth2DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
};
