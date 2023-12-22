// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

public type OkEvent record {|
    *http:Ok;
    Event body;
|};

public type OkFreeBusyResponse record {|
    *http:Ok;
    FreeBusyResponse body;
|};

public type OkAclRule record {|
    *http:Ok;
    AclRule body;
|};

public type OkCalendarListEntry record {|
    *http:Ok;
    CalendarListEntry body;
|};

public type OkCalendar record {|
    *http:Ok;
    Calendar body;
|};

public type FreeBusyResponse record {
    # List of free/busy information for calendars.
    record {|FreeBusyCalendar...;|} calendars?;
    # Expansion of groups.
    record {|FreeBusyGroup...;|} groups?;
    # Type of the resource ("calendar#freeBusy").
    string kind?;
    # The end of the interval.
    string timeMax?;
    # The start of the interval.
    string timeMin?;
};

# Extended properties of the event.
public type Event_extendedProperties record {
    # Properties that are private to the copy of the event that appears on this calendar.
    record {|string...;|} 'private?;
    # Properties that are shared between copies of the event on other attendees' calendars.
    record {|string...;|} shared?;
};

public type ConferenceSolution record {
    # The user-visible icon for this solution.
    string iconUri?;
    ConferenceSolutionKey 'key?;
    # The user-visible name of this solution. Not localized.
    string name?;
};

public type EventDateTime record {
    # The date, in the format "yyyy-mm-dd", if this is an all-day event.
    string date?;
    # The time, as a combined date-time value (formatted according to RFC3339). A time zone offset is required unless a time zone is explicitly specified in timeZone.
    string dateTime?;
    # The time zone in which the time is specified. (Formatted as an IANA Time Zone Database name, e.g. "Europe/Zurich".) For recurring events this field is required and specifies the time zone in which the recurrence is expanded. For single events this field is optional and indicates a custom time zone for the event start/end.
    string timeZone?;
};

public type EntryPoint record {
    # The access code to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional.
    string accessCode?;
    # Features of the entry point, such as being toll or toll-free. One entry point can have multiple features. However, toll and toll-free cannot be both set on the same entry point.
    string[] entryPointFeatures?;
    # The type of the conference entry point.
    # Possible values are:  
    # - "video" - joining a conference over HTTP. A conference can have zero or one video entry point.
    # - "phone" - joining a conference by dialing a phone number. A conference can have zero or more phone entry points.
    # - "sip" - joining a conference over SIP. A conference can have zero or one sip entry point.
    # - "more" - further conference joining instructions, for example additional phone numbers. A conference can have zero or one more entry point. A conference with only a more entry point is not a valid conference.
    string entryPointType?;
    # The label for the URI. Visible to end users. Not localized. The maximum length is 512 characters.
    # Examples:  
    # - for video: meet.google.com/aaa-bbbb-ccc
    # - for phone: +1 123 268 2601
    # - for sip: 12345678@altostrat.com
    # - for more: should not be filled  
    # Optional.
    string label?;
    # The meeting code to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional.
    string meetingCode?;
    # The passcode to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    string passcode?;
    # The password to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional.
    string password?;
    # The PIN to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional.
    string pin?;
    # The CLDR/ISO 3166 region code for the country associated with this phone access. Example: "SE" for Sweden.
    # Calendar backend will populate this field only for EntryPointType.PHONE.
    string regionCode?;
    # The URI of the entry point. The maximum length is 1300 characters.
    # Format:  
    # - for video, http: or https: schema is required.
    # - for phone, tel: schema is required. The URI should include the entire dial sequence (e.g., tel:+12345678900,,,123456789;1234).
    # - for sip, sip: schema is required, e.g., sip:12345678@myprovider.com.
    # - for more, http: or https: schema is required.
    string uri?;
};

public type EventWorkingLocationProperties record {
    # If present, specifies that the user is working from a custom location.
    EventWorkingLocationProperties_customLocation customLocation?;
    # If present, specifies that the user is working at home.
    anydata homeOffice?;
    # If present, specifies that the user is working from an office.
    EventWorkingLocationProperties_officeLocation officeLocation?;
    # Type of the working location. Possible values are:  
    # - "homeOffice" - The user is working at home. 
    # - "officeLocation" - The user is working from an office. 
    # - "customLocation" - The user is working from a custom location.  Any details are specified in a sub-field of the specified name, but this field may be missing if empty. Any other fields are ignored.
    # Required when adding working location properties.
    string 'type?;
};

