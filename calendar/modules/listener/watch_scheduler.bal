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
import ballerina/lang.runtime;
import ballerina/log;
import ballerina/task;
import ballerina/time;

class Job {
    *task:Job;
    private Listener 'listener;
    private int retryCount = 1;
    private int retryScheduleCount = 1;
    private int retryMaxCount;
    private int retryInterval;
    private int domainVerificationDelay;
    private int leadTime;

    isolated function init(Listener 'listener, ChannelRenewalConfiguration? config = ()) {
        self.'listener = 'listener;
        self.retryMaxCount = config?.retryCount ?: 20;
        self.retryInterval = config?.retryInterval ?: 30;
        self.domainVerificationDelay = config?.domainVerificationDelay ?: 300;
        self.leadTime = config?.leadTime ?: 180;
    }

    public isolated function execute() {
        error? err = self.'listener.registerWatchChannel();
        if (err is error) {
            self.registerWatchChannelWithRetry();
        } else {
            self.scheduleNextChannel();
        }
    }

    isolated function scheduleNextChannel() {
        error? err = self.scheduleNextChannelRenewal();
        if (err is error) {
            log:printWarn(WARN_CHANNEL_REGISTRATION, 'error = err);
            if (self.retryScheduleCount <= 10) {
                log:printInfo(INFO_RETRY_SCHEDULE + self.retryScheduleCount.toString());
                runtime:sleep(5);
                self.retryScheduleCount += 1;
                self.scheduleNextChannel();
            } else {
                panic error(ERR_SCHEDULE, 'error = err);
            }
        }
    }

    isolated function scheduleNextChannelRenewal() returns error? {
        time:Utc currentUtc = time:utcNow();
        decimal timeDifference = (self.'listener.expirationTime / 1000) - (<decimal>currentUtc[0]) - <decimal>self.
        leadTime;
        time:Utc scheduledUtcTime = time:utcAddSeconds(currentUtc, timeDifference);
        time:Civil scheduledTime = time:utcToCivil(scheduledUtcTime);
        task:JobId result = check task:scheduleOneTimeJob(self, scheduledTime);
    }

    isolated function registerWatchChannelWithRetry() {
        error? err = self.'listener.registerWatchChannel();
        if (err is error) {
            string message = err.message();
            if (message.startsWith("Unauthorized WebHook callback channel")) {
                self.registerInitialChannel(err);
            } else if (message.startsWith("Not Found")) {
                panic error(ERR_CHANNEL_REGISTRATION, 'error = err);
            } else {
                self.registerChannel(err);
            }
        } else {
            self.retryCount = 1;
        }
    }

    isolated function registerInitialChannel(error err) {
        if (self.retryCount == 1) {
            log:printInfo(CHANNEL_REGISTRATION_ON_PROGRESS + " Waiting for " + self.domainVerificationDelay.toString() +
            "seconds to check result.");
            log:printInfo(REQUEST_DOMAIN_VERIFICATION);
            runtime:sleep(<decimal>self.domainVerificationDelay);
            self.retryCount += 1;
            self.execute();
        } else if (self.retryCount <= self.retryMaxCount) {
            log:printInfo(INFO_RETRY_CHANNEL_REGISTRATION + self.retryCount.toString());
            runtime:sleep(<decimal>self.retryInterval);
            self.retryCount += 1;
            self.execute();
        } else {
            panic error(ERR_CHANNEL_REGISTRATION, 'error = err);
        }
    }

    isolated function registerChannel(error err) {
        log:printWarn(WARN_CHANNEL_REGISTRATION, 'error = err);
        if (self.retryCount <= 5) {
            log:printInfo(INFO_RETRY_CHANNEL_REGISTRATION + self.retryCount.toString());
            runtime:sleep(10);
            self.retryCount += 1;
            self.execute();
        } else {
            panic error(ERR_CHANNEL_REGISTRATION, 'error = err);
        }
    }
}
