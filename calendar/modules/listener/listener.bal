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

# Listener for Google Calendar connector
# 
# + expirationTime - Expiration time in unix timestamp
@display {label: "Google Calendar Listener"}
public class Listener {
    private http:Listener httpListener;
    private calendar:Client calendarClient;
    private string calendarId;
    private string address;
    private string? expiration;
    private string resourceId = "";
    private string channelId = "";
    private string? syncToken = ();
    public decimal expirationTime = 0;
    private HttpService? httpService;
    private calendar:CalendarConfiguration config;

    public isolated function init(int port, calendar:CalendarConfiguration config, string calendarId, string address,
                                    string? expiration = ()) returns error? {
        self.httpListener = check new (port);
        self.calendarClient = check new (config);
        self.config = config;
        self.calendarId = calendarId;
        self.address = address;
        self.expiration = expiration;
        self.httpService = ();
    }

    public isolated function attach(SimpleHttpService s, string[]|string? name = ()) returns @tainted error? {
        HttpToCalendarAdaptor adaptor = check new (s);
        self.httpService = new HttpService(adaptor, self.config, self.calendarId, self.channelId, self.resourceId);
        check self.registerWatchChannel();
        check self.httpListener.attach(<HttpService>self.httpService, name);
        Job job = new (self);
        check job.scheduleNextChannelRenewal();
    }

    public isolated function detach(service object {} s) returns error? {
        return self.httpListener.detach(s);
    }

    public isolated function 'start() returns error? {
        return self.httpListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        check stopChannel(self.config, self.channelId, self.resourceId);
        log:printInfo("Subscription stopped");
        return self.httpListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.httpListener.immediateStop();
    }

    public isolated function registerWatchChannel() returns @tainted error? {
        WatchResponse res = check watchEvents(self.config, self.calendarId, self.address, self.expiration);
        self.channelId = res.id;
        self.resourceId = res.resourceId;
        HttpService? httpService = self.httpService;
        if httpService is HttpService {
            httpService.setChannelId(self.channelId);
            httpService.setResourceId(self.resourceId);
        }
        log:printDebug("Subscribed to channel id : " + self.channelId + " resource id :  " + self.resourceId);
        self.expirationTime = check decimal:fromString(res.expiration);
    }
}
