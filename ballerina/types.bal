// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
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

import ballerina/constraint;
import ballerina/http;

# Represents the Queries record for the operation: calendar.acl.update
public type CalendarAclUpdateQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True
    boolean sendNotifications?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

public type FreeBusyResponse record {
    # List of free/busy information for calendars
    record {|FreeBusyCalendar...;|} calendars?;
    # Type of the resource ("calendar#freeBusy")
    string kind = "calendar#freeBusy";
    # Expansion of groups
    record {|FreeBusyGroup...;|} groups?;
    # The end of the interval
    string timeMax?;
    # The start of the interval
    string timeMin?;
};

# Represents the Queries record for the operation: calendar.calendars.clear
public type CalendarCalendarsClearQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents conference solutions that users can utilize when scheduling or participating in events and meetings
public type ConferenceSolution record {
    # The user-visible name of this solution. Not localized
    string name?;
    # The user-visible icon for this solution
    string iconUri?;
    # Represents the key information for a conference solution
    ConferenceSolutionKey 'key?;
};

# Represents the Queries record for the operation: calendar.events.get
public type CalendarEventsGetQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Time zone used in the response. Optional. The default is the time zone of the calendar
    string timeZone?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
    # The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional
    @constraint:Int {minValue: 1}
    int maxAttendees?;
};

# Defines the date, time, and time zone information for events
public type EventDateTime record {
    # The date, in the format "yyyy-mm-dd", if this is an all-day event
    string date?;
    # The time, as a combined date-time value (formatted according to RFC3339). A time zone offset is required unless a time zone is explicitly specified in timeZone
    string dateTime?;
    # The time zone in which the time is specified. (Formatted as an IANA Time Zone Database name, e.g. "Europe/Zurich".) For recurring events this field is required and specifies the time zone in which the recurrence is expanded. For single events this field is optional and indicates a custom time zone for the event start/end
    string timeZone?;
};

# Represents the Queries record for the operation: calendar.events.move
public type CalendarEventsMoveQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Guests who should receive notifications about the change of the event's organizer
    "all"|"externalOnly"|"none" sendUpdates?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Calendar identifier of the target calendar where the event is to be moved to
    string destination;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.acl.list
public type CalendarAclListQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False
    boolean showDeleted?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries
    string syncToken?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional
    @constraint:Int {minValue: 1}
    int maxResults?;
    # Data format for the response
    "json" alt?;
    # Token specifying which result page to return. Optional
    string pageToken?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents information for different methods of joining a conference or event
public type EntryPoint record {
    # Features of the entry point, such as being toll or toll-free. One entry point can have multiple features. However, toll and toll-free cannot be both set on the same entry point
    string[] entryPointFeatures?;
    # The password to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional
    string password?;
    # The CLDR/ISO 3166 region code for the country associated with this phone access. Example: "SE" for Sweden.
    # Calendar backend will populate this field only for EntryPointType.PHONE
    string regionCode?;
    # The PIN to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional
    string pin?;
    # The type of the conference entry point.
    # Possible values are:  
    # - "video" - joining a conference over HTTP. A conference can have zero or one video entry point.
    # - "phone" - joining a conference by dialing a phone number. A conference can have zero or more phone entry points.
    # - "sip" - joining a conference over SIP. A conference can have zero or one sip entry point.
    # - "more" - further conference joining instructions, for example additional phone numbers. A conference can have zero or one more entry point. A conference with only a more entry point is not a valid conference
    string entryPointType?;
    # The access code to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional
    string accessCode?;
    # The meeting code to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    # Optional
    string meetingCode?;
    # The label for the URI. Visible to end users. Not localized. The maximum length is 512 characters.
    # Examples:  
    # - for video: meet.google.com/aaa-bbbb-ccc
    # - for phone: +1 123 268 2601
    # - for sip: 12345678@altostrat.com
    # - for more: should not be filled  
    # Optional
    string label?;
    # The URI of the entry point. The maximum length is 1300 characters.
    # Format:  
    # - for video, http: or https: schema is required.
    # - for phone, tel: schema is required. The URI should include the entire dial sequence (e.g., tel:+12345678900,,,123456789;1234).
    # - for sip, sip: schema is required, e.g., sip:12345678@myprovider.com.
    # - for more, http: or https: schema is required
    string uri?;
    # The passcode to access the conference. The maximum length is 128 characters.
    # When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed
    string passcode?;
};

# Identifies the target calendar or group for which free/busy information is requested
public type FreeBusyRequestItem record {
    # The identifier of a calendar or a group
    string id?;
};

# Represents the Queries record for the operation: calendar.events.update
public type CalendarEventsUpdateQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Guests who should receive notifications about the event update (for example, title changes, etc.)
    "all"|"externalOnly"|"none" sendUpdates?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Whether API client performing operation supports event attachments. Optional. The default is False
    boolean supportsAttachments?;
    # Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0
    @constraint:Int {minValue: 0, maxValue: 1}
    int conferenceDataVersion?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
    # The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional
    @constraint:Int {minValue: 1}
    int maxAttendees?;
};

