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

service class HttpService {

    private boolean isOnNewEventAvailable = false;
    private boolean isOnEventUpdateAvailable = false;
    private boolean isOnEventDeleteAvailable = false;
    private SimpleHttpService httpService;
    private calendar:Client calendarClient;
    private string calendarId;
    public string channelId;
    public string resourceId;
    private string? currentSyncToken = ();

    public isolated function init(SimpleHttpService|HttpService httpService, calendar:Client calendarClient, 
                                  string calendarId, string channelId, string resourceId) {
        self.httpService = httpService;
        self.calendarClient = calendarClient;
        self.calendarId = calendarId;
        self.channelId = channelId;
        self.resourceId = resourceId;

        string[] methodNames = getServiceMethodNames(httpService);

        foreach var methodName in methodNames {
            match methodName {
                "onNewEvent" => {
                    self.isOnNewEventAvailable = true;
                }
                "onEventUpdate" => {
                    self.isOnEventUpdateAvailable = true;
                }
                "onEventDelete" => {
                    self.isOnEventDeleteAvailable = true;
                }
                _ => {
                    log:printError("Unrecognized method [" + methodName + "] found in the implementation");
                }
            }
        }
    }

    isolated resource function post events(http:Caller caller, http:Request request) returns @tainted error? {
        if (check self.isValidRequest(request)) {
            http:Response res = new;
            res.statusCode = http:STATUS_OK;
            if (check self.isValidSyncRequest(request)) {
                self.currentSyncToken = check self.getInitialSyncToken(self.calendarClient, self.calendarId);
                check caller->respond(res);
            } else {
                [string, calendar:Event] [syncToken, event] = check self.processEvent();
                check self.dispatchEvent(event);
                self.currentSyncToken = syncToken;
                check caller->respond(res);
            }
        } else {
            return error(INVALID_ID_ERROR);
        }
    }

    isolated function isValidRequest(http:Request request) returns boolean|error {
        return ((check request.getHeader(GOOGLE_CHANNEL_ID)) == self.channelId && (check request.getHeader(
        GOOGLE_RESOURCE_ID)) == self.resourceId);
    }

    isolated function getInitialSyncToken(calendar:Client httpClient, string calendarId, string? pageToken = ()) 
    returns @tainted string?|error {
        calendar:EventResponse resp = check httpClient->getEventsResponse(calendarId, pageToken = pageToken);
        string? nextPageToken = resp?.nextPageToken;
        string? syncToken = ();
        if (nextPageToken is string) {
            syncToken = check self.getInitialSyncToken(httpClient, calendarId, nextPageToken);
        }
        if (syncToken is string) {
            return syncToken;
        }
        return resp?.nextSyncToken;
    }

    isolated function isValidSyncRequest(http:Request request) returns boolean|error {
        return ((check request.getHeader(GOOGLE_RESOURCE_STATE)) == SYNC);
    }

    isolated function processEvent() returns [string, calendar:Event]|error {
        calendar:EventResponse resp = check self.calendarClient->getEventsResponse(self.calendarId, syncToken = self.
        currentSyncToken);
        string syncToken = resp?.nextSyncToken ?: "";
        calendar:Event event = resp?.items[0];
        return [syncToken, event];
    }

    isolated function dispatchEvent(calendar:Event event) returns error? {
        if (self.isCreateOrUpdateEvent(event)) {
            if (self.isNewEvent(event)) {
                if (self.isOnNewEventAvailable) {
                    check callOnNewEventMethod(self.httpService, event);
                }
            } else if (self.isOnEventUpdateAvailable) {
                check callOnEventUpdateMethod(self.httpService, event);
            }
        } else if (self.isOnEventDeleteAvailable) {
            check callOnEventDeleteMethod(self.httpService, event);
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
}