# The organizer of the event. If the organizer is also an attendee, this is indicated with a separate entry in attendees with the organizer field set to True. To change the organizer, use the move operation. Read-only, except when importing an event.
public type Event_organizer record {
    # The organizer's name, if available.
    string displayName?;
    # The organizer's email address, if available. It must be a valid email address as per RFC5322.
    string email?;
    # The organizer's Profile ID, if available.
    string id?;
    # Whether the organizer corresponds to the calendar on which this copy of the event appears. Read-only. The default is False.
    boolean self?;
};

public type FreeBusyRequestItem record {
    # The identifier of a calendar or a group.
    string id?;
};

public type CalendarListEntry record {
    # The effective access role that the authenticated user has on the calendar. Read-only. Possible values are:  
    # - "freeBusyReader" - Provides read access to free/busy information. 
    # - "reader" - Provides read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
    # - "writer" - Provides read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
    # - "owner" - Provides ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs.
    string accessRole?;
    # The main color of the calendar in the hexadecimal format "#0088aa". This property supersedes the index-based colorId property. To set or change this property, you need to specify colorRgbFormat=true in the parameters of the insert, update and patch methods. Optional.
    string backgroundColor?;
    # The color of the calendar. This is an ID referring to an entry in the calendar section of the colors definition (see the colors endpoint). This property is superseded by the backgroundColor and foregroundColor properties and can be ignored when using these properties. Optional.
    string colorId?;
    ConferenceProperties conferenceProperties?;
    # The default reminders that the authenticated user has for this calendar.
    EventReminder[] defaultReminders?;
    # Whether this calendar list entry has been deleted from the calendar list. Read-only. Optional. The default is False.
    boolean deleted?;
    # Description of the calendar. Optional. Read-only.
    string description?;
    # ETag of the resource.
    string etag?;
    # The foreground color of the calendar in the hexadecimal format "#ffffff". This property supersedes the index-based colorId property. To set or change this property, you need to specify colorRgbFormat=true in the parameters of the insert, update and patch methods. Optional.
    string foregroundColor?;
    # Whether the calendar has been hidden from the list. Optional. The attribute is only returned when the calendar is hidden, in which case the value is true.
    boolean hidden?;
    # Identifier of the calendar.
    string id?;
    # Type of the resource ("calendar#calendarListEntry").
    string kind?;
    # Geographic location of the calendar as free-form text. Optional. Read-only.
    string location?;
    # The notifications that the authenticated user is receiving for this calendar.
    CalendarListEntry_notificationSettings notificationSettings?;
    # Whether the calendar is the primary calendar of the authenticated user. Read-only. Optional. The default is False.
    boolean primary?;
    # Whether the calendar content shows up in the calendar UI. Optional. The default is False.
    boolean selected?;
    # Title of the calendar. Read-only.
    string summary?;
    # The summary that the authenticated user has set for this calendar. Optional.
    string summaryOverride?;
    # The time zone of the calendar. Optional. Read-only.
    string timeZone?;
};

public type Events record {
    # The user's access role for this calendar. Read-only. Possible values are:  
    # - "none" - The user has no access. 
    # - "freeBusyReader" - The user has read access to free/busy information. 
    # - "reader" - The user has read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
    # - "writer" - The user has read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
    # - "owner" - The user has ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs.
    string accessRole?;
    # The default reminders on the calendar for the authenticated user. These reminders apply to all events on this calendar that do not explicitly override them (i.e. do not have reminders.useDefault set to True).
    EventReminder[] defaultReminders?;
    # Description of the calendar. Read-only.
    string description?;
    # ETag of the collection.
    string etag?;
    # List of events on the calendar.
    Event[] items?;
    # Type of the collection ("calendar#events").
    string kind?;
    # Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided.
    string nextPageToken?;
    # Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided.
    string nextSyncToken?;
    # Title of the calendar. Read-only.
    string summary?;
    # The time zone of the calendar. Read-only.
    string timeZone?;
    # Last modification time of the calendar (as a RFC3339 timestamp). Read-only.
    string updated?;
};

