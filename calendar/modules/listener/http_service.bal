// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/log;
import ballerinax/googleapis.calendar;

isolated service class HttpService {
    private final boolean isOnNewEventAvailable;
    private final boolean isOnEventUpdateAvailable;
    private final boolean isOnEventDeleteAvailable;
    private final HttpToCalendarAdaptor adaptor;
    private final calendar:ConnectionConfig & readonly calendarConfig;
    private string calendarId;
    private string channelId;
    private string resourceId;
    private string? currentSyncToken = ();

    isolated function init(HttpToCalendarAdaptor adaptor, calendar:ConnectionConfig config, string calendarId, 
                            string channelId, string resourceId) {
        self.adaptor = adaptor;
        self.calendarConfig = config.cloneReadOnly();
        self.calendarId = calendarId;
        self.channelId = channelId;
        self.resourceId = resourceId;

        string[] methodNames = adaptor.getServiceMethodNames();
        self.isOnNewEventAvailable = isMethodAvailable(ON_NEW_EVENT, methodNames);
        self.isOnEventUpdateAvailable = isMethodAvailable(ON_EVENT_UPDATE, methodNames);
        self.isOnEventDeleteAvailable = isMethodAvailable(ON_EVENT_DELETE, methodNames);

        if (methodNames.length() > 0) {
            foreach string methodName in methodNames {
                log:printError("Unrecognized method [" + methodName + "] found in user implementation."); 
            }
        }
    }

    public isolated function setChannelId(string channelId) {
        lock {
            self.channelId = channelId;
        }
    }

    public isolated function setResourceId(string resourceId) {
        lock {
            self.resourceId = resourceId;
        }
    }

    isolated resource function post events(http:Caller caller, http:Request request) returns @tainted error? {
        if (check self.isValidRequest(request)) {
            http:Response res = new;
            res.statusCode = http:STATUS_OK;
            if (check self.isValidSyncRequest(request)) {
                lock {
                    self.currentSyncToken = check self.getInitialSyncToken(self.calendarConfig, self.calendarId);
                }
                check caller->respond(res);
            } else {
                string syncToken = check self.processEvent();
                lock {
                    self.currentSyncToken = syncToken;
                }
                check caller->respond(res);
            }
        } else {
            return error(INVALID_ID_ERROR);
        }
    }

    isolated function isValidRequest(http:Request request) returns boolean|error {
        lock {
            return ((check request.getHeader(GOOGLE_CHANNEL_ID)) == self.channelId && (check request.getHeader(
                GOOGLE_RESOURCE_ID)) == self.resourceId);
        }
    }

    isolated function getInitialSyncToken(calendar:ConnectionConfig config, string calendarId, 
                                            string? pageToken = ()) returns @tainted string?|error {
        calendar:EventResponse resp = check self.getEventsResponse(pageToken = pageToken);
        string? nextPageToken = resp?.nextPageToken;
        string? syncToken = ();
        if (nextPageToken is string) {
            syncToken = check self.getInitialSyncToken(config, calendarId, nextPageToken);
        }
        if (syncToken is string) {
            return syncToken;
        }
        return resp?.nextSyncToken;
    }

    isolated function isValidSyncRequest(http:Request request) returns boolean|error {
        return ((check request.getHeader(GOOGLE_RESOURCE_STATE)) == SYNC);
    }

    isolated function processEvent() returns string|error {
        calendar:EventResponse resp = check self.getEventsResponse();
        string syncToken = resp?.nextSyncToken ?: EMPTY_STRING;
        calendar:Event event = resp?.items[0];
        check self.dispatchEvent(event);
        return syncToken;
    }

    isolated function dispatchEvent(calendar:Event event) returns error? {
        if (self.isCreateOrUpdateEvent(event)) {
            if (self.isNewEvent(event)) {
                if (self.isOnNewEventAvailable) {
                    check self.adaptor.callOnNewEventMethod(event);
                }
            } else if (self.isOnEventUpdateAvailable) {
                check self.adaptor.callOnEventUpdateMethod(event);
            }
        } else if (self.isOnEventDeleteAvailable) {
            check self.adaptor.callOnEventDeleteMethod(event);
        }
    }

    isolated function isCreateOrUpdateEvent(calendar:Event event) returns boolean {
        string? createdTime = event?.created;
        string? updatedTime = event?.updated;
        calendar:Time? 'start = event?.'start;
        calendar:Time? end = event?.end;
        return (createdTime is string && updatedTime is string && 'start is calendar:Time && end is calendar:Time);
    }

    isolated function isNewEvent(calendar:Event event) returns boolean {
        string createdTime = event?.created.toString();
        string updatedTime = event?.updated.toString();
        return (createdTime.substring(0, 19) == updatedTime.substring(0, 19));
    }

    isolated function getEventsResponse(int? count = (), string? pageToken = ()) returns @tainted 
            calendar:EventResponse|error {
        string path = EMPTY_STRING;
        lock {
            path = calendar:prepareUrlWithEventsOptionalParams(self.calendarId, count, pageToken, self.currentSyncToken);
        }

        http:Client httpClient = check getClient(self.calendarConfig);
        http:Response httpResponse = check httpClient->get(path);
        json resp = check checkAndSetErrors(httpResponse);
        return toEventResponse(resp);
    }
}

# Retrieves whether the particular remote method is available.
#
# + methodName - Name of the required method
# + methods - All available methods
# + return - `true` if method available or else `false`
isolated function isMethodAvailable(string methodName, string[] methods) returns boolean {
    boolean isAvailable = methods.indexOf(methodName) is int;
    if (isAvailable) {
        var index = methods.indexOf(methodName);
        if (index is int) {
            _ = methods.remove(index);
        }
    }
    return isAvailable;
}
