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
    private HttpService httpService;
    private calendar:CalendarConfiguration config;

    # Initializes Google Calendar connector listener.
    #
    # + port - Port number
    # + calendarConfig -  Configurations required to initialize the `Client` endpoint
    # + calendarId - Calendar ID
    # + address - Callback URL
    # + expiration - Life time of a channel. After this time, connector will create a new channel automatically
    # + return - An error on failure of initialization or else `()`
    public isolated function init(int port, calendar:CalendarConfiguration config, string calendarId, string address,
                                    string? expiration = ()) returns error? {
        self.httpListener = check new (port);
        self.calendarClient = check new (config);
        self.config = config;
        self.calendarId = calendarId;
        self.address = address;
        self.expiration = expiration;
    }

    public isolated function attach(SimpleHttpService s, string[]|string? name = ()) returns @tainted error? {
        self.httpService = new HttpService(s, self.calendarClient, self.calendarId, self.channelId, self.resourceId);
        check self.registerWatchChannel();
        check self.httpListener.attach(self.httpService, name);
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
        self.httpService.channelId = self.channelId;
        self.httpService.resourceId = self.resourceId;
        log:printDebug("Subscribed to channel id : " + self.channelId + " resourcs id :  " + self.resourceId);
        self.expirationTime = check decimal:fromString(res.expiration);
    }
}
