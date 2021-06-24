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
import ballerinax/googleapis.calendar;

# Listener Configuration. 
#
# + port - Port for the listener.  
# + calendarId - Calendar ID
# + clientConfiguration - Calendar client connecter configuration
# + callbackUrl - Callback URL registered
# + domainVerificationFileContent - File content of HTML file used in domain verification
# + channelRenewalConfig - Channel renewal configuration
# + expiration - Channel Renewal Interval
@display {label: "Listener Config"}
public type ListenerConfiguration record {
    @display {label: "Port"}
    int port;
    calendar:CalendarConfiguration clientConfiguration;
    @display {label: "Calendar ID"}
    string calendarId;
    @display {label: "Callback URL"}
    string callbackUrl;
    @display {label: "Domain Verification File Content"}
    string domainVerificationFileContent;
    ChannelRenewalConfiguration channelRenewalConfig?;
    @display {label: "Channel Renewal Interval"}
    string expiration?;
};

# Channel Renewal Configuration
#
# + retryCount - Maximum number of retries allowed to renew listener channel. (default : 20)
# + retryInterval - Time between retries to renew listener channel in seconds. (default: 30)  
# + domainVerificationDelay - Initial wait time for domain verification check in seconds. (default: 300s)  
# + leadTime - Time prior to expiration that renewal should happen happen. (default: 180s) 
@display {label: "Channel Renewal Config"}
public type ChannelRenewalConfiguration record {
    @display {label: "Retry Count"}
    int retryCount?;
    @display {label: "Retry Interval"}
    int retryInterval?;
    @display {label: "Domain Verification Delay"}
    int domainVerificationDelay?;
    @display{label: "Lead Time"}
    int leadTime?;
};

# Define watch response.
#
# + kind - Identifies this as a notification channel used to watch for changes to a resource
# + id - A UUID or similar unique string that identifies this channel
# + resourceId - An opaque ID that identifies the resource being watched on this channel
# + resourceUri - A version-specific identifier for the watched resource
# + token - An arbitrary string delivered to the target address
# + expiration - Date and time of notification channel expiration
public type WatchResponse record {
    string kind;
    string id;
    string resourceId;
    string resourceUri;
    string token?;
    string expiration;
};