# Represents the Queries record for the operation: calendar.calendars.get
public type CalendarCalendarsGetQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# If present, specifies that the user is working from an office
public type EventWorkingLocationPropertiesOfficeLocation record {
    # An optional floor identifier
    string floorId?;
    # An optional floor section identifier
    string floorSectionId?;
    # The office name that's displayed in Calendar Web and Mobile clients. We recommend you reference a building name in the organization's Resources database
    string label?;
    # An optional desk identifier
    string deskId?;
    # An optional building identifier. This should reference a building ID in the organization's Resources database
    string buildingId?;
};

# Represents the Queries record for the operation: calendar.colors.get
public type CalendarColorsGetQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# If present, specifies that the user is working from a custom location
public type EventWorkingLocationPropertiesCustomLocation record {
    # An optional extra label for additional information
    string label?;
};

# Represents the Queries record for the operation: calendar.acl.insert
public type CalendarAclInsertQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Whether to send notifications about the calendar sharing change. Optional. The default is True
    boolean sendNotifications?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.acl.patch
public type CalendarAclPatchQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True
    boolean sendNotifications?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.events.import
public type CalendarEventsImportQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Whether API client performing operation supports event attachments. Optional. The default is False
    boolean supportsAttachments?;
    # Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0
    @constraint:Int {minValue: 0, maxValue: 1}
    int conferenceDataVersion?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    http:ClientHttp1Settings http1Settings = {};
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings = {};
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 30;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with Redirection
    http:FollowRedirects followRedirects?;
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache = {};
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with cookies
    http:CookieConfig cookieConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits = {};
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Provides settings related to client socket configuration
    http:ClientSocketConfig socketConfig = {};
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
    # Enables relaxed data binding on the client side. When enabled, `nil` values are treated as optional, 
    # and absent fields are handled as `nilable` types. Enabled by default.
    boolean laxDataBinding = true;
|};

# Represents information about conferences associated with calendar events
public type ConferenceData record {
    # Information about individual conference entry points, such as URLs or phone numbers.
    # All of them must belong to the same conference.
    # Either conferenceSolution and at least one entryPoint, or createRequest is required
    EntryPoint[] entryPoints?;
    # Additional notes (such as instructions from the domain administrator, legal notices) to display to the user. Can contain HTML. The maximum length is 2048 characters. Optional
    string notes?;
    # The ID of the conference.
    # Can be used by developers to keep track of conferences, should not be displayed to users.
    # The ID value is formed differently for each conference solution type:  
    # - eventHangout: ID is not set. (This conference type is deprecated.)
    # - eventNamedHangout: ID is the name of the Hangout. (This conference type is deprecated.)
    # - hangoutsMeet: ID is the 10-letter meeting code, for example aaa-bbbb-ccc.
    # - addOn: ID is defined by the third-party provider.  Optional
    string conferenceId?;
    # Represents the request to create a conference within a calendar event
    CreateConferenceRequest createRequest?;
    # The signature of the conference data.
    # Generated on server side.
    # Unset for a conference with a failed create request.
    # Optional for a conference with a pending create request
    string signature?;
    # Represents conference solutions that users can utilize when scheduling or participating in events and meetings
    ConferenceSolution conferenceSolution?;
    # Represents parameters related to conference settings for events
    ConferenceParameters parameters?;
};

# Provides information about the current status of a conference create request
public type ConferenceRequestStatus record {
    # The current status of the conference create request. Read-only.
    # The possible values are:  
    # - "pending": the conference create request is still being processed.
    # - "success": the conference create request succeeded, the entry points are populated.
    # - "failure": the conference create request failed, there are no entry points
    string statusCode?;
};

# Defines and represents time intervals or periods
public type TimePeriod record {
    # The (inclusive) start of the time period
    string 'start?;
    # The (exclusive) end of the time period
    string end?;
};

# Represents the Queries record for the operation: calendar.acl.delete
public type CalendarAclDeleteQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the request to create a conference within a calendar event
public type CreateConferenceRequest record {
    # The client-generated unique ID for this request.
    # Clients should regenerate this ID for every new request. If an ID provided is the same as for the previous request, the request is ignored
    string requestId?;
    # Represents the key information for a conference solution
    ConferenceSolutionKey conferenceSolutionKey?;
    # Provides information about the current status of a conference create request
    ConferenceRequestStatus status?;
};

