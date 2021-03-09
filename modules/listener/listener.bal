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
import ballerinax/googleapis_calendar as calendar;

string? syncToken = ();

@display {
    label: "Google Calendar Listener"
}
public class Listener {
    private http:Listener httpListener;
    private string calendarId;
    private string resourceId;
    private string channelId;
    private calendar:Client calendarClient;

    public isolated function init(int port, calendar:Client calendarClient, string channelId, string resourceId,
                                    string calendarId ) {
        self.httpListener = checkpanic new (port);
        self.calendarClient = calendarClient;
        self.channelId = channelId;
        self.resourceId = resourceId;
        self.calendarId = calendarId;
    }

    public isolated function attach(service object {} s, string[]|string? name = ()) returns error? {
        return self.httpListener.attach(s, name);
    }

    public isolated function detach(service object {} s) returns error? {
        return self.httpListener.detach(s);
    }

    public isolated function 'start() returns error? {
        return self.httpListener.'start();
    }

    public isolated function gracefulStop() returns error? {
        return self.httpListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.httpListener.immediateStop();
    }

    # Returns calendar event according to the incoming request.
    # 
    # + caller - http:Caller for acknowleding to the request received
    # + request - http:Request that contains event related data
    # + return - If success, returns EventInfo record, else error
    public function getEventType(http:Caller caller, http:Request request) returns @tainted error|EventInfo {
        EventInfo info  = {};
        if (request.getHeader(GOOGLE_CHANNEL_ID) == self.channelId && request.getHeader(GOOGLE_RESOURCE_ID) == 
            self.resourceId) {
            http:Response response = new;
            response.statusCode = http:STATUS_OK;
            if (request.getHeader(GOOGLE_RESOURCE_STATE) == SYNC) {
                calendar:EventStreamResponse|error resp = self.calendarClient->getEventResponse(self.calendarId);
                if (resp is calendar:EventStreamResponse) {
                    syncToken = <@untainted>resp?.nextSyncToken;
                }
                check caller->respond(response);
                return info;
            } else {
                calendar:EventStreamResponse resp = check self.calendarClient->getEventResponse(self.calendarId, 1,
                    syncToken);
                syncToken = <@untainted>resp?.nextSyncToken;
                stream<calendar:Event>? events = resp?.items;
                check caller->respond(response);
                if (events is stream<calendar:Event>) {
                    record {|calendar:Event value;|}? env = events.next();
                    if (env is record {|calendar:Event value;|}) {
                        info.event = env?.value;
                        string? created = env?.value?.created;
                        string? updated = env?.value?.updated;
                        calendar:Time? 'start = env?.value?.'start;
                        calendar:Time? end = env?.value?.end;
                        if (created is string && updated is string && 'start is calendar:Time && end is calendar:Time) {
                            if (created.substring(0, 19) == updated.substring(0, 19)) {
                                info.eventType = CREATED;
                                return info;
                            } else  {
                                info.eventType = UPDATED;
                                return info;
                            }
                        }
                        info.eventType = DELETED;
                        return info;
                    }
                    return error(EVENT_MAPPING_ERROR);
                }
                return error(EVENT_STREAM_MAPPING_ERROR);
            }
        }
        return error(INVALID_ID_ERROR);
    }
}
