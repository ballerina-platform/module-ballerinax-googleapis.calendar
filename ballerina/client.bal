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

import googleapis.gcalendar.oas;

# Manipulates events and other calendar data.
public isolated client class Client {
    final oas:Client genClient;

    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://www.googleapis.com/calendar/v3") returns error? {
        oas:ConnectionConfig connectionConfig = check config.ensureType();
        oas:Client genClient = check new oas:Client(connectionConfig, serviceUrl);
        self.genClient = genClient;
        return;
    }

    # Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error
    resource isolated function delete calendars/[string calendarId](map<string|string[]> headers = {}, *DeleteCalendarQueries queries) returns error? {
        return self.genClient->/calendars/[calendarId].delete(headers, queries);
    }

    # Deletes an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error
    resource isolated function delete calendars/[string calendarId]/acl/[string ruleId](map<string|string[]> headers = {}, *CalendarAclDeleteQueries queries) returns error? {
        return self.genClient->/calendars/[calendarId]/acl/[ruleId].delete(headers, queries);
    }

    # Deletes an event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - if successful `()`, otherwise an error
    resource isolated function delete calendars/[string calendarId]/events/[string eventId](map<string|string[]> headers = {}, *CalendarEventsDeleteQueries queries) returns error? {
        return self.genClient->/calendars/[calendarId]/events/[eventId].delete();
    }

    # Removes a calendar from the user's calendar list.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error
    resource isolated function delete users/me/calendarList/[string calendarId](map<string|string[]> headers = {}, *CalendarCalendarlistDeleteQueries queries) returns error? {
        return self.genClient->/users/me/calendarList/[calendarId].delete();
    }

    # Returns metadata for a calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error
    resource isolated function get calendars/[string calendarId](map<string|string[]> headers = {}, *oas:CalendarCalendarsGetQueries queries) returns Calendar|error {
        return self.genClient->/calendars/[calendarId].get(headers, queries);
    }

    # Returns the rules in the access control list for the calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Acl` if successful, otherwise an error
    resource isolated function get calendars/[string calendarId]/acl(map<string|string[]> headers = {}, *CalendarAclListQueries queries) returns Acl|error {
        return self.genClient->/calendars/[calendarId]/acl(headers, queries);
    }

    # Returns an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error
    resource isolated function get calendars/[string calendarId]/acl/[string ruleId](map<string|string[]> headers = {}, *CalendarAclGetQueries queries) returns AclRule|error {
        return self.genClient->/calendars/[calendarId]/acl/[ruleId].get(headers, queries);
    }

    # Returns events on the specified calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Events` if successful, otherwise an error
    resource isolated function get calendars/[string calendarId]/events(map<string|string[]> headers = {}, *CalendarEventsListQueries queries) returns Events|error {
        return self.genClient->/calendars/[calendarId]/events(headers, queries);
    }

    # Returns an event based on its Google Calendar ID. To retrieve an event using its iCalendar ID, call the events.list method using the iCalUID parameter.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Event` if successful, otherwise an error
    resource isolated function get calendars/[string calendarId]/events/[string eventId](map<string|string[]> headers = {}, *CalendarEventsGetQueries queries) returns Event|error {
        return self.genClient->/calendars/[calendarId]/events/[eventId].get(headers, queries);
    }

    # Returns instances of the specified recurring event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Recurring event identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Events` if successful, otherwise an error
    resource isolated function get calendars/[string calendarId]/events/[string eventId]/instances(map<string|string[]> headers = {}, *CalendarEventsInstancesQueries queries) returns Events|error {
        return self.genClient->/calendars/[calendarId]/events/[eventId]/instances(headers, queries);
    }

    # Returns the color definitions for calendars and events.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Colors` if successful, otherwise an error
    resource isolated function get colors(map<string|string[]> headers = {}, *CalendarColorsGetQueries queries) returns Colors|error {
        return self.genClient->/colors(headers, queries);
    }

    # Returns the calendars on the user's calendar list.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:CalendarList` if successful, otherwise an error
    resource isolated function get users/me/calendarList(map<string|string[]> headers = {}, *CalendarCalendarlistListQueries queries) returns CalendarList|error {
        return self.genClient->/users/me/calendarList.get(headers, queries);
    }

    # Returns a calendar from the user's calendar list.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error
    resource isolated function get users/me/calendarList/[string calendarId](map<string|string[]> headers = {}, *CalendarCalendarlistGetQueries queries) returns CalendarListEntry|error {
        return self.genClient->/users/me/calendarList/[calendarId].get(headers, queries);
    }

    # Updates metadata for a calendar. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the calendar. 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error
    resource isolated function patch calendars/[string calendarId](Calendar payload, map<string|string[]> headers = {}, *CalendarCalendarsPatchQueries queries) returns Calendar|error {
        return self.genClient->/calendars/[calendarId].patch(payload, headers, queries);
    }

    # Updates an access control rule. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update access permissions for the calendar 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error
    resource isolated function patch calendars/[string calendarId]/acl/[string ruleId](AclRule payload, map<string|string[]> headers = {}, *CalendarAclPatchQueries queries) returns AclRule|error {
        return self.genClient->/calendars/[calendarId]/acl/[ruleId].patch(payload, headers, queries);
    }

    # Updates an event. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the event. 
    # + return - A `gcalendar:Event` if successful, otherwise an error
    resource isolated function patch calendars/[string calendarId]/events/[string eventId](Event payload, map<string|string[]> headers = {}, *CalendarEventsPatchQueries queries) returns Event|error {
        return self.genClient->/calendars/[calendarId]/events/[eventId].patch(payload, headers, queries);
    }

    # Updates an existing calendar on the user's calendar list. This method supports patch semantics.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update an existing calendar entry on the user's calendar list 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error
    resource isolated function patch users/me/calendarList/[string calendarId](CalendarListEntry payload, map<string|string[]> headers = {}, *CalendarCalendarlistPatchQueries queries) returns CalendarListEntry|error {
        return self.genClient->/users/me/calendarList/[calendarId].patch(payload, headers, queries);
    }

    # Creates a secondary calendar.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to create the calendar. 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error
    resource isolated function post calendars(Calendar payload, map<string|string[]> headers = {}, *CreateCalendarQueries queries) returns Calendar|error {
        return self.genClient->/calendars.post(payload, headers, queries);
    }

    # Creates an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to create access permissions for the calendar. 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error
    resource isolated function post calendars/[string calendarId]/acl(AclRule payload, map<string|string[]> headers = {}, *CalendarAclInsertQueries queries) returns AclRule|error {
        return self.genClient->/calendars/[calendarId]/acl.post(payload, headers, queries);
    }

    # Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - If successful `()`, otherwise an error
    resource isolated function post calendars/[string calendarId]/clear(map<string|string[]> headers = {}, *CalendarCalendarsClearQueries queries) returns error? {
        return self.genClient->/calendars/[calendarId]/clear.post(headers, queries);
    }

    # Creates an event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to create an event. 
    # + return - A `gcalendar:Event` if successful, otherwise an error
    resource isolated function post calendars/[string calendarId]/events(Event payload, map<string|string[]> headers = {}, *CalendarEventsInsertQueries queries) returns Event|error {
        return self.genClient->/calendars/[calendarId]/events.post(payload, headers, queries);
    }

    # Imports an event. This operation is used to add a private copy of an existing event to a calendar.
    #
    # + payload - Data required to import an event
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Event` if successful, otherwise an error
    resource isolated function post calendars/[string calendarId]/events/'import(Event payload, map<string|string[]> headers = {}, *CalendarEventsImportQueries queries) returns Event|error {
        return self.genClient->/calendars/[calendarId]/events/'import.post(payload, headers, queries);
    }

    # Moves an event to another calendar, i.e. changes an event's organizer.
    #
    # + calendarId - Calendar identifier of the source calendar where the event currently is on.
    # + eventId - Event identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Event` if successful, otherwise an error
    resource isolated function post calendars/[string calendarId]/events/[string eventId]/move(map<string|string[]> headers = {}, *CalendarEventsMoveQueries queries) returns Event|error {
        return self.genClient->/calendars/[calendarId]/events/[eventId]/move.post(headers, queries);
    }

    # Creates an event based on a simple text string.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - A `gcalendar:Event` if successful, otherwise an error
    resource isolated function post calendars/[string calendarId]/events/quickAdd(map<string|string[]> headers = {}, *CalendarEventsQuickaddQueries queries) returns Event|error {
        return self.genClient->/calendars/[calendarId]/events/quickAdd.post(headers, queries);
    }

    # Returns free/busy information for a set of calendars.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to return free/busy information 
    # + return - A `gcalendar:FreeBusyResponse` if successful, otherwise an error
    resource isolated function post freeBusy(FreeBusyRequest payload, map<string|string[]> headers = {}, *CalendarFreebusyQueryQueries queries) returns FreeBusyResponse|error {
        return self.genClient->/freeBusy.post(payload, headers, queries);
    }

    # Inserts an existing calendar into the user's calendar list.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to identify the calendar 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error
    resource isolated function post users/me/calendarList(CalendarListEntry payload, map<string|string[]> headers = {}, *CalendarCalendarlistInsertQueries queries) returns CalendarListEntry|error {
        return self.genClient->/users/me/calendarList.post(payload, headers, queries);
    }

    # Updates metadata for a calendar.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the calendar. 
    # + return - A `gcalendar:Calendar` if successful, otherwise an error
    resource isolated function put calendars/[string calendarId](Calendar payload, map<string|string[]> headers = {}, *CalendarCalendarsUpdateQueries queries) returns Calendar|error {
        return self.genClient->/calendars/[calendarId].put(payload, headers, queries);
    }

    # Updates an access control rule.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update access permissions for the calendar 
    # + return - A `gcalendar:AclRule` if successful, otherwise an error
    resource isolated function put calendars/[string calendarId]/acl/[string ruleId](AclRule payload, map<string|string[]> headers = {}, *CalendarAclUpdateQueries queries) returns AclRule|error {
        return self.genClient->/calendars/[calendarId]/acl/[ruleId].put(payload, headers, queries);
    }

    # Updates an event.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update the event. 
    # + return - A `gcalendar:Event` if successful, otherwise an error
    resource isolated function put calendars/[string calendarId]/events/[string eventId](Event payload, map<string|string[]> headers = {}, *CalendarEventsUpdateQueries queries) returns Event|error {
        return self.genClient->/calendars/[calendarId]/events/[eventId].put(payload, headers, queries);
    }

    # Updates an existing calendar on the user's calendar list.
    #
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + payload - Data required to update an existing calendar entry on the user's calendar list 
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise an error
    resource isolated function put users/me/calendarList/[string calendarId](CalendarListEntry payload, map<string|string[]> headers = {}, *CalendarCalendarlistUpdateQueries queries) returns CalendarListEntry|error {
        return self.genClient->/users/me/calendarList/[calendarId].put(payload, headers, queries);
    }
}
