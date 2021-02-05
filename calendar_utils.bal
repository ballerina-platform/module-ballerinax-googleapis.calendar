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

import ballerina/encoding;
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
            if (!path.startsWith(FORWARD_SLASH)) {
                url = url + FORWARD_SLASH;
            }
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
isolated function prepareQueryUrl(string[] paths, string[] queryParamNames, string[] queryParamValues) 
returns string {
    string url = prepareUrl(paths);
    url = url + QUESTION_MARK;
    boolean first = true;
    int i = 0;
    foreach var name in queryParamNames {
        string value = queryParamValues[i];
        var encoded = encoding:encodeUriComponent(value, ENCODING_CHARSET);
        if (encoded is string) {
            if (first) {
                url = url + name + EQUAL_SIGN + encoded;
                first = false;
            } else {
                url = url + AMPERSAND + name + EQUAL_SIGN + encoded;
            }
        } else {
            log:printError("Unable to encode value: " + value, err = encoded);
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
function prepareUrlWithEventOptional(string calendarId, CreateEventOptional? optional = (), 
string? eventId = ()) returns string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS]);
    if (eventId is string) {
        path = prepareUrl([path, eventId]);
    }   
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
        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
}

# Prepare URL with optional parameters.
# 
# + optional - Record that contains optional parameters
# + return - The prepared URL with encoded query
function prepareUrlWithCalendarOptional(CalendarListOptional? optional = ()) returns string {
    string[] value = [];
    map<string> optionalMap = {};
    string path = prepareUrl([CALENDAR_PATH, USERS, ME, CALENDAR_LIST]);  
    if (optional is CalendarListOptional) {
        if (optional.minAccessRole is string) {
            optionalMap[MIN_ACCESS_ROLE] = optional.minAccessRole.toString();
        }
        if (optional.pageToken is string) {
            optionalMap[PAGE_TOKEN] = optional.pageToken.toString();
        }
        if (optional.showDeleted is boolean) {
            optionalMap[SHOW_DELETED] = optional.showDeleted.toString();
        }
        if (optional.showHidden is boolean) {
            optionalMap[SHOW_HIDDEN] = optional.showHidden.toString();
        }
        if (optional.syncToken is string) {
            optionalMap[SYNC_TOKEN] = optional.syncToken.toString();
        }
        optionalMap.forEach(function(string val) {
            value.push(val);
        });
        path = prepareQueryUrl([path], optionalMap.keys(), value);
    }
    return path;
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
                return error(HTTP_ERROR_MSG + jsonResponse.'error.message.toString());
            } else {
                return error(ERR_EXTRACTING_ERROR_MSG, jsonResponse);
            }
        }
    } else {
        return error(HTTP_ERROR_MSG + (<error>httpResponse).message());
    }
}

# Get events stream.
# 
# + calendarClient - Calendar client
# + calendarId - Calendar id
# + response - EventStreamResponse record
# + events - Event array
# + count - Number events required (optional)
# + syncToken - Token for getting incremental sync
# + pageToken - Token for retrieving next page
# + return - EventStreamResponse record on success, else an error
function getEventsStream(http:Client calendarClient, string calendarId, @tainted EventStreamResponse 
response, @tainted Event[] events, int? count = (), string? syncToken = (), string? pageToken = ()) 
returns @tainted EventStreamResponse|error {
    string[] value = [];
    map<string> optionals = {};
    if (syncToken is string) {
        optionals[SYNC_TOKEN] = syncToken;
    }
    if (count is int) {
        optionals[MAX_RESULTS] = count.toString();
    }
    if (pageToken is string) {
        optionals[PAGE_TOKEN] = pageToken;
    }
    optionals.forEach(function(string val) {
        value.push(val);
    });
    string path = <@untainted> prepareQueryUrl([CALENDAR_PATH, CALENDAR, calendarId, EVENTS], optionals.keys(), value);
    var httpResponse = calendarClient->get(path);
    json resp = check checkAndSetErrors(httpResponse);
    EventResponse|error res = resp.cloneWithType(EventResponse);
    if (res is EventResponse) {
        int i = events.length();
        foreach Event item in res.items {
            events[i] = item;
            i = i + 1;
        }
        stream<Event> eventStream = (<@untainted>events).toStream();
        string? nextPageToken = res?.nextPageToken;
        if (nextPageToken is string) {
            var streams = check getEventsStream(calendarClient, calendarId, response, events, count,
            syncToken, nextPageToken);          
        } 
        else {
            string? nextSyncToken = res?.nextSyncToken;
            if (nextSyncToken is string) {    
                response.nextSyncToken = nextSyncToken;       
            }        
        }
        response.kind = res.kind;
        response.etag = res.etag;
        response.summary = res.summary;
        response.updated = res.updated;
        response.timeZone = res.timeZone;
        response.accessRole = res.accessRole;
        response.defaultReminders = res.defaultReminders;  
        response.items = eventStream;          
        return response;      
    } else {
        return error(ERR_EVENT_RESPONSE, res);
    }
}

# Get calendars stream.
# 
# + calendarClient - Calendar client
# + calendars - Calendar array
# + optional - Record that contains optional parameters
# + return - Calendar stream on success, else an error
function getCalendarsStream(http:Client calendarClient, @tainted Calendar[] calendars, CalendarListOptional? 
optional = ()) returns @tainted stream<Calendar>|error {
    string path = <@untainted> prepareUrlWithCalendarOptional(optional);
    var httpResponse = calendarClient->get(path);
    json resp = check checkAndSetErrors(httpResponse);
    CalendarResponse|error res = resp.cloneWithType(CalendarResponse);
    if (res is CalendarResponse) {
        int i = calendars.length();
        foreach Calendar item in res.items {
            calendars[i] = item;
            i = i + 1;
        }
        stream<Calendar> calendarStream = (<@untainted>calendars).toStream();
        string? pageToken = res?.nextPageToken;
        if (pageToken is string && optional is CalendarListOptional) {
            optional.pageToken = pageToken;       
            var streams = check getCalendarsStream(calendarClient, calendars, optional);
        }
        return calendarStream;
    } else {
        return error(ERR_CALENDAR_RESPONSE, res);
    }
}
