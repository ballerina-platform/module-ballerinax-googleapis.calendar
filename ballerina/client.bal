// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
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

import ballerina/http;

# Manipulates events and other calendar data.
public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://www.googleapis.com/calendar/v3") returns error? {
        http:ClientConfiguration httpClientConfig = {auth: config.auth, httpVersion: config.httpVersion, http1Settings: config.http1Settings, http2Settings: config.http2Settings, timeout: config.timeout, forwarded: config.forwarded, followRedirects: config.followRedirects, poolConfig: config.poolConfig, cache: config.cache, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, cookieConfig: config.cookieConfig, responseLimits: config.responseLimits, secureSocket: config.secureSocket, proxy: config.proxy, socketConfig: config.socketConfig, validation: config.validation, laxDataBinding: config.laxDataBinding};
        self.clientEp = check new (serviceUrl, httpClientConfig);
    }

    # Creates a secondary calendar.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to create the calendar 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error 
    resource isolated function post calendars(Calendar payload, map<string|string[]> headers = {}, *CreateCalendarQueries queries) returns Calendar|error {
        string resourcePath = string `/calendars`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Returns metadata for a calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error 
    resource isolated function get calendars/[string calendarId](map<string|string[]> headers = {}, *CalendarCalendarsGetQueries queries) returns Calendar|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Updates metadata for a calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the calendar 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error 
    resource isolated function put calendars/[string calendarId](Calendar payload, map<string|string[]> headers = {}, *CalendarCalendarsUpdateQueries queries) returns Calendar|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, headers);
    }

    # Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error 
    resource isolated function delete calendars/[string calendarId](map<string|string[]> headers = {}, *DeleteCalendarQueries queries) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Updates metadata for a calendar. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the calendar 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error 
    resource isolated function patch calendars/[string calendarId](Calendar payload, map<string|string[]> headers = {}, *CalendarCalendarsPatchQueries queries) returns Calendar|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, headers);
    }

    # Returns the rules in the access control list for the calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Acl` if successful, otherwise an error 
    resource isolated function get calendars/[string calendarId]/acl(map<string|string[]> headers = {}, *CalendarAclListQueries queries) returns Acl|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Creates an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to create access permissions for the calendar 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error 
    resource isolated function post calendars/[string calendarId]/acl(AclRule payload, map<string|string[]> headers = {}, *CalendarAclInsertQueries queries) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Returns an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + ruleId - ACL rule identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error 
    resource isolated function get calendars/[string calendarId]/acl/[string ruleId](map<string|string[]> headers = {}, *CalendarAclGetQueries queries) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Updates an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + ruleId - ACL rule identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update access permissions for the calendar 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error 
    resource isolated function put calendars/[string calendarId]/acl/[string ruleId](AclRule payload, map<string|string[]> headers = {}, *CalendarAclUpdateQueries queries) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, headers);
    }

    # Deletes an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + ruleId - ACL rule identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error 
    resource isolated function delete calendars/[string calendarId]/acl/[string ruleId](map<string|string[]> headers = {}, *CalendarAclDeleteQueries queries) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Updates an access control rule. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + ruleId - ACL rule identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update access permissions for the calendar 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error 
    resource isolated function patch calendars/[string calendarId]/acl/[string ruleId](AclRule payload, map<string|string[]> headers = {}, *CalendarAclPatchQueries queries) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, headers);
    }

    # Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error 
    resource isolated function post calendars/[string calendarId]/clear(map<string|string[]> headers = {}, *CalendarCalendarsClearQueries queries) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/clear`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Returns events on the specified calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Events` if successful, otherwise an error 
    resource isolated function get calendars/[string calendarId]/events(map<string|string[]> headers = {}, *CalendarEventsListQueries queries) returns Events|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events`;
        map<Encoding> queryParamEncoding = {"eventTypes": {style: FORM, explode: true}, "privateExtendedProperty": {style: FORM, explode: true}, "sharedExtendedProperty": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        return self.clientEp->get(resourcePath, headers);
    }

    # Creates an event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to create an event 
    # + return - A `gcalendar:Event` if successful, otherwise an error 
    resource isolated function post calendars/[string calendarId]/events(Event payload, map<string|string[]> headers = {}, *CalendarEventsInsertQueries queries) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    resource isolated function post calendars/[string calendarId]/events/'import(Event payload, map<string|string[]> headers = {}, *CalendarEventsImportQueries queries) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/import`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Creates an event based on a simple text string.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Event` if successful, otherwise an error 
    resource isolated function post calendars/[string calendarId]/events/quickAdd(map<string|string[]> headers = {}, *CalendarEventsQuickAddQueries queries) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/quickAdd`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Returns an event based on its Google Calendar ID. To retrieve an event using its iCalendar ID, call the events.list method using the iCalUID parameter.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + eventId - Event identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Event` if successful, otherwise an error 
    resource isolated function get calendars/[string calendarId]/events/[string eventId](map<string|string[]> headers = {}, *CalendarEventsGetQueries queries) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Updates an event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + eventId - Event identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the event 
    # + return - A `gcalendar:Event` if successful, otherwise an error 
    resource isolated function put calendars/[string calendarId]/events/[string eventId](Event payload, map<string|string[]> headers = {}, *CalendarEventsUpdateQueries queries) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, headers);
    }

    # Deletes an event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + eventId - Event identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - if successful `()`, otherwise an error 
    resource isolated function delete calendars/[string calendarId]/events/[string eventId](map<string|string[]> headers = {}, *CalendarEventsDeleteQueries queries) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Updates an event. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + eventId - Event identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the event 
    # + return - A `gcalendar:Event` if successful, otherwise an error 
    resource isolated function patch calendars/[string calendarId]/events/[string eventId](Event payload, map<string|string[]> headers = {}, *CalendarEventsPatchQueries queries) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, headers);
    }

    # Returns instances of the specified recurring event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + eventId - Recurring event identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Events` if successful, otherwise an error 
    resource isolated function get calendars/[string calendarId]/events/[string eventId]/instances(map<string|string[]> headers = {}, *CalendarEventsInstancesQueries queries) returns Events|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}/instances`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Moves an event to another calendar, i.e. changes an event's organizer.
    #
    # + calendarId - Calendar identifier of the source calendar where the event currently is on
    # + eventId - Event identifier
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Event` if successful, otherwise an error 
    resource isolated function post calendars/[string calendarId]/events/[string eventId]/move(map<string|string[]> headers = {}, *CalendarEventsMoveQueries queries) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}/move`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Returns the color definitions for calendars and events.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Colors` if successful, otherwise an error 
    resource isolated function get colors(map<string|string[]> headers = {}, *CalendarColorsGetQueries queries) returns Colors|error {
        string resourcePath = string `/colors`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Returns free/busy information for a set of calendars.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to return free/busy information 
    # + return - A `gcalendar:FreeBusyResponse` if successful, otherwise an error 
    resource isolated function post freeBusy(FreeBusyRequest payload, map<string|string[]> headers = {}, *CalendarFreebusyQueryQueries queries) returns FreeBusyResponse|error {
        string resourcePath = string `/freeBusy`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Returns the calendars on the user's calendar list.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:CalendarList` if successful, otherwise an error 
    resource isolated function get users/me/calendarList(map<string|string[]> headers = {}, *CalendarCalendarListListQueries queries) returns CalendarList|error {
        string resourcePath = string `/users/me/calendarList`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Inserts an existing calendar into the user's calendar list.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to identify the calendar 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error 
    resource isolated function post users/me/calendarList(CalendarListEntry payload, map<string|string[]> headers = {}, *CalendarCalendarListInsertQueries queries) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Returns a calendar from the user's calendar list.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error 
    resource isolated function get users/me/calendarList/[string calendarId](map<string|string[]> headers = {}, *CalendarCalendarListGetQueries queries) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Updates an existing calendar on the user's calendar list.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update an existing calendar entry on the user's calendar list 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error 
    resource isolated function put users/me/calendarList/[string calendarId](CalendarListEntry payload, map<string|string[]> headers = {}, *CalendarCalendarListUpdateQueries queries) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, headers);
    }

    # Removes a calendar from the user's calendar list.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error 
    resource isolated function delete users/me/calendarList/[string calendarId](map<string|string[]> headers = {}, *CalendarCalendarListDeleteQueries queries) returns error? {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Updates an existing calendar on the user's calendar list. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update an existing calendar entry on the user's calendar list 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error 
    resource isolated function patch users/me/calendarList/[string calendarId](CalendarListEntry payload, map<string|string[]> headers = {}, *CalendarCalendarListPatchQueries queries) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, headers);
    }
}
