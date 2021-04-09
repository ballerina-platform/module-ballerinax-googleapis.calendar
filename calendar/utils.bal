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

import ballerina/url;
import ballerina/http;
import ballerina/log;

# Prepare URL.
# 
# + paths - An array of paths prefixes
# + return - The prepared URL
isolated function prepareUrl(string[] paths) returns string {
    string url = EMPTY_STRING;
    if (paths.length() > 0) {
        foreach var path in paths {
            url = (!path.startsWith(FORWARD_SLASH)) ? (url + FORWARD_SLASH) : url;
            url = url + path;
        }
    }
    return <@untainted>url;
}

# Prepare URL with encoded query.
# 
# + paths - An array of paths prefixes
# + queryParamNames - An array of query param names
# + queryParamValues - An array of query param values
# + return - The prepared URL with encoded query
isolated function prepareQueryUrl(string[] paths, string[] queryParamNames, string[] queryParamValues) returns string {
    string url = prepareUrl(paths);
    url = url + QUESTION_MARK;
    boolean first = true;
    int i = 0;
    foreach var name in queryParamNames {
        string value = queryParamValues[i];
        var encoded = url:encode(value, ENCODING_CHARSET);
        if (encoded is string) {
            if (first) {
                url = url + name + EQUAL_SIGN + encoded;
                first = false;
            } else {
                url = url + AMPERSAND + name + EQUAL_SIGN + encoded;
            }
        } else {
            log:printError("Unable to encode value: " + value, 'error = encoded);
            break;
        }
        i = i + 1;
    }
    return url;
}

# Prepare URL with optional parameters.
# 
# + calendarId - Calendar id
# + optional - Record that contains optional parameters
# + eventId - Event id
# + return - The prepared URL with encoded query
isolated function prepareUrlWithEventOptional(string calendarId, CreateEventOptional? optional = (),  string? eventId 
                                                = ()) returns string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS]);
    path = eventId is string ? prepareUrl([path, eventId]) : path;
    if (optional is CreateEventOptional) {
        if (optional.conferenceDataVersion is int) {
            optionalMap[CONFERENCE_DATA_VERSION] = optional.conferenceDataVersion.toString();
        }
        if (optional.maxAttendees is int) {
            optionalMap[MAX_ATTENDEES] = optional.maxAttendees.toString();
        }
        if (optional.sendUpdates is string) {
            optionalMap[SEND_UPDATES] = optional.sendUpdates.toString();
        }
        if (optional.supportsAttachments is boolean) {
            optionalMap[SUPPORTS_ATTACHMENTS] = optional.supportsAttachments.toString();
        }
        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Prepare URL with optional parameters.
# 
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
isolated function prepareUrlWithCalendarOptional(string? pageToken = (), CalendarListOptional? optional = ()) returns
    string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([CALENDAR_PATH, USERS, ME, CALENDAR_LIST]);  
    if (optional is CalendarListOptional) {
        if (optional?.minAccessRole is string) {
            optionalMap[MIN_ACCESS_ROLE] = optional?.minAccessRole.toString();
        }
        if (pageToken is string) {
            optionalMap[PAGE_TOKEN] = pageToken;
        }
        if (optional?.showDeleted is boolean) {
            optionalMap[SHOW_DELETED] = optional?.showDeleted.toString();
        }
        if (optional?.showHidden is boolean) {
            optionalMap[SHOW_HIDDEN] = optional?.showHidden.toString();
        }
        if (optional?.syncToken is string) {
            optionalMap[SYNC_TOKEN] = optional?.syncToken.toString();
        }
        foreach var val in optionalMap {
            value.push(val);
        }
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Prepare URL with optional parameters.
# 
# + calendarId - Record that contains optional parameters
# + count -  Number of events required in one page
# + pageToken - Token for retrieving next page
# + syncToken - Token for getting incremental sync
# + return - The prepared URL with encoded query
isolated function prepareUrlWithEventsOptional(string calendarId, int? count, string? pageToken, string? syncToken)
    returns string {
    string[] value = [];
    map<string> optionals = {};    
    if (count is int) {
        optionals[MAX_RESULTS] = count.toString();
    }
    if (pageToken is string) {
        optionals[PAGE_TOKEN] = pageToken;
    }
    if (syncToken is string) {
        optionals[SYNC_TOKEN] = syncToken;
    }
    foreach var val in optionals {
        value.push(val);
    }
    return <@untainted> prepareQueryUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS], optionals.keys(), value);
}

# Check HTTP response and return JSON payload on success else an error.
# 
# + httpResponse - HTTP respone or HTTP payload or error
# + return - JSON result on success else an error
isolated function checkAndSetErrors(http:Response|http:PayloadType|error httpResponse) returns @tainted json|error {
    if (httpResponse is http:Response) {
        if (httpResponse.statusCode == http:STATUS_OK || httpResponse.statusCode == http:STATUS_CREATED) {
            json|error jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                return jsonResponse;
            } else {
                return error(JSON_ACCESSING_ERROR_MSG, jsonResponse);
            }
        } else if (httpResponse.statusCode == http:STATUS_NO_CONTENT) {
            return {};
        } else {
            json|error jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                json err = check jsonResponse.'error.message;
                return error(HTTP_ERROR_MSG + err.toString());
            } else {
                return error(ERR_EXTRACTING_ERROR_MSG, jsonResponse);
            }
        }
    } else {
        return error(HTTP_ERROR_MSG + (<error>httpResponse).message());
    }
}
