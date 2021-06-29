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

// Header constants
const string GOOGLE_CHANNEL_ID = "X-Goog-Channel-ID";
const string GOOGLE_RESOURCE_ID = "X-Goog-Resource-ID";
const string GOOGLE_RESOURCE_STATE = "X-Goog-Resource-State";
const string SYNC = "sync";
const string CONTENT_TYPE = "Content-Type";
const string TEXT_HTML = "text/html; charset=UTF-8";
const string GOOGLE_SITE_VERIFICATION_PREFIX = "google-site-verification";

// Path Constants
const string BASE_URL = "https://www.googleapis.com";
const string REFRESH_URL = "https://www.googleapis.com/oauth2/v3/token";
const string CALENDAR_PATH = "/calendar/v3";
const string CALENDAR = "calendars";
const string CHANNELS = "channels";
const string STOP = "stop";
const string EVENTS = "events";
const string WATCH = "watch";
const string WEBHOOK = "webhook";

// Symbols
const string QUESTION_MARK = "?";
const string EQUAL_SIGN = "=";
const string EMPTY_STRING = "";
const string AMPERSAND = "&";
const string FORWARD_SLASH = "/";
const string PAYLOAD = " payload: ";

// Error constants
const string HTTP_ERROR_MSG = "Error occurred while getting the HTTP response : ";
const string ERR_EXTRACTING_ERROR_MSG = "Error occured while extracting errors from payload.";
const string JSON_ACCESSING_ERROR_MSG = "Error occurred while accessing the JSON payload of the response.";
const string ERR_WATCH_RESPONSE = "Error occurred while constructing WatchResponse record.";
const string ERR_CHANNEL_REGISTRATION = "Unable to register new channel.";
const string ERR_SCHEDULE = "Unable to schedule subscription renewal.";
const string INVALID_ID_ERROR = "Invalid channel id/ resource id";
const string INVALID_DOMAIN_INPUT = "Invalid input for domain verification";
const string UNAUTHORIZED_WEBHOOK_CALLBACK = "Unauthorized WebHook callback channel";
const string NOT_FOUND = "Not Found";

// Warn constants
const string WARN_CHANNEL_REGISTRATION = "Could not register watch channel";
const string WARN_SCHEDULE = "Could not schedule subscription renewal";

// Info constants
const string INFO_RETRY_CHANNEL_REGISTRATION = "Retrying to register new channel. Attempt - ";
const string INFO_RETRY_SCHEDULE = "Retrying to schedule subscription renewal. Attempt - ";
const string CHANNEL_REGISTRATION_ON_PROGRESS = "Google domain verification on progress...";
const string REQUEST_DOMAIN_VERIFICATION = "Please register the callback URL " +
"by visiting https://console.cloud.google.com/apis/credentials/domainverification";
const string DOMAIN_VERIFICATION_ON_PROGRESS = "Domain verification on process";
