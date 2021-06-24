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
import ballerina/task;
import ballerina/time;

# Listener for Google Calendar connector
#
# + expirationTime - Expiration time in unix timestamp
@display {label: "Google Calendar Listener"}
public class Listener {
    private http:Listener httpListener;
    private ListenerConfiguration configuration;
    private string resourceId = "";
    private string channelId = "";
    public decimal expirationTime = 0;
    private HttpService httpService;

    public isolated function init(ListenerConfiguration configuration) returns error? {
        self.httpListener = check new (configuration.port);
        self.configuration = configuration;
    }

    public isolated function attach(SimpleHttpService s, string[]|string? name = ()) returns @tainted error? {
        self.httpService = check new HttpService(s, self.configuration, self.channelId, self.resourceId);
        check self.httpListener.attach(self.httpService, name);

        Job job = new (self, self.configuration?.channelRenewalConfig);
        time:Utc currentUtc = time:utcNow();
        time:Civil time = time:utcToCivil(currentUtc);
        task:JobId result = check task:scheduleOneTimeJob(job, time);
    }

    public isolated function detach(service object {} s) returns error? {
        return self.httpListener.detach(s);
    }

    public isolated function 'start() returns error? {
        return self.httpListener.'start();
    }

    public isolated function gracefulStop() returns @tainted error? {
        check stopChannel(self.configuration.clientConfiguration, self.channelId, self.resourceId);
        log:printInfo("Subscription stopped");
        return self.httpListener.gracefulStop();
    }

    public isolated function immediateStop() returns error? {
        return self.httpListener.immediateStop();
    }

    public isolated function registerWatchChannel() returns @tainted error? {
        WatchResponse res = check watchEvents(self.configuration);
        self.channelId = res.id;
        self.resourceId = res.resourceId;
        self.httpService.channelId = self.channelId;
        self.httpService.resourceId = self.resourceId;
        log:printInfo("Subscribed to channel id : " + self.channelId + " resourcs id :  " + self.resourceId);
        self.expirationTime = check decimal:fromString(res.expiration);
    }
}
