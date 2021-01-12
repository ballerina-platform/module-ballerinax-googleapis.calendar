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

public type InputEvent record {|
    string summary?;
    string description?;
    string location?;
    string colorId?;
    string id?;
    Time 'start;
    Time end;
    string[] recurrence?;
    Time originalStartTime?;
    string transparency?;
    string visibility?;
    int sequence?;
    Attendee[] attendees?;
    ExtendedProperties extendedProperties?;
    boolean attendeesOmitted?;
    ConferenceData conferenceData?;
    Gadget gadget?;
    boolean anyoneCanAddSelf?;
    boolean guestsCanInviteOthers?;
    boolean guestsCanModify?;
    boolean guestsCanSeeOtherGuests?;
    Reminder reminders?;
    Source 'source?;
    Attachment[] attachments?;
|};

public type CreateEventOptional record {|
    int? conferenceDataVersion = ();
    int? maxAttendees = ();
    string? sendUpdates = ();
    boolean? supportsAttachments = ();
|};

public type EventResponse record {|
    string kind;
    string etag;
    string summary;
    string updated;
    string timeZone;
    string accessRole;
    DefaultReminder[] defaultReminders;
    string nextSyncToken?;
    string nextPageToken?;
    Event[] items;
|};

public type DefaultReminder record {|
    string method;
    int minutes;
|};

public type Event record {|
    string kind;
    string etag;
    string id;
    string status;
    string htmlLink?;
    string created?;
    string updated?;
    string summary?;
    string description?;
    string location?;
    string colorId?;
    User creator?;
    User organizer?;
    Time 'start?;
    Time end?;
    boolean endTimeUnspecified?;
    string[] recurrence?;
    string recurringEventId?;
    Time originalStartTime?;
    string transparency?;
    string visibility?;
    string iCalUID?;
    int sequence?;
    Attendee[] attendees?;
    ExtendedProperties extendedProperties?;
    boolean attendeesOmitted?;
    string hangoutLink?;
    ConferenceData conferenceData?;
    Gadget gadget?;
    boolean anyoneCanAddSelf?;
    boolean guestsCanInviteOthers?;
    boolean guestsCanModify?;
    boolean guestsCanSeeOtherGuests?;
    boolean privateCopy?;
    boolean locked?;
    Reminder reminders?;
    Source 'source?;
    Attachment[] attachments?;
|};

public type ExtendedProperties record {|
    Private 'private?;
    Shared shared?;
|};

public type Private record {|
    string everyoneDeclinedDismissed;
|};

public type Shared record {|
    string zmMeetingNum;
|};

public type ConferenceData record {|
    CreateRequest createRequest?;
    EntryPoint[] entryPoints;
    ConferenceSolution conferenceSolution;
    string conferenceId;
    string signature;
    string notes?;
|};

public type CreateRequest record {|
    string requestId;
    ConferenceSolutionKey conferenceSolutionKey;
    Status status;
|};

public type ConferenceSolutionKey record {|
    string 'type;
|};

public type Status record {|
    string statusCode;
|};

public type EntryPoint record {|
    string entryPointType;
    string uri;
    string label?;
    string pin?;
    string accessCode?;
    string meetingCode?;
    string passcode?;
    string password?;
    string regionCode?;
|};

public type ConferenceSolution record {|
    Key key;
    string name;
    string iconUri;
|};

public type Key record {|
    string 'type;
|};

public type Attendee record {|
    string id?;
    string email;
    string displayName?;
    boolean organizer?;
    boolean self?;
    boolean 'resource?;
    boolean optional?;
    string responseStatus;
    string comment?;
    string additionalGuests?;
|};

public type User record {|
    string id?;
    string email;
    string displayName?;
    boolean self?;
|};

public type Time record {|
    string date?;
    string dateTime;
    string timeZone?;
|};

public type Gadget record {|
    string preferences;
    string 'type?;
    string title?;
    string link?;
    string iconLink?;
    string width?;
    string height?;
    string display?;
|};

public type Reminder record {|
    boolean useDefault;
    Override[] overrides?;
|};

public type Override record {|
    string method;
    int minutes;
|};

public type Source record {|
    string url;
    string title;
|};

public type Attachment record {|
    string fileUrl;
    string title?;
    string mimeType?;
    string iconLink?;
    string fileId?;
|};

public type WatchConfiguration record {|
    string id;
    string token;
    string 'type;
    string address;
    Parameter params;
|};

public type Parameter record {|
    string ttl;
|};

public type WatchResponse record {|
    string kind;
    string id;
    string resourceId;
    string resourceUri;
    string token;
    string expiration;
|};

public type Calendar record {|
    string kind;
    string etag;
    string id;
    string summary;    
    string description?;
    string location?;
    string timeZone;
    string summaryOverride?;
    string colorId;
    boolean selected?;
    string backgroundColor;
    string foregroundColor;
    boolean hidden?;
    boolean deleted?;
    string accessRole;
    DefaultReminder[] defaultReminders;
    ConferenceProperties conferenceProperties;
    boolean primary?;
    NotificationSettings notificationSettings?;
|};

public type ConferenceProperties record {|
    string[] allowedConferenceSolutionTypes;
|};

public type NotificationSettings record {|
    Notification[] notifications;
    boolean primary?;
|};

public type Notification record {|
    string 'type;
    string method;
|};

public type CalendarListOptional record {|
    string? minAccessRole = ();
    string? pageToken = ();
    boolean? showDeleted = ();
    boolean? showHidden = ();
    string? syncToken = ();
|};

public type CalendarResponse record {|
    string kind;
    string etag;
    string nextSyncToken?;
    string nextPageToken?;
    Calendar[] items;
|};