# Represents the Queries record for the operation: calendar.events.list
public type CalendarEventsListQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All events deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
    # There are several query parameters that cannot be specified together with nextSyncToken to ensure consistency of the client state.
    # 
    # These are: 
    # - iCalUID 
    # - orderBy 
    # - privateExtendedProperty 
    # - q 
    # - sharedExtendedProperty 
    # - timeMin 
    # - timeMax 
    # - updatedMin All other query parameters should be the same as for the initial synchronization to avoid undefined behavior. If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries
    string syncToken?;
    # Specifies an event ID in the iCalendar format to be provided in the response. Optional. Use this if you want to search for an event by its iCalendar ID
    string iCalUID?;
    # Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints
    string[] sharedExtendedProperty?;
    # Data format for the response
    "json" alt?;
    # The order of the events returned in the result. Optional. The default is an unspecified, stable order
    "startTime"|"updated" orderBy?;
    # Time zone used in the response. Optional. The default is the time zone of the calendar
    string timeZone?;
    # Whether to include hidden invitations in the result. Optional. The default is False
    boolean showHiddenInvitations?;
    # Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax
    string timeMin?;
    # Event types to return. Optional. Possible values are: 
    # - "default" 
    # - "focusTime" 
    # - "outOfOffice" 
    # - "workingLocation"This parameter can be repeated multiple times to return events of different types. Currently, these are the only allowed values for this field: 
    # - ["default", "focusTime", "outOfOffice"] 
    # - ["default", "focusTime", "outOfOffice", "workingLocation"] 
    # - ["workingLocation"] The default is ["default", "focusTime", "outOfOffice"].
    # Additional combinations of these four event types will be made available in later releases
    string[] eventTypes?;
    # Free text search terms to find events that match these terms in the following fields: summary, description, location, attendee's displayName, attendee's email. Optional
    string q?;
    # Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False
    boolean showDeleted?;
    # Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False
    boolean singleEvents?;
    # Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time
    string updatedMin?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional
    @constraint:Int {minValue: 1}
    int maxResults?;
    # Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints
    string[] privateExtendedProperty?;
    # Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin
    string timeMax?;
    # Token specifying which result page to return. Optional
    string pageToken?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
    # The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional
    @constraint:Int {minValue: 1}
    int maxAttendees?;
};

# Represents the Queries record for the operation: calendar.events.insert
public type CalendarEventsInsertQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Whether to send notifications about the creation of the new event. Note that some emails might still be sent. The default is false
    "all"|"externalOnly"|"none" sendUpdates?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Whether API client performing operation supports event attachments. Optional. The default is False
    boolean supportsAttachments?;
    # Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0
    @constraint:Int {minValue: 0, maxValue: 1}
    int conferenceDataVersion?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
    # The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional
    @constraint:Int {minValue: 1}
    int maxAttendees?;
};

# Response data with free/busy information
public type FreeBusyCalendar record {
    # List of time ranges during which this calendar should be regarded as busy
    TimePeriod[] busy?;
    # Optional error(s) (if computation for the calendar failed)
    Error[] errors?;
};

# Source from which the event was created. For example, a web page, an email message or any document identifiable by an URL with HTTP or HTTPS scheme. Can only be seen or modified by the creator of the event
public type EventSource record {
    # Title of the source; for example a title of a web page or an email subject
    string title?;
    # URL of the source pointing to a resource. The URL scheme must be HTTP or HTTPS
    string url?;
};

# Represents a global palette of calendar and event colors used in Google Calendar
public type Colors record {
    # A global palette of calendar colors, mapping from the color ID to its definition. A calendarListEntry resource refers to one of these color IDs in its colorId field. Read-only
    record {|ColorDefinition...;|} calendar?;
    # Type of the resource ("calendar#colors")
    string kind = "calendar#colors";
    # A global palette of event colors, mapping from the color ID to its definition. An event resource may refer to one of these color IDs in its colorId field. Read-only
    record {|ColorDefinition...;|} event?;
    # Last modification time of the color palette (as a RFC3339 timestamp). Read-only
    string updated?;
};

# Specify the types of conference solutions supported for a calendar
public type ConferenceProperties record {
    # The types of conference solutions that are supported for this calendar.
    # The possible values are:  
    # - "eventHangout" 
    # - "eventNamedHangout" 
    # - "hangoutsMeet"  Optional
    string[] allowedConferenceSolutionTypes?;
};

# Represents the Queries record for the operation: calendar.calendars.patch
public type CalendarCalendarsPatchQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# The notifications that the authenticated user is receiving for this calendar
public type CalendarListEntryNotificationSettings record {
    # The list of notifications set for this calendar
    CalendarNotification[] notifications?;
};

# Represents the Queries record for the operation: calendar.freebusy.query
public type CalendarFreebusyQueryQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.calendarList.list
public type CalendarCalendarListListQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Whether to include deleted calendar list entries in the result. Optional. The default is False
    boolean showDeleted?;
    # Whether to show hidden entries. Optional. The default is False
    boolean showHidden?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
    # To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
    # If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
    # Learn more about incremental synchronization.
    # Optional. The default is to return all entries
    string syncToken?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional
    @constraint:Int {minValue: 1}
    int maxResults?;
    # The minimum access role for the user in the returned entries. Optional. The default is no restriction
    "freeBusyReader"|"owner"|"reader"|"writer" minAccessRole?;
    # Data format for the response
    "json" alt?;
    # Token specifying which result page to return. Optional
    string pageToken?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.calendarList.update
public type CalendarCalendarListUpdateQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False
    boolean colorRgbFormat?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Conveys information about the working location of a user during an event
public type EventWorkingLocationProperties record {
    # If present, specifies that the user is working from an office
    EventWorkingLocationPropertiesOfficeLocation officeLocation?;
    # If present, specifies that the user is working at home
    anydata homeOffice?;
    # If present, specifies that the user is working from a custom location
    EventWorkingLocationPropertiesCustomLocation customLocation?;
    # Type of the working location. Possible values are:  
    # - "homeOffice" - The user is working at home. 
    # - "officeLocation" - The user is working from an office. 
    # - "customLocation" - The user is working from a custom location.  Any details are specified in a sub-field of the specified name, but this field may be missing if empty. Any other fields are ignored.
    # Required when adding working location properties
    string 'type?;
};

# Represents the Queries record for the operation: delete.calendar
public type DeleteCalendarQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.calendars.update
public type CalendarCalendarsUpdateQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# The organizer of the event. If the organizer is also an attendee, this is indicated with a separate entry in attendees with the organizer field set to True. To change the organizer, use the move operation. Read-only, except when importing an event
public type EventOrganizer record {
    # The organizer's name, if available
    string displayName?;
    # Whether the organizer corresponds to the calendar on which this copy of the event appears. Read-only. The default is False
    boolean self = false;
    # The organizer's Profile ID, if available
    string id?;
    # The organizer's email address, if available. It must be a valid email address as per RFC5322
    string email?;
};

# Represents the Queries record for the operation: create.calendar
public type CreateCalendarQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represent calendar properties which allow users to manage and interact with their calendars effectively
public type CalendarListEntry record {
    # Specify the types of conference solutions supported for a calendar
    ConferenceProperties conferenceProperties?;
    # Title of the calendar. Read-only
    string summary?;
    # The main color of the calendar in the hexadecimal format "#0088aa". This property supersedes the index-based colorId property. To set or change this property, you need to specify colorRgbFormat=true in the parameters of the insert, update and patch methods. Optional
    string backgroundColor?;
    # Whether the calendar has been hidden from the list. Optional. The attribute is only returned when the calendar is hidden, in which case the value is true
    boolean hidden = false;
    # The color of the calendar. This is an ID referring to an entry in the calendar section of the colors definition (see the colors endpoint). This property is superseded by the backgroundColor and foregroundColor properties and can be ignored when using these properties. Optional
    string colorId?;
    # Type of the resource ("calendar#calendarListEntry")
    string kind = "calendar#calendarListEntry";
    # Description of the calendar. Optional. Read-only
    string description?;
    # The time zone of the calendar. Optional. Read-only
    string timeZone?;
    # The foreground color of the calendar in the hexadecimal format "#ffffff". This property supersedes the index-based colorId property. To set or change this property, you need to specify colorRgbFormat=true in the parameters of the insert, update and patch methods. Optional
    string foregroundColor?;
    # The notifications that the authenticated user is receiving for this calendar
    CalendarListEntryNotificationSettings notificationSettings?;
    # Whether this calendar list entry has been deleted from the calendar list. Read-only. Optional. The default is False
    boolean deleted = false;
    # The summary that the authenticated user has set for this calendar. Optional
    string summaryOverride?;
    # The default reminders that the authenticated user has for this calendar
    EventReminder[] defaultReminders?;
    # The effective access role that the authenticated user has on the calendar. Read-only. Possible values are:  
    # - "freeBusyReader" - Provides read access to free/busy information. 
    # - "reader" - Provides read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
    # - "writer" - Provides read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
    # - "owner" - Provides ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs
    string accessRole?;
    # ETag of the resource
    string etag?;
    # Geographic location of the calendar as free-form text. Optional. Read-only
    string location?;
    # Identifier of the calendar
    string id?;
    # Whether the calendar content shows up in the calendar UI. Optional. The default is False
    boolean selected = false;
    # Whether the calendar is the primary calendar of the authenticated user. Read-only. Optional. The default is False
    boolean primary = false;
};

# Represents the Queries record for the operation: calendar.events.quickAdd
public type CalendarEventsQuickAddQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Guests who should receive notifications about the creation of the new event
    "all"|"externalOnly"|"none" sendUpdates?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # The text describing the event to be created
    string text;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Reprsents event properties which allow users to access and manage calendar event
public type Events record {
    # Title of the calendar. Read-only
    string summary?;
    # The default reminders on the calendar for the authenticated user. These reminders apply to all events on this calendar that do not explicitly override them (i.e. do not have reminders.useDefault set to True)
    EventReminder[] defaultReminders?;
    # Type of the collection ("calendar#events")
    string kind = "calendar#events";
    # Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided
    string nextPageToken?;
    # Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided
    string nextSyncToken?;
    # The user's access role for this calendar. Read-only. Possible values are:  
    # - "none" - The user has no access. 
    # - "freeBusyReader" - The user has read access to free/busy information. 
    # - "reader" - The user has read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
    # - "writer" - The user has read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
    # - "owner" - The user has ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs
    string accessRole?;
    # Description of the calendar. Read-only
    string description?;
    # The time zone of the calendar. Read-only
    string timeZone?;
    # ETag of the collection
    string etag?;
    # List of events on the calendar
    Event[] items?;
    # Last modification time of the calendar (as a RFC3339 timestamp). Read-only
    string updated?;
};