public type CalendarList record {
    # ETag of the collection.
    string etag?;
    # Calendars that are present on the user's calendar list.
    CalendarListEntry[] items?;
    # Type of the collection ("calendar#calendarList").
    string kind?;
    # Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided.
    string nextPageToken?;
    # Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided.
    string nextSyncToken?;
};

public type ConferenceData record {
    # The ID of the conference.
    # Can be used by developers to keep track of conferences, should not be displayed to users.
    # The ID value is formed differently for each conference solution type:  
    # - eventHangout: ID is not set. (This conference type is deprecated.)
    # - eventNamedHangout: ID is the name of the Hangout. (This conference type is deprecated.)
    # - hangoutsMeet: ID is the 10-letter meeting code, for example aaa-bbbb-ccc.
    # - addOn: ID is defined by the third-party provider.  Optional.
    string conferenceId?;
    ConferenceSolution conferenceSolution?;
    CreateConferenceRequest createRequest?;
    # Information about individual conference entry points, such as URLs or phone numbers.
    # All of them must belong to the same conference.
    # Either conferenceSolution and at least one entryPoint, or createRequest is required.
    EntryPoint[] entryPoints?;
    # Additional notes (such as instructions from the domain administrator, legal notices) to display to the user. Can contain HTML. The maximum length is 2048 characters. Optional.
    string notes?;
    ConferenceParameters parameters?;
    # The signature of the conference data.
    # Generated on server side.
    # Unset for a conference with a failed create request.
    # Optional for a conference with a pending create request.
    string signature?;
};

public type ColorDefinition record {
    # The background color associated with this color definition.
    string background?;
    # The foreground color that can be used to write on top of a background with 'background' color.
    string foreground?;
};

public type ConferenceRequestStatus record {
    # The current status of the conference create request. Read-only.
    # The possible values are:  
    # - "pending": the conference create request is still being processed.
    # - "success": the conference create request succeeded, the entry points are populated.
    # - "failure": the conference create request failed, there are no entry points.
    string statusCode?;
};

public type EventReminder record {
    # The method used by this reminder. Possible values are:  
    # - "email" - Reminders are sent via email. 
    # - "popup" - Reminders are sent via a UI popup.  
    # Required when adding a reminder.
    string method?;
    # Number of minutes before the start of the event when the reminder should trigger. Valid values are between 0 and 40320 (4 weeks in minutes).
    # Required when adding a reminder.
    int:Signed32 minutes?;
};

# If present, specifies that the user is working from a custom location.
public type EventWorkingLocationProperties_customLocation record {
    # An optional extra label for additional information.
    string label?;
};

public type EventAttendee record {
    # Number of additional guests. Optional. The default is 0.
    int:Signed32 additionalGuests?;
    # The attendee's response comment. Optional.
    string comment?;
    # The attendee's name, if available. Optional.
    string displayName?;
    # The attendee's email address, if available. This field must be present when adding an attendee. It must be a valid email address as per RFC5322.
    # Required when adding an attendee.
    string email?;
    # The attendee's Profile ID, if available.
    string id?;
    # Whether this is an optional attendee. Optional. The default is False.
    boolean optional?;
    # Whether the attendee is the organizer of the event. Read-only. The default is False.
    boolean organizer?;
    # Whether the attendee is a resource. Can only be set when the attendee is added to the event for the first time. Subsequent modifications are ignored. Optional. The default is False.
    boolean 'resource?;
    # The attendee's response status. Possible values are:  
    # - "needsAction" - The attendee has not responded to the invitation (recommended for new events). 
    # - "declined" - The attendee has declined the invitation. 
    # - "tentative" - The attendee has tentatively accepted the invitation. 
    # - "accepted" - The attendee has accepted the invitation.  Warning: If you add an event using the values declined, tentative, or accepted, attendees with the "Add invitations to my calendar" setting set to "When I respond to invitation in email" won't see an event on their calendar unless they choose to change their invitation response in the event invitation email.
    string responseStatus?;
    # Whether this entry represents the calendar on which this copy of the event appears. Read-only. The default is False.
    boolean self?;
};

