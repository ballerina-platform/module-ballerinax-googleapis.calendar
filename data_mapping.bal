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

import ballerina/log;

# Convert json to Event.
# 
# + payload - Json response
# + return - An Event record on success else an error
isolated function toEvent(json payload) returns Event|error {
    Event|error res = payload.cloneWithType(Event);
    if (res is Event) {
        return res;
    } else {
        log:printError(ERR_EVENT + PAYLOAD + payload.toJsonString(), 'error = res);
        return error(ERR_EVENT, res);
    }
}

# Convert json to Calendar.
# 
# + payload - Json response
# + return - A CalendarResource record on success else an error
isolated function toCalendar(json payload) returns CalendarResource|error {
    CalendarResource|error res = payload.cloneWithType(CalendarResource);
    if (res is CalendarResource) {
        return res;
    } else {
        log:printError(ERR_CALENDAR_RESOURCE + PAYLOAD + payload.toJsonString(), 'error = res);
        return error(ERR_CALENDAR_RESOURCE, res);
    }
}

# Convert json to WatchResponse.
# 
# + payload - Json response
# + return - A WatchResponse object on success else an error
isolated function toWatchResponse(json payload) returns WatchResponse|error {
    WatchResponse|error res = payload.cloneWithType(WatchResponse);
    if (res is WatchResponse) {
        return res;
    } else {
        log:printError(ERR_WATCH_RESPONSE + PAYLOAD + payload.toJsonString(), 'error = res);
        return error(ERR_WATCH_RESPONSE, res);
    }
}

# Convert json to EventResponse.
# 
# + payload - Json response
# + return - EventResponse object on success else an error 
isolated function toEventsUpdated(json payload) returns EventResponse|error {
    EventResponse|error res = payload.cloneWithType(EventResponse);
    if (res is EventResponse) {
        return res;
    } else {
        log:printError(ERR_EVENT_RESPONSE + PAYLOAD + payload.toJsonString(), 'error = res);
        return error(ERR_EVENT_RESPONSE, res);
    }
}