# Represents the Queries record for the operation: calendar.calendarList.delete
public type CalendarCalendarListDeleteQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# OAuth2 Refresh Token Grant Configs
public type OAuth2RefreshTokenGrantConfig record {|
    *http:OAuth2RefreshTokenGrantConfig;
    # Refresh URL
    string refreshUrl = "https://accounts.google.com/o/oauth2/token";
|};

# Represents the Queries record for the operation: calendar.acl.get
public type CalendarAclGetQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Extended properties of the event
public type EventExtendedProperties record {
    # Properties that are shared between copies of the event on other attendees' calendars
    record {|string...;|} shared?;
    # Properties that are private to the copy of the event that appears on this calendar
    record {|string...;|} 'private?;
};

# Represents list of calendars associated with the user's account
public type CalendarList record {
    # Type of the collection ("calendar#calendarList")
    string kind = "calendar#calendarList";
    # Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided
    string nextPageToken?;
    # Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided
    string nextSyncToken?;
    # ETag of the collection
    string etag?;
    # Calendars that are present on the user's calendar list
    CalendarListEntry[] items?;
};

# Represents the Queries record for the operation: calendar.calendarList.patch
public type CalendarCalendarListPatchQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False
    boolean colorRgbFormat?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Defines and manages color combinations associated with calendar events
public type ColorDefinition record {
    # The background color associated with this color definition
    string background?;
    # The foreground color that can be used to write on top of a background with 'background' color
    string foreground?;
};

# Allows users to define how and when to be reminded of upcoming events
public type EventReminder record {
    # The method used by this reminder. Possible values are:  
    # - "email" - Reminders are sent via email. 
    # - "popup" - Reminders are sent via a UI popup.  
    # Required when adding a reminder
    string method?;
    # Number of minutes before the start of the event when the reminder should trigger. Valid values are between 0 and 40320 (4 weeks in minutes).
    # Required when adding a reminder
    int:Signed32 minutes?;
};

# Information about the event's reminders for the authenticated user
public type EventReminders record {
    # If the event doesn't use the default reminders, this lists the reminders specific to the event, or, if not set, indicates that no reminders are set for this event. The maximum number of override reminders is 5
    EventReminder[] overrides?;
    # Whether the default reminders of the calendar apply to the event
    boolean useDefault?;
};

# Represents the Queries record for the operation: calendar.events.delete
public type CalendarEventsDeleteQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Guests who should receive notifications about the deletion of the event
    "all"|"externalOnly"|"none" sendUpdates?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.events.instances
public type CalendarEventsInstancesQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Data format for the response
    "json" alt?;
    # Time zone used in the response. Optional. The default is the time zone of the calendar
    string timeZone?;
    # Lower bound (inclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset
    string timeMin?;
    # Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events will still be included if singleEvents is False. Optional. The default is False
    boolean showDeleted?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Maximum number of events returned on one result page. By default the value is 250 events. The page size can never be larger than 2500 events. Optional
    @constraint:Int {minValue: 1}
    int maxResults?;
    # The original start time of the instance in the result. Optional
    string originalStart?;
    # Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset
    string timeMax?;
    # Token specifying which result page to return. Optional
    string pageToken?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
    # The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional
    @constraint:Int {minValue: 1}
    int maxAttendees?;
};

# Manages and describes attendees and their responses to calendar events
public type EventAttendee record {
    # Number of additional guests. Optional. The default is 0
    int:Signed32 additionalGuests = 0;
    # Whether the attendee is a resource. Can only be set when the attendee is added to the event for the first time. Subsequent modifications are ignored. Optional. The default is False
    boolean 'resource = false;
    # The attendee's name, if available. Optional
    string displayName?;
    # Whether the attendee is the organizer of the event. Read-only. The default is False
    boolean organizer?;
    # Whether this entry represents the calendar on which this copy of the event appears. Read-only. The default is False
    boolean self = false;
    # The attendee's response comment. Optional
    string comment?;
    # Whether this is an optional attendee. Optional. The default is False
    boolean optional = false;
    # The attendee's Profile ID, if available
    string id?;
    # The attendee's response status. Possible values are:  
    # - "needsAction" - The attendee has not responded to the invitation (recommended for new events). 
    # - "declined" - The attendee has declined the invitation. 
    # - "tentative" - The attendee has tentatively accepted the invitation. 
    # - "accepted" - The attendee has accepted the invitation.  Warning: If you add an event using the values declined, tentative, or accepted, attendees with the "Add invitations to my calendar" setting set to "When I respond to invitation in email" won't see an event on their calendar unless they choose to change their invitation response in the event invitation email
    string responseStatus?;
    # The attendee's email address, if available. This field must be present when adding an attendee. It must be a valid email address as per RFC5322.
    # Required when adding an attendee
    string email?;
};

