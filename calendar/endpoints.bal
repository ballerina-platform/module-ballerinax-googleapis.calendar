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
import ballerina/jwt;

# Ballerina Google Calendar connector provides the capability to access Google Calendar API.
# The connector let you perform calendar and event management operations.
# 
# + calendarClient - HTTP client endpoint
@display {label: "Google Calendar", iconPath: "resources/googleapis.calendar.svg"}
public isolated client class Client {
    private final http:Client calendarClient;
    private final ClientOAuth2ExtensionGrantHandler clientHandler;

    # Initializes the connector. During initialization you can pass either http:BearerTokenConfig if you have a bearer
    # token or http:OAuth2RefreshTokenGrantConfig if you have Oauth tokens.
    # Create a Google account and obtain tokens following 
    # [this guide](https://developers.google.com/identity/protocols/oauth2). 
    # 
    # + calendarConfig -  Configurations required to initialize the client
    # + return - An error on failure of initialization or else `()`
    public isolated function init(ConnectionConfig calendarConfig) returns error? {
        if (calendarConfig.auth is (http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig)) {
            self.calendarClient = check new (BASE_URL, calendarConfig);
            self.clientHandler = check new();
        } else {
            self.calendarClient = check new (BASE_URL, {
                secureSocket: calendarConfig.secureSocket
            });
            self.clientHandler = check new(<jwt:IssuerConfig>calendarConfig.auth);
        }
        return;
    }

    # Gets calendars.
    # 
    # + optional - Record that contains optionals
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - Stream of Calendars on success or else an error
    @display {label: "Get Calendars"}
    remote isolated function getCalendars(@display {label: "Calendars to Access"} CalendarsToAccess? optional = (),
                                            @display {label: "User Account"} string? userAccount = ()) returns
                                            @tainted @display {label: "Stream of Calendars"} stream<Calendar,error?>
                                            |error {
        CalendarStream calendarStream = check new CalendarStream(self.calendarClient, self.clientHandler, optional,
            userAccount);
        return new stream<Calendar,error?>(calendarStream);
    }

    # Creates a calendar.
    # 
    # + title - Calendar name
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - Created calendar on success or else an error
    @display {label: "Create Calendar"}
    remote isolated function createCalendar(@display {label: "Calendar Name"} string title,
                                            @display {label: "User Account"} string? userAccount = ())
                                            returns @tainted @display{label: "Calendar"} CalendarResource|error {
        http:Request req = new;
        string path = prepareUrl([CALENDAR_PATH, CALENDAR]);
        json payload = {
            summary: title
        };
        req.setJsonPayload(payload);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->post(path, req, headers = headerMap);
        json result = check checkAndSetErrors(httpResponse);
        return toCalendar(result);
    }

    # Deletes a calendar.
    # 
    # + calendarId - Calendar ID
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - `()` or error on failure
    @display {label: "Delete Calendar"}
    remote isolated function deleteCalendar(@display {label: "Calendar ID"} string calendarId,
                                            @display {label: "User Account"} string? userAccount = ())
                                            returns @tainted error? {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId]);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->delete(path, headers = headerMap);
        _ = check checkAndSetErrors(httpResponse);
        return;
    }

    # Creates an event.
    # 
    # + calendarId - Calendar ID
    # + event - Record that contains event information
    # + optional - Record that contains optional query parameters
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - Created Event on success or else an error
    @display {label: "Create Event"}
    remote isolated function createEvent(@display {label: "Calendar ID"} string calendarId,
                                            @display {label: "Event Details"} InputEvent event,
                                            @display {label: "Events to Access"} EventsToAccess? optional = (),
                                            @display {label: "User Account"} string? userAccount = ())
                                            returns @tainted @display {label: "Event"} Event|error {
        json payload = check event.cloneWithType(json);
        http:Request req = new;
        string path = prepareUrlWithEventOptional(calendarId, optional);
        req.setJsonPayload(payload);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->post(path, req, headers = headerMap);
        json result = check checkAndSetErrors(httpResponse);
        return toEvent(result);
    }
           
    # Creates an event at the moment with simple text.
    # 
    # + calendarId - Calendar ID
    # + text - Event description
    # + sendUpdates - Configuration for notifing the creation
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - Created event on success or else an error
    @display {label: "Create Quick Event"}
    remote isolated function quickAddEvent(@display {label: "Calendar ID"} string calendarId,
                                            @display {label: "Event Description"} string text,
                                            @display {label: "Send Creation Updates"} string? sendUpdates = (),
                                            @display {label: "User Account"} string? userAccount = ())
                                            returns @tainted @display {label: "Event"} Event|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, QUICK_ADD]);
        path = sendUpdates is string ? prepareQueryUrl([path], [TEXT, SEND_UPDATES], [text, sendUpdates])
            : prepareQueryUrl([path], [TEXT], [text]);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->post(path, (), headers = headerMap);
        json result = check checkAndSetErrors(httpResponse);
        return toEvent(result);
    }

    # Updates an existing event.
    # 
    # + calendarId - Calendar ID
    # + eventId - Event ID
    # + event - Record that contains updated information
    # + optional - Record that contains optional query parameters
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - Updated event on success or else an error
    @display {label: "Update Event"}
    remote isolated function updateEvent(@display {label: "Calendar ID"} string calendarId,
                                            @display {label: "Event ID"} string eventId,
                                            @display {label: "Event Details"} InputEvent event,
                                            @display {label: "Events to Access"} EventsToAccess? optional= (),
                                            @display {label: "User Account"} string? userAccount = ())
                                            returns @tainted @display {label: "Event"} Event|error {
        json payload = check event.cloneWithType(json);
        http:Request req = new;
        string path = prepareUrlWithEventOptional(calendarId, optional, eventId);
        req.setJsonPayload(payload);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->put(path, req, headers = headerMap);
        json result = check checkAndSetErrors(httpResponse);
        return toEvent(result);      
    }

    # Gets events.
    # 
    # + calendarId - Calendar ID
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + filter - Record that contains filtering criteria
    # + return - Event stream on success or else an error
    @display {label: "Get Events"}
    remote isolated function getEvents(@display {label: "Calendar ID"} string calendarId,
                                        @display {label: "Filtering Criteria"} EventFilterCriteria? filter = (),
                                        @display {label: "User Account"} string? userAccount = ())
                                        returns @tainted @display {label: "Stream of Events"} stream<Event,error?>|error {
        EventStream eventStream = check new EventStream(self.calendarClient, calendarId, self.clientHandler, filter,
            userAccount);
        return new stream<Event,error?>(eventStream);    
    }

    # Gets an event.
    # 
    # + calendarId - Calendar ID
    # + eventId - Event ID
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - An Event object on success or else an error
    @display {label: "Get Event"}
    remote isolated function getEvent(@display {label: "Calendar ID"} string calendarId,
                                        @display {label: "Event ID"} string eventId,
                                        @display {label: "User Account"} string? userAccount = ())
                                        returns @tainted @display {label: "Event"} Event|error {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->get(path, headerMap);
        json resp = check checkAndSetErrors(httpResponse);
        return toEvent(resp);
    }

    # Deletes an event.
    # 
    # + calendarId - Calendar ID
    # + eventId - Event ID
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - `()` or else an error on failure
    @display {label: "Delete Event"}
    remote isolated function deleteEvent(@display {label: "Calendar ID"} string calendarId,
                                            @display {label: "Event ID"} string eventId,
                                            @display {label: "User Account"} string? userAccount = ())
                                            returns @tainted error? {
        string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS, eventId]);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->delete(path, headers = headerMap);
        _ = check checkAndSetErrors(httpResponse);
        return;
    }

    # Gets events response.
    # 
    # + calendarId - Calendar ID
    # + count - Number of events required in one page
    # + pageToken - Token for retrieving next page
    # + syncToken - Token for getting incremental sync
    # + filter - Record that contains filtering criteria
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - EventResponse object on success or else an error
    @display {label: "Get Events By Page"}
    remote isolated function getEventsResponse(@display {label: "Calendar ID"} string calendarId, 
                                                @display {label: "Number of Events Required"} int? count = (),
                                                @display {label: "Token for Next Page"} string? pageToken = (),
                                                @display {label: "Token for Incremental Sync"} string? syncToken = (),
                                                @display {label: "Filtering Criteria"} EventFilterCriteria? filter 
                                                = (), @display {label: "User Account"} string? userAccount = ()) returns
                                                @tainted @display {label: "Events Response"} EventResponse|error {
        string path = prepareUrlWithEventsOptionalParams(calendarId, count, pageToken, syncToken, filter);
        map<string> headerMap = check setHeaders(self.clientHandler, userAccount);
        http:Response httpResponse = check self.calendarClient->get(path, headerMap);
        json resp = check checkAndSetErrors(httpResponse);
        return toEventResponse(resp);
    }
}

