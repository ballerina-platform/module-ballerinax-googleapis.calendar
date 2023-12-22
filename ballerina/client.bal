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

import ballerina/http;

# Manipulates events and other calendar data.
public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://www.googleapis.com/calendar/v3") returns Error? {
        http:ClientConfiguration httpClientConfig = {auth: config.auth, httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                httpClientConfig.http1Settings = {...settings};
            }
            if config.http2Settings is http:ClientHttp2Settings {
                httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
            }
            if config.cache is http:CacheConfig {
                httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
            }
            if config.responseLimits is http:ResponseLimitConfigs {
                httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
            }
            if config.secureSocket is http:ClientSecureSocket {
                httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
            }
            if config.proxy is http:ProxyConfig {
                httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
            }
            http:Client httpEp = check new (serviceUrl, httpClientConfig);
            self.clientEp = httpEp;
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
        return;
    }

    # Creates a secondary calendar.
    #
    # + payload - Data required to create the calendar.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + return - A `gcalendar:Calendar` if successful, otherwise a `gcalendar:Error`
    resource isolated function post calendars(Calendar payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Calendar|Error {
        string resourcePath = string `/calendars`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns metadata for a calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - A `gcalendar:Calendar` if successful, otherwise a `gcalendar:Error` 
    resource isolated function get calendars/[string calendarId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Calendar|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates metadata for a calendar.
    #
    # + payload - Data required to update the calendar.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - A `gcalendar:Calendar` if successful, otherwise a `gcalendar:Error`
    resource isolated function put calendars/[string calendarId](Calendar payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Calendar|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->put(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - If successful `()`, otherwise a `gcalendar:Error`
    resource isolated function delete calendars/[string calendarId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->delete(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates metadata for a calendar. This method supports patch semantics.
    #
    # + payload - Data required to update the calendar.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - A `gcalendar:Calendar` if successful, otherwise a `gcalendar:Error` 
    resource isolated function patch calendars/[string calendarId](Calendar payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Calendar|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->patch(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns the rules in the access control list for the calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + maxResults - Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
    # + pageToken - Token specifying which result page to return. Optional.
    # + showDeleted - Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
    # + syncToken - Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries.
    # + return - A `gcalendar:Acl` if successful, otherwise a `gcalendar:Error` 
    resource isolated function get calendars/[string calendarId]/acl("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? maxResults = (), string? pageToken = (), boolean? showDeleted = (), string? syncToken = ()) returns Acl|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "maxResults": maxResults, "pageToken": pageToken, "showDeleted": showDeleted, "syncToken": syncToken};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Creates an access control rule.
    #
    # + payload - Data required to create access permissions for the calendar.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + sendNotifications - Whether to send notifications about the calendar sharing change. Optional. The default is True.
    # + return - A `gcalendar:AclRule` if successful, otherwise a `gcalendar:Error` 
    resource isolated function post calendars/[string calendarId]/acl(AclRule payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), boolean? sendNotifications = ()) returns AclRule|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "sendNotifications": sendNotifications};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns an access control rule.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + return - A `gcalendar:AclRule` if successful, otherwise a `gcalendar:Error` 
    resource isolated function get calendars/[string calendarId]/acl/[string ruleId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns AclRule|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates an access control rule.
    #
    # + payload - Data required to update access permissions for the calendar.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + sendNotifications - Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
    # + return - A `gcalendar:AclRule` if successful, otherwise a `gcalendar:Error` 
    resource isolated function put calendars/[string calendarId]/acl/[string ruleId](AclRule payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), boolean? sendNotifications = ()) returns AclRule|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "sendNotifications": sendNotifications};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->put(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Deletes an access control rule.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + return - If successful `()`, otherwise a `gcalendar:Error` 
    resource isolated function delete calendars/[string calendarId]/acl/[string ruleId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->delete(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates an access control rule. This method supports patch semantics.
    #
    # + payload - Data required to update access permissions for the calendar.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + sendNotifications - Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
    # + return - A `gcalendar:AclRule` if successful, otherwise a `gcalendar:Error`
    resource isolated function patch calendars/[string calendarId]/acl/[string ruleId](AclRule payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), boolean? sendNotifications = ()) returns AclRule|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "sendNotifications": sendNotifications};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->patch(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - If successful `()`, otherwise a `gcalendar:Error` 
    resource isolated function post calendars/[string calendarId]/clear("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/clear`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns events on the specified calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventTypes - Event types to return. Optional. Possible values are: 
    # - "default" 
    # - "focusTime" 
    # - "outOfOffice" 
    # - "workingLocation"This parameter can be repeated multiple times to return events of different types. Currently, these are the only allowed values for this field: 
    # - ["default", "focusTime", "outOfOffice"] 
    # - ["default", "focusTime", "outOfOffice", "workingLocation"] 
    # - ["workingLocation"] The default is ["default", "focusTime", "outOfOffice"].
    # Additional combinations of these four event types will be made available in later releases.
    # + iCalUID - Specifies an event ID in the iCalendar format to be provided in the response. Optional. Use this if you want to search for an event by its iCalendar ID.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + maxResults - Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
    # + orderBy - The order of the events returned in the result. Optional. The default is an unspecified, stable order.
    # + pageToken - Token specifying which result page to return. Optional.
    # + privateExtendedProperty - Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
    # + q - Free text search terms to find events that match these terms in the following fields: summary, description, location, attendee's displayName, attendee's email. Optional.
    # + sharedExtendedProperty - Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
    # + showDeleted - Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
    # + showHiddenInvitations - Whether to include hidden invitations in the result. Optional. The default is False.
    # + singleEvents - Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
    # + syncToken - Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All events deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
    # There are several query parameters that cannot be specified together with nextSyncToken to ensure consistency of the client state.
    # These are: 
    # - iCalUID 
    # - orderBy 
    # - privateExtendedProperty 
    # - q 
    # - sharedExtendedProperty 
    # - timeMin 
    # - timeMax 
    # - updatedMin All other query parameters should be the same as for the initial synchronization to avoid undefined behavior. If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries.
    # + timeMax - Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
    # + timeMin - Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
    # + timeZone - Time zone used in the response. Optional. The default is the time zone of the calendar.
    # + updatedMin - Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
    # + return - A `gcalendar:Events` if successful, otherwise a `gcalendar:Error`
    resource isolated function get calendars/[string calendarId]/events("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string[]? eventTypes = (), string? iCalUID = (), int? maxAttendees = (), int? maxResults = (), "startTime"|"updated"? orderBy = (), string? pageToken = (), string[]? privateExtendedProperty = (), string? q = (), string[]? sharedExtendedProperty = (), boolean? showDeleted = (), boolean? showHiddenInvitations = (), boolean? singleEvents = (), string? syncToken = (), string? timeMax = (), string? timeMin = (), string? timeZone = (), string? updatedMin = ()) returns Events|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "eventTypes": eventTypes, "iCalUID": iCalUID, "maxAttendees": maxAttendees, "maxResults": maxResults, "orderBy": orderBy, "pageToken": pageToken, "privateExtendedProperty": privateExtendedProperty, "q": q, "sharedExtendedProperty": sharedExtendedProperty, "showDeleted": showDeleted, "showHiddenInvitations": showHiddenInvitations, "singleEvents": singleEvents, "syncToken": syncToken, "timeMax": timeMax, "timeMin": timeMin, "timeZone": timeZone, "updatedMin": updatedMin};
        map<Encoding> queryParamEncoding = {"eventTypes": {style: FORM, explode: true}, "privateExtendedProperty": {style: FORM, explode: true}, "sharedExtendedProperty": {style: FORM, explode: true}};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam, queryParamEncoding);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Creates an event.
    #
    # + payload - Data required to create an event.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + sendUpdates - Whether to send notifications about the creation of the new event. Note that some emails might still be sent. The default is false.
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + return - A `gcalendar:Event` if successful, otherwise a `gcalendar:Error` 
    resource isolated function post calendars/[string calendarId]/events(Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? conferenceDataVersion = (), int? maxAttendees = (), "all"|"externalOnly"|"none"? sendUpdates = (), boolean? supportsAttachments = ()) returns Event|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "conferenceDataVersion": conferenceDataVersion, "maxAttendees": maxAttendees, "sendUpdates": sendUpdates, "supportsAttachments": supportsAttachments};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Imports an event. This operation is used to add a private copy of an existing event to a calendar.
    #
    # + payload - Data required to import an event.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + return - A `gcalendar:Event` if successful, otherwise a `gcalendar:Error`
    resource isolated function post calendars/[string calendarId]/events/'import(Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? conferenceDataVersion = (), boolean? supportsAttachments = ()) returns Event|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/import`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "conferenceDataVersion": conferenceDataVersion, "supportsAttachments": supportsAttachments};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Creates an event based on a simple text string.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + text - The text describing the event to be created.
    # + sendUpdates - Guests who should receive notifications about the creation of the new event.
    # + return - A `gcalendar:Event` if successful, otherwise a `gcalendar:Error` 
    resource isolated function post calendars/[string calendarId]/events/quickAdd(string text, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), "all"|"externalOnly"|"none"? sendUpdates = ()) returns Event|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/quickAdd`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "text": text, "sendUpdates": sendUpdates};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns an event based on its Google Calendar ID. To retrieve an event using its iCalendar ID, call the events.list method using the iCalUID parameter.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + timeZone - Time zone used in the response. Optional. The default is the time zone of the calendar.
    # + return - A `gcalendar:Event` if successful, otherwise a `gcalendar:Error` 
    resource isolated function get calendars/[string calendarId]/events/[string eventId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? maxAttendees = (), string? timeZone = ()) returns Event|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "maxAttendees": maxAttendees, "timeZone": timeZone};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates an event.
    #
    # + payload - Data required to update the event.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + sendUpdates - Guests who should receive notifications about the event update (for example, title changes, etc.).
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + return - A `gcalendar:Event` if successful, otherwise a `gcalendar:Error` 
    resource isolated function put calendars/[string calendarId]/events/[string eventId](Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? conferenceDataVersion = (), int? maxAttendees = (), "all"|"externalOnly"|"none"? sendUpdates = (), boolean? supportsAttachments = ()) returns Event|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "conferenceDataVersion": conferenceDataVersion, "maxAttendees": maxAttendees, "sendUpdates": sendUpdates, "supportsAttachments": supportsAttachments};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->put(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Deletes an event.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + sendUpdates - Guests who should receive notifications about the deletion of the event.
    # + return - if successful `()`, otherwise a `gcalendar:Error`
    resource isolated function delete calendars/[string calendarId]/events/[string eventId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), "all"|"externalOnly"|"none"? sendUpdates = ()) returns Error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "sendUpdates": sendUpdates};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->delete(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates an event. This method supports patch semantics.
    #
    # + payload - Data required to update the event.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + sendUpdates - Guests who should receive notifications about the event update (for example, title changes, etc.).
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + return - A `gcalendar:Event` if successful, otherwise a `gcalendar:Error` 
    resource isolated function patch calendars/[string calendarId]/events/[string eventId](Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? conferenceDataVersion = (), int? maxAttendees = (), "all"|"externalOnly"|"none"? sendUpdates = (), boolean? supportsAttachments = ()) returns Event|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "conferenceDataVersion": conferenceDataVersion, "maxAttendees": maxAttendees, "sendUpdates": sendUpdates, "supportsAttachments": supportsAttachments};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->patch(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns instances of the specified recurring event.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Recurring event identifier.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + maxResults - Maximum number of events returned on one result page. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
    # + originalStart - The original start time of the instance in the result. Optional.
    # + pageToken - Token specifying which result page to return. Optional.
    # + showDeleted - Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events will still be included if singleEvents is False. Optional. The default is False.
    # + timeMax - Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset.
    # + timeMin - Lower bound (inclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset.
    # + timeZone - Time zone used in the response. Optional. The default is the time zone of the calendar.
    # + return - A `gcalendar:Events` if successful, otherwise a `gcalendar:Error` 
    resource isolated function get calendars/[string calendarId]/events/[string eventId]/instances("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? maxAttendees = (), int? maxResults = (), string? originalStart = (), string? pageToken = (), boolean? showDeleted = (), string? timeMax = (), string? timeMin = (), string? timeZone = ()) returns Events|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}/instances`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "maxAttendees": maxAttendees, "maxResults": maxResults, "originalStart": originalStart, "pageToken": pageToken, "showDeleted": showDeleted, "timeMax": timeMax, "timeMin": timeMin, "timeZone": timeZone};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Moves an event to another calendar, i.e. changes an event's organizer.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier of the source calendar where the event currently is on.
    # + eventId - Event identifier.
    # + destination - Calendar identifier of the target calendar where the event is to be moved to.
    # + sendUpdates - Guests who should receive notifications about the change of the event's organizer.
    # + return - A `gcalendar:Event` if successful, otherwise a `gcalendar:Error`
    resource isolated function post calendars/[string calendarId]/events/[string eventId]/move(string destination, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), "all"|"externalOnly"|"none"? sendUpdates = ()) returns Event|Error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}/move`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "destination": destination, "sendUpdates": sendUpdates};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns the color definitions for calendars and events.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + return - A `gcalendar:Colors` if successful, otherwise a `gcalendar:Error`
    resource isolated function get colors("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Colors|Error {
        string resourcePath = string `/colors`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns free/busy information for a set of calendars.
    #
    # + payload - Data required to return free/busy information.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + return - A `gcalendar:FreeBusyResponse` if successful, otherwise a `gcalendar:Error`
    resource isolated function post freeBusy(FreeBusyRequest payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns FreeBusyResponse|Error {
        string resourcePath = string `/freeBusy`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns the calendars on the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + maxResults - Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
    # + minAccessRole - The minimum access role for the user in the returned entries. Optional. The default is no restriction.
    # + pageToken - Token specifying which result page to return. Optional.
    # + showDeleted - Whether to include deleted calendar list entries in the result. Optional. The default is False.
    # + showHidden - Whether to show hidden entries. Optional. The default is False.
    # + syncToken - Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
    # To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries.
    # + return - A `gcalendar:CalendarList` if successful, otherwise a `gcalendar:Error` 
    resource isolated function get users/me/calendarList("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), int? maxResults = (), "freeBusyReader"|"owner"|"reader"|"writer"? minAccessRole = (), string? pageToken = (), boolean? showDeleted = (), boolean? showHidden = (), string? syncToken = ()) returns CalendarList|Error {
        string resourcePath = string `/users/me/calendarList`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "maxResults": maxResults, "minAccessRole": minAccessRole, "pageToken": pageToken, "showDeleted": showDeleted, "showHidden": showHidden, "syncToken": syncToken};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Inserts an existing calendar into the user's calendar list.
    #
    # + payload - Data required to identify the calendar.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + colorRgbFormat - Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise a `gcalendar:Error` 
    resource isolated function post users/me/calendarList(CalendarListEntry payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), boolean? colorRgbFormat = ()) returns CalendarListEntry|Error {
        string resourcePath = string `/users/me/calendarList`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "colorRgbFormat": colorRgbFormat};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->post(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Returns a calendar from the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise a `gcalendar:Error`
    resource isolated function get users/me/calendarList/[string calendarId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns CalendarListEntry|Error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->get(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates an existing calendar on the user's calendar list.
    #
    # + payload - Data required to update an existing calendar entry on the user's calendar list.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + colorRgbFormat - Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise a `gcalendar:Error`
    resource isolated function put users/me/calendarList/[string calendarId](CalendarListEntry payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), boolean? colorRgbFormat = ()) returns CalendarListEntry|Error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "colorRgbFormat": colorRgbFormat};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->put(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Removes a calendar from the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - If successful `()`, otherwise a `gcalendar:Error` 
    resource isolated function delete users/me/calendarList/[string calendarId]("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = ()) returns Error? {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            return check self.clientEp->delete(resourcePath);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }

    # Updates an existing calendar on the user's calendar list. This method supports patch semantics.
    #
    # + payload - Data required to update an existing calendar entry on the user's calendar list.
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + colorRgbFormat - Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
    # + return - A `gcalendar:CalendarListEntry` if successful, otherwise a `gcalendar:Error`
    resource isolated function patch users/me/calendarList/[string calendarId](CalendarListEntry payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), boolean? colorRgbFormat = ()) returns CalendarListEntry|Error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "colorRgbFormat": colorRgbFormat};
        do {
            resourcePath = resourcePath + check getPathForQueryParam(queryParam);
            http:Request request = new;
            json jsonBody = payload.toJson();
            request.setPayload(jsonBody, "application/json");
            return check self.clientEp->patch(resourcePath, request);
        } on fail var e {
            return error Error(e.message(), e.cause());
        }
    }
}