# Defines and manages individual calendars
public type Calendar record {
    # Specify the types of conference solutions supported for a calendar
    ConferenceProperties conferenceProperties?;
    # Title of the calendar
    string summary?;
    # Type of the resource ("calendar#calendar")
    string kind = "calendar#calendar";
    # Description of the calendar. Optional
    string description?;
    # The time zone of the calendar. (Formatted as an IANA Time Zone Database name, e.g. "Europe/Zurich".) Optional
    string timeZone?;
    # ETag of the resource
    string etag?;
    # Geographic location of the calendar as free-form text. Optional
    string location?;
    # Identifier of the calendar. To retrieve IDs call the calendarList.list() method
    string id?;
};

# Represents detailed information about errors encountered in operations
public type Error record {
    # Specific reason for the error. Some of the possible values are:  
    # - "groupTooBig" - The group of users requested is too large for a single query. 
    # - "tooManyCalendarsRequested" - The number of calendars requested is too large for a single query. 
    # - "notFound" - The requested resource was not found. 
    # - "internalError" - The API service has encountered an internal error.  Additional error types may be added in the future, so clients should gracefully handle additional error statuses not included in this list
    string reason?;
    # Domain, or broad category, of the error
    string domain?;
};

# Manages access control and permissions for calendars and events
public type Acl record {
    # Type of the collection ("calendar#acl")
    string kind = "calendar#acl";
    # Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided
    string nextPageToken?;
    # Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided
    string nextSyncToken?;
    # ETag of the collection
    string etag?;
    # List of rules on the access control list
    AclRule[] items?;
};

# Provides information about free/busy schedules for a group of calendars
public type FreeBusyGroup record {
    # List of calendars' identifiers within a group
    string[] calendars?;
    # Optional error(s) (if computation for the group failed)
    Error[] errors?;
};

# Manages notification preferences of the calendars
public type CalendarNotification record {
    # The method used to deliver the notification. The possible value is:  
    # - "email" - Notifications are sent via email.  
    # Required when adding a notification
    string method?;
    # The type of notification. Possible values are:  
    # - "eventCreation" - Notification sent when a new event is put on the calendar. 
    # - "eventChange" - Notification sent when an event is changed. 
    # - "eventCancellation" - Notification sent when an event is cancelled. 
    # - "eventResponse" - Notification sent when an attendee responds to the event invitation. 
    # - "agenda" - An agenda with the events of the day (sent out in the morning).  
    # Required when adding a notification
    string 'type?;
};

# The creator of the event. Read-only
public type EventCreator record {
    # The creator's name, if available
    string displayName?;
    # Whether the creator corresponds to the calendar on which this copy of the event appears. Read-only. The default is False
    boolean self = false;
    # The creator's Profile ID, if available
    string id?;
    # The creator's email address, if available
    string email?;
};

# Contains parameters for a request to retrieve free/busy information for a set of calendars and groups
public type FreeBusyRequest record {
    # The end of the interval for the query formatted as per RFC3339
    string timeMax?;
    # Time zone used in the response. Optional. The default is UTC
    string timeZone = "UTC";
    # Maximal number of calendars for which FreeBusy information is to be provided. Optional. Maximum value is 50
    int:Signed32 calendarExpansionMax?;
    # Maximal number of calendar identifiers to be provided for a single group. Optional. An error is returned for a group with more members than this value. Maximum value is 100
    int:Signed32 groupExpansionMax?;
    # The start of the interval for the query formatted as per RFC3339
    string timeMin?;
    # List of calendars and/or groups to query
    FreeBusyRequestItem[] items?;
};

# Represents the Queries record for the operation: calendar.events.patch
public type CalendarEventsPatchQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Guests who should receive notifications about the event update (for example, title changes, etc.)
    "all"|"externalOnly"|"none" sendUpdates?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # Whether API client performing operation supports event attachments. Optional. The default is False
    boolean supportsAttachments?;
    # Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0
    @constraint:Int {minValue: 0, maxValue: 1}
    int conferenceDataVersion?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
    # The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional
    @constraint:Int {minValue: 1}
    int maxAttendees?;
};

# Contains information about an attachment associated with an event
public type EventAttachment record {
    # URL link to the attachment's icon. This field can only be modified for custom third-party attachments
    string iconLink?;
    # URL link to the attachment.
    # For adding Google Drive file attachments use the same format as in alternateLink property of the Files resource in the Drive API.
    # Required when adding an attachment
    string fileUrl?;
    # Internet media type (MIME type) of the attachment
    string mimeType?;
    # Attachment title
    string title?;
    # ID of the attached file. Read-only.
    # For Google Drive files, this is the ID of the corresponding Files resource entry in the Drive API
    string fileId?;
};

# Represents the key information for a conference solution
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

