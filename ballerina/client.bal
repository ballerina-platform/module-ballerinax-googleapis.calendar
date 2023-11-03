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
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://www.googleapis.com/calendar/v3") returns error? {
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
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }

    # Creates a secondary calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + payload - Data required to create the calendar.
    # + return - Successful response 
    remote isolated function createCalendar(Calendar payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns Calendar|error {
        string resourcePath = string `/calendars`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Calendar response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Returns metadata for a calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - Successful response 
    remote isolated function getCalendar(string calendarId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns Calendar|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        Calendar response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Updates metadata for a calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + payload - Data required to update the calendar.
    # + return - Successful response 
    remote isolated function updateCalendar(string calendarId, Calendar payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns Calendar|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Calendar response = check self.clientEp->put(resourcePath, request);
        return response;
    }

    # Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - Successful response 
    remote isolated function deleteCalendar(string calendarId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->delete(resourcePath);
    }

    # Updates metadata for a calendar. This method supports patch semantics.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + payload - Data required to update the calendar.
    # + return - Successful response 
    remote isolated function patchCalendar(string calendarId, Calendar payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns Calendar|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Calendar response = check self.clientEp->patch(resourcePath, request);
        return response;
    }

    # Returns the rules in the access control list for the calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + maxResults - Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
    # + pageToken - Token specifying which result page to return. Optional.
    # + showDeleted - Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
    # + syncToken - Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries.
    # + return - Successful response 
    remote isolated function getAclRulesList(string calendarId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? maxResults = (), string? pageToken = (), boolean? showDeleted = (), string? syncToken = ()) returns Acl|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "maxResults": maxResults, "pageToken": pageToken, "showDeleted": showDeleted, "syncToken": syncToken};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        Acl response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Creates an access control rule.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + sendNotifications - Whether to send notifications about the calendar sharing change. Optional. The default is True.
    # + payload - Data required to create access permissions for the calendar.
    # + return - Successful response 
    remote isolated function createAclRule(string calendarId, AclRule payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? sendNotifications = ()) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "sendNotifications": sendNotifications};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        AclRule response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Watch for changes to ACL resources.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + maxResults - Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
    # + pageToken - Token specifying which result page to return. Optional.
    # + showDeleted - Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
    # + syncToken - Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries.
    # + payload - Data required to monitor and receive updates or changes to a resource.
    # + return - Successful response 
    remote isolated function watchAclResource(string calendarId, Channel payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? maxResults = (), string? pageToken = (), boolean? showDeleted = (), string? syncToken = ()) returns Channel|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/watch`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "maxResults": maxResults, "pageToken": pageToken, "showDeleted": showDeleted, "syncToken": syncToken};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Channel response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Returns an access control rule.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + return - Successful response 
    remote isolated function getAclRule(string calendarId, string ruleId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        AclRule response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Updates an access control rule.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + sendNotifications - Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
    # + payload - Data required to update access permissions for the calendar
    # + return - Successful response 
    remote isolated function updateAclRule(string calendarId, string ruleId, AclRule payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? sendNotifications = ()) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "sendNotifications": sendNotifications};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        AclRule response = check self.clientEp->put(resourcePath, request);
        return response;
    }

    # Deletes an access control rule.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + return - Successful response 
    remote isolated function deleteAclRule(string calendarId, string ruleId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->delete(resourcePath);
    }

    # Updates an access control rule. This method supports patch semantics.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + ruleId - ACL rule identifier.
    # + sendNotifications - Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
    # + payload - Data required to update access permissions for the calendar
    # + return - Successful response 
    remote isolated function patchAclRule(string calendarId, string ruleId, AclRule payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? sendNotifications = ()) returns AclRule|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/acl/${getEncodedUri(ruleId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "sendNotifications": sendNotifications};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        AclRule response = check self.clientEp->patch(resourcePath, request);
        return response;
    }

    # Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - Successful response 
    remote isolated function clearCalendar(string calendarId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/clear`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        return self.clientEp->post(resourcePath, request);
    }

    # Returns events on the specified calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + alwaysIncludeEmail - Deprecated and ignored. A value will always be returned in the email field for the organizer, creator and attendees, even if no real email address is available (i.e. a generated, non-working value will be provided).
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
    # + return - Successful response 
    remote isolated function getEvents(string calendarId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? alwaysIncludeEmail = (), string[]? eventTypes = (), string? iCalUID = (), int? maxAttendees = (), int? maxResults = (), "startTime"|"updated"? orderBy = (), string? pageToken = (), string[]? privateExtendedProperty = (), string? q = (), string[]? sharedExtendedProperty = (), boolean? showDeleted = (), boolean? showHiddenInvitations = (), boolean? singleEvents = (), string? syncToken = (), string? timeMax = (), string? timeMin = (), string? timeZone = (), string? updatedMin = ()) returns Events|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "alwaysIncludeEmail": alwaysIncludeEmail, "eventTypes": eventTypes, "iCalUID": iCalUID, "maxAttendees": maxAttendees, "maxResults": maxResults, "orderBy": orderBy, "pageToken": pageToken, "privateExtendedProperty": privateExtendedProperty, "q": q, "sharedExtendedProperty": sharedExtendedProperty, "showDeleted": showDeleted, "showHiddenInvitations": showHiddenInvitations, "singleEvents": singleEvents, "syncToken": syncToken, "timeMax": timeMax, "timeMin": timeMin, "timeZone": timeZone, "updatedMin": updatedMin};
        map<Encoding> queryParamEncoding = {"eventTypes": {style: FORM, explode: true}, "privateExtendedProperty": {style: FORM, explode: true}, "sharedExtendedProperty": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam, queryParamEncoding);
        Events response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Creates an event.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + sendNotifications - Deprecated. Please use sendUpdates instead.
    # Whether to send notifications about the creation of the new event. Note that some emails might still be sent even if you set the value to false. The default is false.
    # + sendUpdates - Whether to send notifications about the creation of the new event. Note that some emails might still be sent. The default is false.
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + payload - Data required to create an event.
    # + return - Successful response 
    remote isolated function createEvent(string calendarId, Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? conferenceDataVersion = (), int? maxAttendees = (), boolean? sendNotifications = (), "all"|"externalOnly"|"none"? sendUpdates = (), boolean? supportsAttachments = ()) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "conferenceDataVersion": conferenceDataVersion, "maxAttendees": maxAttendees, "sendNotifications": sendNotifications, "sendUpdates": sendUpdates, "supportsAttachments": supportsAttachments};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Event response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Imports an event. This operation is used to add a private copy of an existing event to a calendar.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + payload - Data required to import an event.
    # + return - Successful response 
    remote isolated function importEvent(string calendarId, Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? conferenceDataVersion = (), boolean? supportsAttachments = ()) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/import`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "conferenceDataVersion": conferenceDataVersion, "supportsAttachments": supportsAttachments};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Event response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Creates an event based on a simple text string.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + text - The text describing the event to be created.
    # + sendNotifications - Deprecated. Please use sendUpdates instead.
    # Whether to send notifications about the creation of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
    # + sendUpdates - Guests who should receive notifications about the creation of the new event.
    # + return - Successful response 
    remote isolated function quickaddEvent(string calendarId, string text, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? sendNotifications = (), "all"|"externalOnly"|"none"? sendUpdates = ()) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/quickAdd`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "text": text, "sendNotifications": sendNotifications, "sendUpdates": sendUpdates};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        Event response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Watch for changes to Events resources.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + alwaysIncludeEmail - Deprecated and ignored. A value will always be returned in the email field for the organizer, creator and attendees, even if no real email address is available (i.e. a generated, non-working value will be provided).
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
    # + payload - Data required to monitor and receive updates or changes to a resource
    # + return - Successful response 
    remote isolated function watchEventResource(string calendarId, Channel payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? alwaysIncludeEmail = (), string[]? eventTypes = (), string? iCalUID = (), int? maxAttendees = (), int? maxResults = (), "startTime"|"updated"? orderBy = (), string? pageToken = (), string[]? privateExtendedProperty = (), string? q = (), string[]? sharedExtendedProperty = (), boolean? showDeleted = (), boolean? showHiddenInvitations = (), boolean? singleEvents = (), string? syncToken = (), string? timeMax = (), string? timeMin = (), string? timeZone = (), string? updatedMin = ()) returns Channel|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/watch`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "alwaysIncludeEmail": alwaysIncludeEmail, "eventTypes": eventTypes, "iCalUID": iCalUID, "maxAttendees": maxAttendees, "maxResults": maxResults, "orderBy": orderBy, "pageToken": pageToken, "privateExtendedProperty": privateExtendedProperty, "q": q, "sharedExtendedProperty": sharedExtendedProperty, "showDeleted": showDeleted, "showHiddenInvitations": showHiddenInvitations, "singleEvents": singleEvents, "syncToken": syncToken, "timeMax": timeMax, "timeMin": timeMin, "timeZone": timeZone, "updatedMin": updatedMin};
        map<Encoding> queryParamEncoding = {"eventTypes": {style: FORM, explode: true}, "privateExtendedProperty": {style: FORM, explode: true}, "sharedExtendedProperty": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam, queryParamEncoding);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Channel response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Returns an event based on its Google Calendar ID. To retrieve an event using its iCalendar ID, call the events.list method using the iCalUID parameter.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + alwaysIncludeEmail - Deprecated and ignored. A value will always be returned in the email field for the organizer, creator and attendees, even if no real email address is available (i.e. a generated, non-working value will be provided).
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + timeZone - Time zone used in the response. Optional. The default is the time zone of the calendar.
    # + return - Successful response 
    remote isolated function getEvent(string calendarId, string eventId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? alwaysIncludeEmail = (), int? maxAttendees = (), string? timeZone = ()) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "alwaysIncludeEmail": alwaysIncludeEmail, "maxAttendees": maxAttendees, "timeZone": timeZone};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        Event response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Updates an event.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + alwaysIncludeEmail - Deprecated and ignored. A value will always be returned in the email field for the organizer, creator and attendees, even if no real email address is available (i.e. a generated, non-working value will be provided).
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + sendNotifications - Deprecated. Please use sendUpdates instead.
    # Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
    # + sendUpdates - Guests who should receive notifications about the event update (for example, title changes, etc.).
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + payload - Data required to update the event.
    # + return - Successful response 
    remote isolated function updateEvent(string calendarId, string eventId, Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? alwaysIncludeEmail = (), int? conferenceDataVersion = (), int? maxAttendees = (), boolean? sendNotifications = (), "all"|"externalOnly"|"none"? sendUpdates = (), boolean? supportsAttachments = ()) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "alwaysIncludeEmail": alwaysIncludeEmail, "conferenceDataVersion": conferenceDataVersion, "maxAttendees": maxAttendees, "sendNotifications": sendNotifications, "sendUpdates": sendUpdates, "supportsAttachments": supportsAttachments};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Event response = check self.clientEp->put(resourcePath, request);
        return response;
    }

    # Deletes an event.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + sendNotifications - Deprecated. Please use sendUpdates instead.
    # Whether to send notifications about the deletion of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
    # + sendUpdates - Guests who should receive notifications about the deletion of the event.
    # + return - Successful response 
    remote isolated function deleteEvent(string calendarId, string eventId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? sendNotifications = (), "all"|"externalOnly"|"none"? sendUpdates = ()) returns error? {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "sendNotifications": sendNotifications, "sendUpdates": sendUpdates};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->delete(resourcePath);
    }

    # Updates an event. This method supports patch semantics.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Event identifier.
    # + alwaysIncludeEmail - Deprecated and ignored. A value will always be returned in the email field for the organizer, creator and attendees, even if no real email address is available (i.e. a generated, non-working value will be provided).
    # + conferenceDataVersion - Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + sendNotifications - Deprecated. Please use sendUpdates instead.
    # Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
    # + sendUpdates - Guests who should receive notifications about the event update (for example, title changes, etc.).
    # + supportsAttachments - Whether API client performing operation supports event attachments. Optional. The default is False.
    # + payload - Data required to update the event.
    # + return - Successful response 
    remote isolated function patchEvent(string calendarId, string eventId, Event payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? alwaysIncludeEmail = (), int? conferenceDataVersion = (), int? maxAttendees = (), boolean? sendNotifications = (), "all"|"externalOnly"|"none"? sendUpdates = (), boolean? supportsAttachments = ()) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "alwaysIncludeEmail": alwaysIncludeEmail, "conferenceDataVersion": conferenceDataVersion, "maxAttendees": maxAttendees, "sendNotifications": sendNotifications, "sendUpdates": sendUpdates, "supportsAttachments": supportsAttachments};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Event response = check self.clientEp->patch(resourcePath, request);
        return response;
    }

    # Returns instances of the specified recurring event.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + eventId - Recurring event identifier.
    # + alwaysIncludeEmail - Deprecated and ignored. A value will always be returned in the email field for the organizer, creator and attendees, even if no real email address is available (i.e. a generated, non-working value will be provided).
    # + maxAttendees - The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
    # + maxResults - Maximum number of events returned on one result page. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
    # + originalStart - The original start time of the instance in the result. Optional.
    # + pageToken - Token specifying which result page to return. Optional.
    # + showDeleted - Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events will still be included if singleEvents is False. Optional. The default is False.
    # + timeMax - Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset.
    # + timeMin - Lower bound (inclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset.
    # + timeZone - Time zone used in the response. Optional. The default is the time zone of the calendar.
    # + return - Successful response 
    remote isolated function getEventInstances(string calendarId, string eventId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? alwaysIncludeEmail = (), int? maxAttendees = (), int? maxResults = (), string? originalStart = (), string? pageToken = (), boolean? showDeleted = (), string? timeMax = (), string? timeMin = (), string? timeZone = ()) returns Events|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}/instances`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "alwaysIncludeEmail": alwaysIncludeEmail, "maxAttendees": maxAttendees, "maxResults": maxResults, "originalStart": originalStart, "pageToken": pageToken, "showDeleted": showDeleted, "timeMax": timeMax, "timeMin": timeMin, "timeZone": timeZone};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        Events response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Moves an event to another calendar, i.e. changes an event's organizer.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier of the source calendar where the event currently is on.
    # + eventId - Event identifier.
    # + destination - Calendar identifier of the target calendar where the event is to be moved to.
    # + sendNotifications - Deprecated. Please use sendUpdates instead.
    # Whether to send notifications about the change of the event's organizer. Note that some emails might still be sent even if you set the value to false. The default is false.
    # + sendUpdates - Guests who should receive notifications about the change of the event's organizer.
    # + return - Successful response 
    remote isolated function moveEvent(string calendarId, string eventId, string destination, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? sendNotifications = (), "all"|"externalOnly"|"none"? sendUpdates = ()) returns Event|error {
        string resourcePath = string `/calendars/${getEncodedUri(calendarId)}/events/${getEncodedUri(eventId)}/move`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "destination": destination, "sendNotifications": sendNotifications, "sendUpdates": sendUpdates};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        Event response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Stop watching resources through this channel
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + payload - Data required to identify the channel to be stopped.
    # + return - Successful response 
    remote isolated function stopChannel(Channel payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns error? {
        string resourcePath = string `/channels/stop`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request);
    }

    # Returns the color definitions for calendars and events.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + return - Successful response 
    remote isolated function getColors("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns Colors|error {
        string resourcePath = string `/colors`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        Colors response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Returns free/busy information for a set of calendars.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + payload - Data required to return free/busy information
    # + return - Successful response 
    remote isolated function queryFreebusy(FreeBusyRequest payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns FreeBusyResponse|error {
        string resourcePath = string `/freeBusy`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        FreeBusyResponse response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Returns the calendars on the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
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
    # + return - Successful response 
    remote isolated function getCalendars("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? maxResults = (), "freeBusyReader"|"owner"|"reader"|"writer"? minAccessRole = (), string? pageToken = (), boolean? showDeleted = (), boolean? showHidden = (), string? syncToken = ()) returns CalendarList|error {
        string resourcePath = string `/users/me/calendarList`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "maxResults": maxResults, "minAccessRole": minAccessRole, "pageToken": pageToken, "showDeleted": showDeleted, "showHidden": showHidden, "syncToken": syncToken};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        CalendarList response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Inserts an existing calendar into the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + colorRgbFormat - Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
    # + payload - Data required to identify the calendar
    # + return - Successful response 
    remote isolated function insertCalendarIntoCalendarList(CalendarListEntry payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? colorRgbFormat = ()) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "colorRgbFormat": colorRgbFormat};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        CalendarListEntry response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Watch for changes to CalendarList resources.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
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
    # + payload - Data required to monitor and receive updates or changes to a resource
    # + return - Successful response 
    remote isolated function watchCalendarList(Channel payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? maxResults = (), "freeBusyReader"|"owner"|"reader"|"writer"? minAccessRole = (), string? pageToken = (), boolean? showDeleted = (), boolean? showHidden = (), string? syncToken = ()) returns Channel|error {
        string resourcePath = string `/users/me/calendarList/watch`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "maxResults": maxResults, "minAccessRole": minAccessRole, "pageToken": pageToken, "showDeleted": showDeleted, "showHidden": showHidden, "syncToken": syncToken};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Channel response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Returns a calendar from the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - Successful response 
    remote isolated function getCalendarFromCalendarList(string calendarId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        CalendarListEntry response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Updates an existing calendar on the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + colorRgbFormat - Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
    # + payload - Data required to update an existing calendar entry on the user's calendar list
    # + return - Successful response 
    remote isolated function updateCalendarFromCalendarList(string calendarId, CalendarListEntry payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? colorRgbFormat = ()) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "colorRgbFormat": colorRgbFormat};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        CalendarListEntry response = check self.clientEp->put(resourcePath, request);
        return response;
    }

    # Removes a calendar from the user's calendar list.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + return - Successful response 
    remote isolated function deleteCalendarFromCalendarlist(string calendarId, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns error? {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->delete(resourcePath);
    }

    # Updates an existing calendar on the user's calendar list. This method supports patch semantics.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + calendarId - Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
    # + colorRgbFormat - Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
    # + payload - Data required to update an existing calendar entry on the user's calendar list
    # + return - Successful response 
    remote isolated function patchCalendarFromCalendarList(string calendarId, CalendarListEntry payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), boolean? colorRgbFormat = ()) returns CalendarListEntry|error {
        string resourcePath = string `/users/me/calendarList/${getEncodedUri(calendarId)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "colorRgbFormat": colorRgbFormat};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        CalendarListEntry response = check self.clientEp->patch(resourcePath, request);
        return response;
    }

    # Returns all user settings for the authenticated user.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + maxResults - Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
    # + pageToken - Token specifying which result page to return. Optional.
    # + syncToken - Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries.
    # + return - Successful response 
    remote isolated function getAllUserSettings("json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? maxResults = (), string? pageToken = (), string? syncToken = ()) returns Settings|error {
        string resourcePath = string `/users/me/settings`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "maxResults": maxResults, "pageToken": pageToken, "syncToken": syncToken};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        Settings response = check self.clientEp->get(resourcePath);
        return response;
    }

    # Watch for changes to Settings resources.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + maxResults - Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
    # + pageToken - Token specifying which result page to return. Optional.
    # + syncToken - Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries.
    # + payload - Data required to monitor and receive updates or changes to a settings resource
    # + return - Successful response 
    remote isolated function watchSettings(Channel payload, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = (), int? maxResults = (), string? pageToken = (), string? syncToken = ()) returns Channel|error {
        string resourcePath = string `/users/me/settings/watch`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp, "maxResults": maxResults, "pageToken": pageToken, "syncToken": syncToken};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        Channel response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    # Returns a single user setting.
    #
    # + alt - Data format for the response.
    # + fields - Selector specifying which fields to include in a partial response.
    # + 'key - API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
    # + oauth_token - OAuth 2.0 token for the current user.
    # + prettyPrint - Returns response with indentations and line breaks.
    # + quotaUser - An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
    # + userIp - Deprecated. Please use quotaUser instead.
    # + setting - The id of the user setting.
    # + return - Successful response 
    remote isolated function getUserSetting(string setting, "json"? alt = (), string? fields = (), string? 'key = (), string? oauth_token = (), boolean? prettyPrint = (), string? quotaUser = (), string? userIp = ()) returns Setting|error {
        string resourcePath = string `/users/me/settings/${getEncodedUri(setting)}`;
        map<anydata> queryParam = {"alt": alt, "fields": fields, "key": 'key, "oauth_token": oauth_token, "prettyPrint": prettyPrint, "quotaUser": quotaUser, "userIp": userIp};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        Setting response = check self.clientEp->get(resourcePath);
        return response;
    }
}
