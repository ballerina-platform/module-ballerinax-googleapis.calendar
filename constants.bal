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

// Path Constants
const string BASE_URL = "https://www.googleapis.com";
const string CALENDAR_PATH = "/calendar/v3";
const string CALENDAR = "calendars";
const string CHANNELS = "channels";
const string STOP = "stop";
const string EVENTS = "events";
const string WATCH = "watch";
const string QUICK_ADD = "quickAdd";

// Symbols
const string QUESTION_MARK = "?";
const string EQUAL_SIGN = "=";
const string EMPTY_STRING = "";
const string AMPERSAND = "&";
const string FORWARD_SLASH = "/";

// URL encoding
const string ENCODING_CHARSET = "utf-8";

// Query parameters
const string TEXT = "text";
const string SEND_UPDATES = "sendUpdates";
const string SYNC_TOKEN = "syncToken";
const string PAGE_TOKEN ="pageToken";
const string MAX_RESULT = "maxResults";
const string CONFERENCE_DATA_VERSION = "conferenceDataVersion";
const string MAX_ATTENDEES = "maxAttendees";
const string SUPPORTS_ATTACHMENTS = "supportsAttachments";

// Error constants
const string HTTP_ERROR_MSG = "Error occurred while getting the HTTP response : ";
const string ERR_EXTRACTING_ERROR_MSG = "Error occured while extracting errors from payload.";
const string JSON_ACCESSING_ERROR_MSG = "Error occurred while accessing the JSON payload of the response.";
const string ERR_EVENT_RESPONSE = "Error occurred while constructing EventResponse record.";
const string ERR_EVENT = "Error occurred while constructing Event record.";
const string ERR_WATCH_RESPONSE = "Error occurred while constructing WatchResponse record.";

// Log constants
const string PAYLOAD = " payload: ";

// String constants
const string TIME_FORMAT =  "yyyy-MM-dd'T'HH:mm:ssZ";