# This type is used for adding parameters that control the behavior of a conference
public type ConferenceParametersAddOnParameters record {
    record {|string...;|} parameters?;
};

# The extent to which calendar access is granted by this ACL rule
public type AclRuleScope record {
    # The type of the scope. Possible values are:  
    # - "default" - The public scope. This is the default value. 
    # - "user" - Limits the scope to a single user. 
    # - "group" - Limits the scope to a group. 
    # - "domain" - Limits the scope to a domain.  Note: The permissions granted to the "default", or public, scope apply to any user, authenticated or not
    string 'type?;
    # The email address of a user or group, or the name of a domain, depending on the scope type. Omitted for type "default"
    string value?;
};

# Represents parameters related to conference settings for events
public type ConferenceParameters record {
    # This type is used for adding parameters that control the behavior of a conference
    ConferenceParametersAddOnParameters addOnParameters?;
};

# Represents an event in Google Calendar
public type Event record {
    # Information about the event's reminders for the authenticated user
    EventReminders reminders?;
    # File attachments for the event.
    # In order to modify attachments the supportsAttachments request parameter should be set to true.
    # There can be at most 25 attachments per event,
    EventAttachment[] attachments?;
    # Conveys information about the working location of a user during an event
    EventWorkingLocationProperties workingLocationProperties?;
    # The color of the event. This is an ID referring to an entry in the event section of the colors definition (see the  colors endpoint). Optional
    string colorId?;
    # An absolute link to the Google Hangout associated with this event. Read-only
    string hangoutLink?;
    # Whether attendees may have been omitted from the event's representation. When retrieving an event, this may be due to a restriction specified by the maxAttendee query parameter. When updating an event, this can be used to only update the participant's response. Optional. The default is False
    boolean attendeesOmitted = false;
    # Description of the event. Can contain HTML. Optional
    string description?;
    # Source from which the event was created. For example, a web page, an email message or any document identifiable by an URL with HTTP or HTTPS scheme. Can only be seen or modified by the creator of the event
    EventSource 'source?;
    # Extended properties of the event
    EventExtendedProperties extendedProperties?;
    # Whether attendees other than the organizer can modify the event. Optional. The default is False
    boolean guestsCanModify = false;
    # For an instance of a recurring event, this is the id of the recurring event to which this instance belongs. Immutable
    string recurringEventId?;
    # Whether the end time is actually unspecified. An end time is still provided for compatibility reasons, even if this attribute is set to True. The default is False
    boolean endTimeUnspecified = false;
    # Whether attendees other than the organizer can see who the event's attendees are. Optional. The default is True
    boolean guestsCanSeeOtherGuests = true;
    # Defines the date, time, and time zone information for events
    EventDateTime end?;
    # Opaque identifier of the event. When creating new single or recurring events, you can specify their IDs. Provided IDs must follow these rules:  
    # - characters allowed in the ID are those used in base32hex encoding, i.e. lowercase letters a-v and digits 0-9, see section 3.1.2 in RFC2938 
    # - the length of the ID must be between 5 and 1024 characters 
    # - the ID must be unique per calendar  Due to the globally distributed nature of the system, we cannot guarantee that ID collisions will be detected at event creation time. To minimize the risk of collisions we recommend using an established UUID algorithm such as one described in RFC4122.
    # If you do not specify an ID, it will be automatically generated by the server.
    # Note that the icalUID and the id are not identical and only one of them should be supplied at event creation time. One difference in their semantics is that in recurring events, all occurrences of one event have different ids while they all share the same icalUIDs
    string id?;
    # Whether this is a locked event copy where no changes can be made to the main event fields "summary", "description", "location", "start", "end" or "recurrence". The default is False. Read-Only
    boolean locked = false;
    # Whether anyone can invite themselves to the event (deprecated). Optional. The default is False
    boolean anyoneCanAddSelf = false;
    # Title of the event
    string summary?;
    # The creator of the event. Read-only
    EventCreator creator?;
    # If set to True, Event propagation is disabled. Note that it is not the same thing as Private event properties. Optional. Immutable. The default is False
    boolean privateCopy = false;
    # Visibility of the event. Optional. Possible values are:  
    # - "default" - Uses the default visibility for events on the calendar. This is the default value. 
    # - "public" - The event is public and event details are visible to all readers of the calendar. 
    # - "private" - The event is private and only event attendees may view event details. 
    # - "confidential" - The event is private. This value is provided for compatibility reasons
    string visibility = "default";
    # The attendees of the event. See the Events with attendees guide for more information on scheduling events with other calendar users. Service accounts need to use domain-wide delegation of authority to populate the attendee list
    EventAttendee[] attendees?;
    # Creation time of the event (as a RFC3339 timestamp). Read-only
    string created?;
    # An absolute link to this event in the Google Calendar Web UI. Read-only
    string htmlLink?;
    # Type of the resource ("calendar#event")
    string kind = "calendar#event";
    # Event unique identifier as defined in RFC5545. It is used to uniquely identify events accross calendaring systems and must be supplied when importing events via the import method.
    # Note that the iCalUID and the id are not identical and only one of them should be supplied at event creation time. One difference in their semantics is that in recurring events, all occurrences of one event have different ids while they all share the same iCalUIDs. To retrieve an event using its iCalUID, call the events.list method using the iCalUID parameter. To retrieve an event using its id, call the events.get method
    string iCalUID?;
    # Defines the date, time, and time zone information for events
    EventDateTime 'start?;
    # Defines the date, time, and time zone information for events
    EventDateTime originalStartTime?;
    # Specific type of the event. This cannot be modified after the event is created. Possible values are:  
    # - "default" - A regular event or not further specified. 
    # - "outOfOffice" - An out-of-office event. 
    # - "focusTime" - A focus-time event. 
    # - "workingLocation" - A working location event.  Currently, only "default " and "workingLocation" events can be created using the API. Extended support for other event types will be made available in later releases
    string eventType = "default";
    # List of RRULE, EXRULE, RDATE and EXDATE lines for a recurring event, as specified in RFC5545. Note that DTSTART and DTEND lines are not allowed in this field; event start and end times are specified in the start and end fields. This field is omitted for single events or instances of recurring events
    string[] recurrence?;
    # Sequence number as per iCalendar
    int:Signed32 sequence?;
    # The organizer of the event. If the organizer is also an attendee, this is indicated with a separate entry in attendees with the organizer field set to True. To change the organizer, use the move operation. Read-only, except when importing an event
    EventOrganizer organizer?;
    # Whether the event blocks time on the calendar. Optional. Possible values are:  
    # - "opaque" - Default value. The event does block time on the calendar. This is equivalent to setting Show me as to Busy in the Calendar UI. 
    # - "transparent" - The event does not block time on the calendar. This is equivalent to setting Show me as to Available in the Calendar UI
    string transparency = "opaque";
    # Represents information about conferences associated with calendar events
    ConferenceData conferenceData?;
    # ETag of the resource
    string etag?;
    # Geographic location of the event as free-form text. Optional
    string location?;
    # Whether attendees other than the organizer can invite others to the event. Optional. The default is True
    boolean guestsCanInviteOthers = true;
    # Last modification time of the event (as a RFC3339 timestamp). Read-only
    string updated?;
    # Status of the event. Optional. Possible values are:  
    # - "confirmed" - The event is confirmed. This is the default status. 
    # - "tentative" - The event is tentatively confirmed. 
    # - "cancelled" - The event is cancelled (deleted). The list method returns cancelled events only on incremental sync (when syncToken or updatedMin are specified) or if the showDeleted flag is set to true. The get method always returns them.
    # A cancelled status represents two different states depending on the event type:  
    # - Cancelled exceptions of an uncancelled recurring event indicate that this instance should no longer be presented to the user. Clients should store these events for the lifetime of the parent recurring event.
    # Cancelled exceptions are only guaranteed to have values for the id, recurringEventId and originalStartTime fields populated. The other fields might be empty.  
    # - All other cancelled events represent deleted events. Clients should remove their locally synced copies. Such cancelled events will eventually disappear, so do not rely on them being available indefinitely.
    # Deleted events are only guaranteed to have the id field populated.   On the organizer's calendar, cancelled events continue to expose event details (summary, location, etc.) so that they can be restored (undeleted). Similarly, the events to which the user was invited and that they manually removed continue to provide details. However, incremental sync requests with showDeleted set to false will not return these details.
    # If an event changes its organizer (for example via the move operation) and the original organizer is not on the attendee list, it will leave behind a cancelled event where only the id field is guaranteed to be populated
    string status?;
};

