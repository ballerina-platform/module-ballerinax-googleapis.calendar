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

# Represents the elements representing event input.
#
# + summary - Title of the event
# + description - Description of the event
# + location - Location of the event
# + colorId - Color Id of the event
# + id - Opaque identifier of the event
# + start - Start time of the event
# + end - End time of the event
# + recurrence - List of RRULE, EXRULE, RDATE and EXDATE lines for a recurring event, as specified in RFC5545
# + originalStartTime - The start time of the event in recurring events
# + transparency - Whether the event blocks time on the calendar
# + visibility - Visibility of the event
# + sequence - Sequence number as per iCalendar
# + attendees - The attendees of the event
# + extendedProperties - Properties of the event that appears on this calendar
# + conferenceData - The conference-related information
# + gadget - Gadget of the event
# + anyoneCanAddSelf - Whether anyone can invite themselves to the event
# + guestsCanInviteOthers - Whether attendees other than the organizer can invite others to the event
# + guestsCanModify - Whether attendees other than the organizer can modify the event
# + guestsCanSeeOtherGuests - Whether attendees other than the organizer can see who the event's attendees are
# + reminders - Information about the event's reminders
# + source - Source from which the event was created
# + attachments - Attachments of the events
public type InputEvent record {
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
    ConferenceData conferenceData?;
    Gadget gadget?;
    boolean anyoneCanAddSelf?;
    boolean guestsCanInviteOthers?;
    boolean guestsCanModify?;
    boolean guestsCanSeeOtherGuests?;
    Reminders reminders?;
    Source 'source?;
    Attachment[] attachments?;
};

# Represent the optional query parameters of creating event.
#
# + conferenceDataVersion - Version number of conference data supported by the API client
# + maxAttendees - The maximum number of attendees to include in the response
# + sendUpdates - Whether to send notifications about the creation of the new event
# + supportsAttachments - Whether API client performing operation supports event attachment
public type CreateEventOptional record {
    int? conferenceDataVersion = ();
    int? maxAttendees = ();
    string? sendUpdates = ();
    boolean? supportsAttachments = ();
};

# Define Calendar Resource.
# 
# + kind - Type of the resource
# + etag - ETag of the resource
# + id - Identifier of the calendar
# + summary - Title of the calendar
# + description - Description of the calendar
# + location - Geographic location of the calendar as free-form text
# + timeZone - The time zone of the calendar
# + conferenceProperties - Conferencing properties for this calendar
public type CalendarResource record {
    string kind;
    string etag;
    string id;
    string summary;
    string description?;
    string location?;
    string timeZone;
    ConferenceProperties conferenceProperties;
};

# Define Event response.
#
# + kind - Type of the collection
# + etag - ETag of the collection
# + summary - Title of the calendar.
# + updated - Last modification time of the calendar
# + timeZone - The time zone of the calendar
# + accessRole - The user's access role for this calendar.
# + defaultReminders - The default reminders on the calendar for the authenticated user
# + nextSyncToken - Token used to retrieve only the entries that have changed since this result was returned
# + nextPageToken - Token used to access the next page of this result
# + items - List of events on the calendar
public type EventResponse record {
    string kind;
    string etag;
    string summary;
    string updated;
    string timeZone;
    string accessRole;
    Reminder[] defaultReminders;
    string nextSyncToken?;
    string nextPageToken?;
    Event[] items;
};

# Represent default reminders on the calendar for the authenticated user.
#
# + method - The method used by the reminder
# + minutes - Number of minutes before the start of the event when the reminder should trigger.
public type Reminder record {
    string method;
    int minutes;
};