public type TimePeriod record {
    # The (exclusive) end of the time period.
    string end?;
    # The (inclusive) start of the time period.
    string 'start?;
};

public type Calendar record {
    ConferenceProperties conferenceProperties?;
    # Description of the calendar. Optional.
    string description?;
    # ETag of the resource.
    string etag?;
    # Identifier of the calendar. To retrieve IDs call the calendarList.list() method.
    string id?;
    # Type of the resource ("calendar#calendar").
    string kind?;
    # Geographic location of the calendar as free-form text. Optional.
    string location?;
    # Title of the calendar.
    string summary?;
    # The time zone of the calendar. (Formatted as an IANA Time Zone Database name, e.g. "Europe/Zurich".) Optional.
    string timeZone?;
};

# The extent to which calendar access is granted by this ACL rule.
public type AclRule_scope record {
    # The type of the scope. Possible values are:  
    # - "default" - The public scope. This is the default value. 
    # - "user" - Limits the scope to a single user. 
    # - "group" - Limits the scope to a group. 
    # - "domain" - Limits the scope to a domain.  Note: The permissions granted to the "default", or public, scope apply to any user, authenticated or not.
    string 'type?;
    # The email address of a user or group, or the name of a domain, depending on the scope type. Omitted for type "default".
    string value?;
};

public type Error record {
    # Domain, or broad category, of the error.
    string domain?;
    # Specific reason for the error. Some of the possible values are:  
    # - "groupTooBig" - The group of users requested is too large for a single query. 
    # - "tooManyCalendarsRequested" - The number of calendars requested is too large for a single query. 
    # - "notFound" - The requested resource was not found. 
    # - "internalError" - The API service has encountered an internal error.  Additional error types may be added in the future, so clients should gracefully handle additional error statuses not included in this list.
    string reason?;
};

public type Acl record {
    # ETag of the collection.
    string etag?;
    # List of rules on the access control list.
    AclRule[] items?;
    # Type of the collection ("calendar#acl").
    string kind?;
    # Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided.
    string nextPageToken?;
    # Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided.
    string nextSyncToken?;
};

public type CalendarNotification record {
    # The method used to deliver the notification. The possible value is:  
    # - "email" - Notifications are sent via email.  
    # Required when adding a notification.
    string method?;
    # The type of notification. Possible values are:  
    # - "eventCreation" - Notification sent when a new event is put on the calendar. 
    # - "eventChange" - Notification sent when an event is changed. 
    # - "eventCancellation" - Notification sent when an event is cancelled. 
    # - "eventResponse" - Notification sent when an attendee responds to the event invitation. 
    # - "agenda" - An agenda with the events of the day (sent out in the morning).  
    # Required when adding a notification.
    string 'type?;
};

public type CreateConferenceRequest record {
    ConferenceSolutionKey conferenceSolutionKey?;
    # The client-generated unique ID for this request.
    # Clients should regenerate this ID for every new request. If an ID provided is the same as for the previous request, the request is ignored.
    string requestId?;
    ConferenceRequestStatus status?;
};

public type FreeBusyGroup record {
    # List of calendars' identifiers within a group.
    string[] calendars?;
    # Optional error(s) (if computation for the group failed).
    Error[] errors?;
};

public type FreeBusyCalendar record {
    # List of time ranges during which this calendar should be regarded as busy.
    TimePeriod[] busy?;
    # Optional error(s) (if computation for the calendar failed).
    Error[] errors?;
};

public type FreeBusyRequest record {
    # Maximal number of calendars for which FreeBusy information is to be provided. Optional. Maximum value is 50.
    int:Signed32 calendarExpansionMax?;
    # Maximal number of calendar identifiers to be provided for a single group. Optional. An error is returned for a group with more members than this value. Maximum value is 100.
    int:Signed32 groupExpansionMax?;
    # List of calendars and/or groups to query.
    FreeBusyRequestItem[] items?;
    # The end of the interval for the query formatted as per RFC3339.
    string timeMax?;
    # The start of the interval for the query formatted as per RFC3339.
    string timeMin?;
    # Time zone used in the response. Optional. The default is UTC.
    string timeZone?;
};