# Holds the parameters used to create a client.
#
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig|http:JwtIssuerConfig auth;
    # The HTTP version understood by the client
    string httpVersion = "1.1";
    # Configurations related to HTTP/1.x protocol
    http:ClientHttp1Settings http1Settings = {};
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings = {};
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with Redirection
    http:FollowRedirects? followRedirects = ();
    # Configurations associated with request pooling
    http:PoolConfiguration? poolConfig = ();
    # HTTP caching related configurations
    http:CacheConfig cache = {};
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig? circuitBreaker = ();
    # Configurations associated with retrying
    http:RetryConfig? retryConfig = ();
    # Configurations associated with cookies
    CookieConfig? cookieConfig = ();
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits = {};
    #SSL/TLS-related options
    http:ClientSecureSocket? secureSocket = ();
|};

# Client configuration for cookies.
#
# + enabled - User agents provide users with a mechanism for disabling or enabling cookies
# + maxCookiesPerDomain - Maximum number of cookies per domain, which is 50
# + maxTotalCookieCount - Maximum number of total cookies allowed to be stored in cookie store, which is 3000
# + blockThirdPartyCookies - User can block cookies from third party responses and refuse to send cookies for third 
#                            party requests, if needed
public type CookieConfig record {|
    boolean enabled = false;
    int maxCookiesPerDomain = 50;
    int maxTotalCookieCount = 3000;
    boolean blockThirdPartyCookies = true;
|};