# Define Event Resource.
#
# + kind - Type of the resource
# + etag - ETag of the resource
# + id - Opaque identifier of the event
# + status - Status of the event
# + htmlLink - An absolute link to this event in the Google Calendar Web UI
# + created - Creation time of the event
# + updated - Last modification time of the event
# + summary - Title of the event
# + description - Description of the event
# + location - Geographic location of the event as free-form text
# + colorId - The color id of the event
# + creator - The creator of the event
# + organizer - The organizer of the event
# + start - The start time of the event.
# + end - The end time of the event.
# + endTimeUnspecified - Whether the end time is actually unspecified
# + recurrence - List of RRULE, EXRULE, RDATE and EXDATE lines for a recurring event, as specified in RFC5545
# + recurringEventId - The id of the recurring event
# + originalStartTime - The start time of the event in recurring events
# + transparency - Whether the event blocks time on the calendar
# + visibility - Visibility of the event
# + iCalUID - Event unique identifier as defined in RFC5545
# + sequence - Sequence number as per iCalendar
# + attendees - The attendees of the event
# + extendedProperties - Extended properties of the event
# + attendeesOmitted - Whether attendees may have been omitted from the event's representation
# + hangoutLink - An absolute link to the Google+ hangout associated with this event
# + conferenceData - The conference-related information
# + gadget - A gadget that extends this event
# + anyoneCanAddSelf - Whether anyone can invite themselves to the event
# + guestsCanInviteOthers - Whether attendees other than the organizer can invite others to the event
# + guestsCanModify - Whether attendees other than the organizer can modify the event
# + guestsCanSeeOtherGuests - Whether attendees other than the organizer can see who the event's attendees are
# + privateCopy - Whether enable event propagation
# + locked - Whether this is a locked event copy
# + reminders - Information about the event's reminders
# + source - Source from which the event was created
# + attachments - File attachments for the event
# + eventType - Specific type of the event [Default/ OutOfOffice]
public type Event record {
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
    Reminders reminders?;
    Source 'source?;
    Attachment[] attachments?;
    string eventType;
};

# Extended properties of the event.
public type ExtendedProperties record {
    *Private;
    *Shared;
};

# Define private event properties.
public type Private record {|
    string...;
|};

# Define shared event properties.
public type Shared record {|
    string...;
|};

# Define conference-related information.
#
# + createRequest - A request to generate a new conference and attach it to the event
# + entryPoints - Information about individual conference entry points
# + conferenceSolution - The conference solution
# + conferenceId - The ID of the conference
# + signature - The signature of the conference data
# + notes - Additional notes to display to the user
public type ConferenceData record {
    CreateRequest createRequest?;
    EntryPoint[] entryPoints;
    ConferenceSolution conferenceSolution;
    string conferenceId?;
    string signature;
    string notes?;
};

# A request to generate a new conference and attach it to the event.
#
# + requestId - The client-generated unique ID for this request
# + conferenceSolutionKey - The conference solution
# + status - The status of the conference create request
public type CreateRequest record {
    string requestId;
    ConferenceSolutionKey conferenceSolutionKey;
    Status status;
};

# Define conference solution key.
#
# + type - The conference solution type
public type ConferenceSolutionKey record {
    string 'type;
};

# Define status.
#
# + statusCode - The current status of the conference create request
public type Status record {
    string statusCode;
};

# Define conference entry points.
#
# + entryPointType - The type of the conference entry point
# + uri - The URI of the entry point
# + label - The label for the URI
# + pin - The PIN to access the conference
# + accessCode - The access code to access the conference
# + meetingCode - The meeting code to access the conference
# + passcode - The passcode to access the conference
# + password - The password to access the conference
# + regionCode - The region code of the conference
public type EntryPoint record {
    string entryPointType;
    string uri;
    string label?;
    string pin?;
    string accessCode?;
    string meetingCode?;
    string passcode?;
    string password?;
    string regionCode?;
};

# Define conference solution.
#
# + key - The key which can uniquely identify the conference solution for this event
# + name - The user-visible name of this solution
# + iconUri - The user-visible icon for this solution
public type ConferenceSolution record {
    Key key;
    string name;
    string iconUri;
};

# Define key record.
#
# + type - The conference solution type
public type Key record {
    string 'type;
};

# Define attendee record.
#
# + id - The attendee's Profile ID
# + email - The attendee's email address
# + displayName - The attendee's name
# + organizer - Whether the attendee is the organizer of the event
# + self - Whether this entry represents the calendar on which this copy of the event appears
# + resource - Whether the attendee is a resource
# + optional - Whether this is an optional attendee
# + responseStatus - The attendee's response status
# + comment - The attendee's response comment
# + additionalGuests - Number of additional guests
public type Attendee record {
    string id?;
    string email;
    string displayName?;
    boolean organizer?;
    boolean self?;
    boolean 'resource?;
    boolean optional?;
    string responseStatus?;
    string comment?;
    string additionalGuests?;
};