public type ConferenceParametersAddOnParameters record {
    record {|string...;|} parameters?;
};

public type ConferenceSolutionKey record {
    # The conference solution type.
    # If a client encounters an unfamiliar or empty type, it should still be able to display the entry points. However, it should disallow modifications.
    # The possible values are:  
    # - "eventHangout" for Hangouts for consumers (deprecated; existing events may show this conference solution type but new conferences cannot be created)
    # - "eventNamedHangout" for classic Hangouts for Google Workspace users (deprecated; existing events may show this conference solution type but new conferences cannot be created)
    # - "hangoutsMeet" for Google Meet (http://meet.google.com)
    # - "addOn" for 3P conference providers
    string 'type?;
};

public type EventAttachment record {
    # ID of the attached file. Read-only.
    # For Google Drive files, this is the ID of the corresponding Files resource entry in the Drive API.
    string fileId?;
    # URL link to the attachment.
    # For adding Google Drive file attachments use the same format as in alternateLink property of the Files resource in the Drive API.
    # Required when adding an attachment.
    string fileUrl?;
    # URL link to the attachment's icon. This field can only be modified for custom third-party attachments.
    string iconLink?;
    # Internet media type (MIME type) of the attachment.
    string mimeType?;
    # Attachment title.
    string title?;
};

# The notifications that the authenticated user is receiving for this calendar.
public type CalendarListEntry_notificationSettings record {
    # The list of notifications set for this calendar.
    CalendarNotification[] notifications?;
};

public type Colors record {
    # A global palette of calendar colors, mapping from the color ID to its definition. A calendarListEntry resource refers to one of these color IDs in its colorId field. Read-only.
    record {|ColorDefinition...;|} calendar?;
    # A global palette of event colors, mapping from the color ID to its definition. An event resource may refer to one of these color IDs in its colorId field. Read-only.
    record {|ColorDefinition...;|} event?;
    # Type of the resource ("calendar#colors").
    string kind?;
    # Last modification time of the color palette (as a RFC3339 timestamp). Read-only.
    string updated?;
};

# Information about the event's reminders for the authenticated user.
public type Event_reminders record {
    # If the event doesn't use the default reminders, this lists the reminders specific to the event, or, if not set, indicates that no reminders are set for this event. The maximum number of override reminders is 5.
    EventReminder[] overrides?;
    # Whether the default reminders of the calendar apply to the event.
    boolean useDefault?;
};

# Source from which the event was created. For example, a web page, an email message or any document identifiable by an URL with HTTP or HTTPS scheme. Can only be seen or modified by the creator of the event.
public type Event_source record {
    # Title of the source; for example a title of a web page or an email subject.
    string title?;
    # URL of the source pointing to a resource. The URL scheme must be HTTP or HTTPS.
    string url?;
};

public type ConferenceParameters record {
    ConferenceParametersAddOnParameters addOnParameters?;
};

