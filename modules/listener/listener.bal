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
import ballerinax/googleapis_calendar as calendar;

# Listener for Google Calendar connector   
public class Listener {

    private http:Listener httpListener;
    private calendar:Client calendarClient;
    private string calendarId;
    private string address;
    private string? expiration;
    private string resourceId = "";
    private string channelId = "";
    private string? syncToken = ();

    public isolated function init(int port, calendar:Client calendarClient, string calendarId, string address, 
                                    string? expiration = ()) returns error? {
        self.httpListener = check new (port);
        self.calendarClient = calendarClient;
        self.address = address;
        self.calendarId = calendarId;
        self.expiration = expiration;
    }

    public function attach(service object {} s, string[]|string? name = ()) returns @tainted error? {
        calendar:WatchResponse res = check self.calendarClient->watchEvents(self.calendarId, self.address, 
            self.expiration);
        self.resourceId = res.resourceId;
        self.channelId = res.id;
        log:print("Subscribed to channel id : " + self.channelId + " resourcs id :  " + self.resourceId);
        return self.httpListener.attach(s, name);
    }

    public isolated function detach(service object {} s) returns error? {
        return self.httpListener.detach(s);
    }

    public isolated function 'start() returns error? {
        return self.httpListener.'start();
    }

    public function gracefulStop() returns @tainted error? {
        check self.calendarClient->stopChannel(self.channelId, self.resourceId);
        log:print("Subscription stopped");
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
    public function getEventType(http:Caller caller, http:Request request) returns @tainted EventInfo|error {
        EventInfo info  = {};
        if (request.getHeader(GOOGLE_CHANNEL_ID) == self.channelId && request.getHeader(GOOGLE_RESOURCE_ID) == 
            self.resourceId) {
            http:Response response = new;
            response.statusCode = http:STATUS_OK;
            if (request.getHeader(GOOGLE_RESOURCE_STATE) == SYNC) {
                calendar:EventStreamResponse resp = check self.calendarClient->getEventResponse(self.calendarId);
                self.syncToken = resp?.nextSyncToken;
                check caller->respond(response);
                return info;
            } else {
                calendar:EventStreamResponse resp = check self.calendarClient->getEventResponse(self.calendarId, 1,
                    self.syncToken);
                self.syncToken = resp?.nextSyncToken;
                stream<calendar:Event>? events = resp?.items;
                check caller->respond(response);
                if (events is stream<calendar:Event>) {
                    record {|calendar:Event value;|}? event = events.next();
                    if (event is record {|calendar:Event value;|}) {
                        info.event = event?.value;
                        string? created = event?.value?.created;
                        string? updated = event?.value?.updated;
                        calendar:Time? 'start = event?.value?.'start;
                        calendar:Time? end = event?.value?.end;
                        info.eventType = (created is string && updated is string && 'start is calendar:Time && 
                            end is calendar:Time) ? ((created.substring(0, 19) == updated.substring(0, 19)) ?
                            CREATED : UPDATED) : DELETED;
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