# Define user record.
#
# + id - Id of the user
# + email - Email of the user
# + displayName - Name of the user
# + self - Whether the creator corresponds to the calendar on which this copy of the event appears
public type User record {
    string id?;
    string email;
    string displayName?;
    boolean self?;
};

# Define time record.
#
# + date - The date, in the format "yyyy-mm-dd"
# + dateTime - The time, as a combined date-time value
# + timeZone - The time zone in which the time is specified
public type Time record {
    string date?;
    string dateTime?;
    string timeZone?;
};

# Define gadget record.
#
# + preferences - Preferences
# + type - Type of the gadget
# + title - Title of the gadget
# + link - URL of the gadget
# + iconLink - Icon URL of the gadget
# + width - Width of the gadget in pixel
# + height - Height of the gadget in pixel
# + display - Display mode of the gadget
public type Gadget record {
    Preferences preferences;
    string 'type?;
    string title?;
    string link?;
    string iconLink?;
    string width?;
    string height?;
    string display?;
};

# Define Preferences record.
public type Preferences record {|
    string...;
|};

# Define reminder record.
#
# + useDefault - Whether the default reminders of the calendar apply to the event
# + overrides - List the reminders specific to the event
public type Reminders record {
    boolean useDefault;
    Reminder[] overrides?;
};

# Define source record.
#
# + url - URL of the source pointing to a resource
# + title - Title of the source
public type Source record {
    string url;
    string title;
};

# Define attachment record.
#
# + fileUrl - URL link to the attachment
# + title - Attachment title
# + mimeType - Internet media type (MIME type) of the attachment
# + iconLink - URL link to the attachment's icon
# + fileId - ID of the attached file
public type Attachment record {
    string fileUrl;
    string title?;
    string mimeType?;
    string iconLink?;
    string fileId?;
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

# Refer calendar record.
#
# + kind - Type of the resource
# + etag - ETag of the resource
# + id - Identifier of the calendar
# + summary - Title of the calendar
# + description - Description of the calendar
# + location - Geographic location of the calendar
# + timeZone - The time zone of the calendar
# + summaryOverride - The summary that the authenticated user has set for this calendar
# + colorId - The color id of the calendar.
# + selected - Whether the calendar content shows up in the calendar UI
# + backgroundColor - The main color of the calendar in the hexadecimal format
# + foregroundColor - The foreground color of the calendar in the hexadecimal format
# + hidden - Whether the calendar has been hidden from the list
# + deleted - The effective access role that the authenticated user has on the calendar
# + accessRole - The effective access role that the authenticated user has on the calendar
# + defaultReminders - The default reminders that the authenticated user has for this calendar
# + conferenceProperties - Conferencing properties for this calendar
# + primary - Whether the calendar is the primary calendar of the authenticated user
# + notificationSettings - The notifications that the authenticated user is receiving for the calendar
public type Calendar record {
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
    Reminder[] defaultReminders;
    ConferenceProperties conferenceProperties;
    boolean primary?;
    NotificationSettings notificationSettings?;
};

#  Define conference properties.
#
# + allowedConferenceSolutionTypes -Types of conference solutions that are supported for this calendar
public type ConferenceProperties record {
    string[] allowedConferenceSolutionTypes;
};

# Define notification settings.
#
# + notifications - The list of notifications set for this calendar
public type NotificationSettings record {
    Notification[] notifications;
};

# Define notification record.
#
# + type - The method used to deliver the notification
# + method - The type of notification
public type Notification record {
    string 'type;
    string method;
};

# Define optionals for calendar list request.
#
# + minAccessRole - The minimum access role for the user in the returned entries
# + showDeleted - Whether to include deleted calendar list entries in the result
# + showHidden - Whether to show hidden entries
# + syncToken - Token used to access the next page of this result
public type CalendarListOptional record {
    string minAccessRole?;
    boolean showDeleted?;
    boolean showHidden?;
    string syncToken?;
};

# Define calendar list response.
#
# + kind - Type of the collection
# + etag - ETag of the collection
# + nextSyncToken - Token used to retrieve only the entries that have changed since this result was returned
# + nextPageToken - Token used to access the next page of this result
# + items - List of calendars
public type CalendarResponse record {
    string kind;
    string etag;
    string nextSyncToken?;
    string nextPageToken?;
    Calendar[] items;
};