public type Event record {
    # Whether anyone can invite themselves to the event (deprecated). Optional. The default is False.
    boolean anyoneCanAddSelf?;
    # File attachments for the event.
    # In order to modify attachments the supportsAttachments request parameter should be set to true.
    # There can be at most 25 attachments per event,
    EventAttachment[] attachments?;
    # The attendees of the event. See the Events with attendees guide for more information on scheduling events with other calendar users. Service accounts need to use domain-wide delegation of authority to populate the attendee list.
    EventAttendee[] attendees?;
    # Whether attendees may have been omitted from the event's representation. When retrieving an event, this may be due to a restriction specified by the maxAttendee query parameter. When updating an event, this can be used to only update the participant's response. Optional. The default is False.
    boolean attendeesOmitted?;
    # The color of the event. This is an ID referring to an entry in the event section of the colors definition (see the  colors endpoint). Optional.
    string colorId?;
    ConferenceData conferenceData?;
    # Creation time of the event (as a RFC3339 timestamp). Read-only.
    string created?;
    # The creator of the event. Read-only.
    Event_creator creator?;
    # Description of the event. Can contain HTML. Optional.
    string description?;
    EventDateTime end?;
    # Whether the end time is actually unspecified. An end time is still provided for compatibility reasons, even if this attribute is set to True. The default is False.
    boolean endTimeUnspecified?;
    # ETag of the resource.
    string etag?;
    # Specific type of the event. This cannot be modified after the event is created. Possible values are:  
    # - "default" - A regular event or not further specified. 
    # - "outOfOffice" - An out-of-office event. 
    # - "focusTime" - A focus-time event. 
    # - "workingLocation" - A working location event.  Currently, only "default " and "workingLocation" events can be created using the API. Extended support for other event types will be made available in later releases.
    string eventType?;
    # Extended properties of the event.
    Event_extendedProperties extendedProperties?;
    # Whether attendees other than the organizer can invite others to the event. Optional. The default is True.
    boolean guestsCanInviteOthers?;
    # Whether attendees other than the organizer can modify the event. Optional. The default is False.
    boolean guestsCanModify?;
    # Whether attendees other than the organizer can see who the event's attendees are. Optional. The default is True.
    boolean guestsCanSeeOtherGuests?;
    # An absolute link to the Google Hangout associated with this event. Read-only.
    string hangoutLink?;
    # An absolute link to this event in the Google Calendar Web UI. Read-only.
    string htmlLink?;
    # Event unique identifier as defined in RFC5545. It is used to uniquely identify events accross calendaring systems and must be supplied when importing events via the import method.
    # Note that the iCalUID and the id are not identical and only one of them should be supplied at event creation time. One difference in their semantics is that in recurring events, all occurrences of one event have different ids while they all share the same iCalUIDs. To retrieve an event using its iCalUID, call the events.list method using the iCalUID parameter. To retrieve an event using its id, call the events.get method.
    string iCalUID?;
    # Opaque identifier of the event. When creating new single or recurring events, you can specify their IDs. Provided IDs must follow these rules:  
    # - characters allowed in the ID are those used in base32hex encoding, i.e. lowercase letters a-v and digits 0-9, see section 3.1.2 in RFC2938 
    # - the length of the ID must be between 5 and 1024 characters 
    # - the ID must be unique per calendar  Due to the globally distributed nature of the system, we cannot guarantee that ID collisions will be detected at event creation time. To minimize the risk of collisions we recommend using an established UUID algorithm such as one described in RFC4122.
    # If you do not specify an ID, it will be automatically generated by the server.
    # Note that the icalUID and the id are not identical and only one of them should be supplied at event creation time. One difference in their semantics is that in recurring events, all occurrences of one event have different ids while they all share the same icalUIDs.
    string id?;
    # Type of the resource ("calendar#event").
    string kind?;
    # Geographic location of the event as free-form text. Optional.
    string location?;
    # Whether this is a locked event copy where no changes can be made to the main event fields "summary", "description", "location", "start", "end" or "recurrence". The default is False. Read-Only.
    boolean locked?;
    # The organizer of the event. If the organizer is also an attendee, this is indicated with a separate entry in attendees with the organizer field set to True. To change the organizer, use the move operation. Read-only, except when importing an event.
    Event_organizer organizer?;
    EventDateTime originalStartTime?;
    # If set to True, Event propagation is disabled. Note that it is not the same thing as Private event properties. Optional. Immutable. The default is False.
    boolean privateCopy?;
    # List of RRULE, EXRULE, RDATE and EXDATE lines for a recurring event, as specified in RFC5545. Note that DTSTART and DTEND lines are not allowed in this field; event start and end times are specified in the start and end fields. This field is omitted for single events or instances of recurring events.
    string[] recurrence?;
    # For an instance of a recurring event, this is the id of the recurring event to which this instance belongs. Immutable.
    string recurringEventId?;
    # Information about the event's reminders for the authenticated user.
    Event_reminders reminders?;
    # Sequence number as per iCalendar.
    int:Signed32 sequence?;
    # Source from which the event was created. For example, a web page, an email message or any document identifiable by an URL with HTTP or HTTPS scheme. Can only be seen or modified by the creator of the event.
    Event_source 'source?;
    EventDateTime 'start?;
    # Status of the event. Optional. Possible values are:  
    # - "confirmed" - The event is confirmed. This is the default status. 
    # - "tentative" - The event is tentatively confirmed. 
    # - "cancelled" - The event is cancelled (deleted). The list method returns cancelled events only on incremental sync (when syncToken or updatedMin are specified) or if the showDeleted flag is set to true. The get method always returns them.
    # A cancelled status represents two different states depending on the event type:  
    # - Cancelled exceptions of an uncancelled recurring event indicate that this instance should no longer be presented to the user. Clients should store these events for the lifetime of the parent recurring event.
    # Cancelled exceptions are only guaranteed to have values for the id, recurringEventId and originalStartTime fields populated. The other fields might be empty.  
    # - All other cancelled events represent deleted events. Clients should remove their locally synced copies. Such cancelled events will eventually disappear, so do not rely on them being available indefinitely.
    # Deleted events are only guaranteed to have the id field populated.   On the organizer's calendar, cancelled events continue to expose event details (summary, location, etc.) so that they can be restored (undeleted). Similarly, the events to which the user was invited and that they manually removed continue to provide details. However, incremental sync requests with showDeleted set to false will not return these details.
    # If an event changes its organizer (for example via the move operation) and the original organizer is not on the attendee list, it will leave behind a cancelled event where only the id field is guaranteed to be populated.
    string status?;
    # Title of the event.
    string summary?;
    # Whether the event blocks time on the calendar. Optional. Possible values are:  
    # - "opaque" - Default value. The event does block time on the calendar. This is equivalent to setting Show me as to Busy in the Calendar UI. 
    # - "transparent" - The event does not block time on the calendar. This is equivalent to setting Show me as to Available in the Calendar UI.
    string transparency?;
    # Last modification time of the event (as a RFC3339 timestamp). Read-only.
    string updated?;
    # Visibility of the event. Optional. Possible values are:  
    # - "default" - Uses the default visibility for events on the calendar. This is the default value. 
    # - "public" - The event is public and event details are visible to all readers of the calendar. 
    # - "private" - The event is private and only event attendees may view event details. 
    # - "confidential" - The event is private. This value is provided for compatibility reasons.
    string visibility?;
    EventWorkingLocationProperties workingLocationProperties?;
};

