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

import ballerina/oauth2;
import ballerina/http;

# Client for Google Calendar connector.
# 
# + calendarClient - HTTP client endpoint
public client class CalendarClient {

    public http:Client calendarClient;

    public function init(CalendarConfiguration calendarConfig) {
        oauth2:OutboundOAuth2Provider oauth2Provider = new (calendarConfig.oauth2Config);
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);
        http:ClientSecureSocket? socketConfig = calendarConfig?.secureSocketConfig;
        self.calendarClient = new (BASE_URL, {
            auth: {authHandler: bearerHandler},
            secureSocket: socketConfig
        });
    }

    # Create an event.
    # 
    # + calendarId - Calendar id
    # + event - Record that contains event information.
    # + optional - Record that contains optional query parameters
    # + return - Created Event on success else an error
    remote function createEvent(string calendarId, InputEvent event, CreateEventOptional? optional = ()) returns @tainted 
    Event|error {
        json|error payload = event.cloneWithType(InputEvent);
        if (payload is json) {
            http:Request req = new;
            string path = prepareUrlWithOptional(calendarId, optional);
            req.setJsonPayload(payload);
            var response = self.calendarClient->post(path, req);
            json|error result = checkAndSetErrors(response);
            if (result is json) {
                return toEvent(result);
            } else {
                return result;
            }
        } else {
            return payload;
        }
    }

    # Create an event based on a simple text string.
    # 
    # + calendarId - Calendar id
    # + text - Event description
    # + sendUpdates - Configuration for notifing the creation.
    # + return - Created event id on success else an error
    remote function quickAddEvent(string calendarId, string text, string? sendUpdates = ()) 
    returns @tainted Event|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, QUICK_ADD]);
        if (sendUpdates is string) {
            path = prepareQueryUrl([path], [TEXT, SEND_UPDATES], [text, sendUpdates]);
        } else {
            path = prepareQueryUrl([path], [TEXT], [text]);
        }
        var response = self.calendarClient->post(path, ());
        json|error result = checkAndSetErrors(response);
        if (result is json) {
            return toEvent(result);
        } else {
            return result;
        }
    }

    # Update an existing event.
    # 
    # + calendarId - calendar id
    # + eventId - event Id
    # + event - Record that contains updated information
    # + optional - Record that contains optional query parameters
    # + return - Updated event on success else an error
    remote function updateEvent(string calendarId, string eventId, InputEvent event, CreateEventOptional? optional = ()) returns @tainted 
    Event|error {
        json|error payload = event.cloneWithType(InputEvent);
        if (payload is json) {
            http:Request req = new;
            string path = prepareUrlWithOptional(calendarId, optional, eventId);
            req.setJsonPayload(payload);
            var response = self.calendarClient->put(path, req);
            json|error result = checkAndSetErrors(response);
            if (result is json) {
                return toEvent(result);
            } else {
                return result;
            }
        } else {
            return payload;
        }
    }

    # Get all events.
    # 
    # + calendarId - Calendar id
    # + count - Number events required (optional)
    # + syncToken - Token for getting incremental sync
    # + pageToken - Token for retrieving next page
    # + return - List of Event objects on success, else an error
    remote function getEvents(string calendarId, int? count = (), string? syncToken = (), string? pageToken = ()) returns @tainted 
    Event[]|error {
        string[] value = [];
        map<string> optionals = {};
        if (syncToken is string) {
            optionals[SYNC_TOKEN] = syncToken;
        }
        if (count is int) {
            optionals[MAX_RESULT] = count.toString();
        }
        if (pageToken is string) {
            optionals[PAGE_TOKEN] = pageToken;
        }
        optionals.forEach(function(string val) {
            value.push(val);
        });
        string path = prepareQueryUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS], optionals.keys(), value);
        var httpResponse = self.calendarClient->get(path, ());
        json|error resp = checkAndSetErrors(httpResponse);
        if resp is json {
            return toEvents(resp);
        } else {
            return resp;
        }
    }

    # Get an event.
    # 
    # + calendarId - Calendar id
    # + eventId - Event id
    # + return - An Event object on success, else an error 
    remote function getEvent(string calendarId, string eventId) returns @tainted Event|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        var httpResponse = self.calendarClient->get(path, ());
        json|error resp = checkAndSetErrors(httpResponse);
        if resp is json {
            return toEvent(resp);
        } else {
            return resp;
        }
    }

    # Delete an event.
    # 
    # + calendarId - Calendar id
    # + eventId - Event id
    # + return - True on success, else an error
    remote function deleteEvent(string calendarId, string eventId) returns @tainted boolean|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        var httpResponse = self.calendarClient->delete(path, ());
        json|error resp = checkAndSetErrors(httpResponse);
        if resp is json {
            return true;
        } else {
            return resp;
        }
    }

    # Create subscription to get notification.
    # 
    # + calendarId - Calendar id
    # + config - Configuration for the subscription
    # + return - WatchResponse object on success else an error
    remote function watchEvents(string calendarId, WatchConfiguration config) returns @tainted WatchResponse|error {
        json|error payload = config.cloneWithType(json);
        if (payload is json) {
            http:Request req = new;
            string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, WATCH]);
            req.setJsonPayload(payload);
            var response = self.calendarClient->post(path, req);
            json|error result = checkAndSetErrors(response);
            if (result is json) {
                return toWatchResponse(result);
            } else {
                return result;
            }
        } else {
            return payload;
        }
    }

    # Stop channel from subscription
    # 
    # + id - Channel id
    # + resourceId - Id of resource being watched
    # + token - An arbitrary string delivered to the target address with each notification (optional)
    # + return - true on success else an error
    remote function stopChannel(string id, string resourceId, string? token = ()) returns @tainted boolean|error {
        json payload = {
            id: id,
            resourceId: resourceId,
            token: token
        };
        string path = prepareUrl([CALENDAR_PATH, CHANNELS, STOP]);
        http:Request req = new;
        req.setJsonPayload(payload);
        var response = self.calendarClient->post(path, req);
        json|error result = checkAndSetErrors(response);
        if (result is json) {
            return true;
        } else {
            return result;
        }
    }

    # Get event response.
    # 
    # + calendarId - Calendar id
    # + count - Number events required (optional)
    # + syncToken - Token for getting incremental sync
    # + pageToken - Token for retrieving next page
    # + return - List of EventResponse object on success, else an error
    remote function getEventResponse(string calendarId, int? count = (), string? syncToken = (), string? pageToken = ()) returns @tainted 
    EventResponse|error {
        string[] value = [];
        map<string> optionals = {};
        if (syncToken is string) {
            optionals[SYNC_TOKEN] = syncToken;
        }
        if (count is int) {
            optionals[MAX_RESULT] = count.toString();
        }
        if (pageToken is string) {
            optionals[PAGE_TOKEN] = pageToken;
        }
        optionals.forEach(function(string val) {
            value.push(val);
        });
        string path = prepareQueryUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS], optionals.keys(), value);
        var httpResponse = self.calendarClient->get(path, ());
        json|error resp = checkAndSetErrors(httpResponse);
        if resp is json {
            return toEventsUpdated(resp);
        } else {
            return resp;
        }
    }
}

public type CalendarConfiguration record {
    oauth2:DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
};
