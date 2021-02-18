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

import ballerina/websub;
import ballerina/config;
import ballerinax/googleapis_calendar as calendar;

calendar:CalendarConfiguration calendarConfig = {
    oauth2Config: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            refreshUrl: config:getAsString("REFRESH_URL"),
            refreshToken: config:getAsString("REFRESH_TOKEN"),
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET")
        }
    }
};
private string? syncToken = ();

calendar:CalendarClient calendarClient = new (calendarConfig);

# Object representing the Google Webhook (WebSub Subscriber Service) Listener.
#
public class Listener {

    private websub:Listener websubListener;

    public isolated function init(int port) {
        websub:SubscriberListenerConfiguration slConfig = {};
        self.websubListener = new (port, slConfig);
    }

    public isolated function attach(service object {} s, string[]|string? name = ()) returns error? {
        return self.websubListener.attach(s, name);
    }

    public isolated function detach(service object {} s) returns error? {
        return self.websubListener.detach(s);
    }

    public function 'start() returns error? {
        return self.websubListener.'start();
    }

    public isolated function gracefulStop() returns error? {
        return self.websubListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.websubListener.immediateStop();
    }

    # Returns TwilioEvent corresponding to the incoming Notification
    # + notification - websub Notification object containing the event payload and information
    # + return - If success, returns TwilioEvent object, else returns error
    public function getEventType(websub:Notification notification) returns @tainted error|EventInfo {
        EventInfo info  = {};
        if (notification.getHeader(GOOGLE_CHANNEL_ID) == config:getAsString("CHANNEL_ID") && notification.getHeader(
        GOOGLE_RESOURCE_ID) == config:getAsString("RESOURCE-ID")) {
            if (notification.getHeader(GOOGLE_RESOURCE_STATE) == SYNC) {
                calendar:EventStreamResponse|error resp = calendarClient->getEventResponse(config:getAsString("CALENDAR_ID"));
                if (resp is calendar:EventStreamResponse) {
                    syncToken = <@untainted>resp?.nextSyncToken;
                } 
                return info;
            } else {
                calendar:EventStreamResponse resp = check calendarClient->getEventResponse(config:getAsString("CALENDAR_ID"), 
                1, syncToken);
                syncToken = <@untainted>resp?.nextSyncToken;
                stream<calendar:Event>? events = resp?.items;
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
        return error (INVALID_ID_ERROR);
    }
}