# Defines access control rules for a calendar
public type AclRule record {
    # The role assigned to the scope. Possible values are:  
    # - "none" - Provides no access. 
    # - "freeBusyReader" - Provides read access to free/busy information. 
    # - "reader" - Provides read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
    # - "writer" - Provides read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
    # - "owner" - Provides ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs
    string role?;
    # Type of the resource ("calendar#aclRule")
    string kind = "calendar#aclRule";
    # The extent to which calendar access is granted by this ACL rule
    AclRuleScope scope?;
    # ETag of the resource
    string etag?;
    # Identifier of the Access Control List (ACL) rule. See Sharing calendars
    string id?;
};

# Represents the Queries record for the operation: calendar.calendarList.insert
public type CalendarCalendarListInsertQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False
    boolean colorRgbFormat?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};

# Represents the Queries record for the operation: calendar.calendarList.get
public type CalendarCalendarListGetQueries record {
    # An opaque string that represents a user for quota purposes. Must not exceed 40 characters
    string quotaUser?;
    # Returns response with indentations and line breaks
    boolean prettyPrint?;
    # OAuth 2.0 token for the current user
    @http:Query {name: "oauth_token"}
    string oauthToken?;
    # Data format for the response
    "json" alt?;
    # Selector specifying which fields to include in a partial response
    string fields?;
    # API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token
    string 'key?;
};