public type ConferenceProperties record {
    # The types of conference solutions that are supported for this calendar.
    # The possible values are:  
    # - "eventHangout" 
    # - "eventNamedHangout" 
    # - "hangoutsMeet"  Optional.
    string[] allowedConferenceSolutionTypes?;
};

public type AclRule record {
    # ETag of the resource.
    string etag?;
    # Identifier of the Access Control List (ACL) rule. See Sharing calendars.
    string id?;
    # Type of the resource ("calendar#aclRule").
    string kind?;
    # The role assigned to the scope. Possible values are:  
    # - "none" - Provides no access. 
    # - "freeBusyReader" - Provides read access to free/busy information. 
    # - "reader" - Provides read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
    # - "writer" - Provides read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
    # - "owner" - Provides ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs.
    string role?;
    # The extent to which calendar access is granted by this ACL rule.
    AclRule_scope scope?;
};

# The creator of the event. Read-only.
public type Event_creator record {
    # The creator's name, if available.
    string displayName?;
    # The creator's email address, if available.
    string email?;
    # The creator's Profile ID, if available.
    string id?;
    # Whether the creator corresponds to the calendar on which this copy of the event appears. Read-only. The default is False.
    boolean self?;
};

# If present, specifies that the user is working from an office.
public type EventWorkingLocationProperties_officeLocation record {
    # An optional building identifier. This should reference a building ID in the organization's Resources database.
    string buildingId?;
    # An optional desk identifier.
    string deskId?;
    # An optional floor identifier.
    string floorId?;
    # An optional floor section identifier.
    string floorSectionId?;
    # The office name that's displayed in Calendar Web and Mobile clients. We recommend you reference a building name in the organization's Resources database.
    string label?;
};
