# Sanitations for OpenAPI specification

_Authors_: @Nuvindu \
_Reviewers_: @shafreenAnfar @ThisaruGuruge \
_Created_: 2024/02/14 \
_Updated_: 2024/11/11 \
_Edition_: Swan Lake

## Introduction

The Ballerina Google Calendar connector facilitates integration with the [Google Calendar API V3](https://developers.google.com/calendar/api) by generating client code using the [OpenAPI specification](https://github.com/Nuvindu/module-ballerinax-googleapis.calendar/blob/main/docs/spec/openapi.yaml). To improve usability, several modifications have been made to the original specification:

1. **Parameter descriptions**:  
   Undocumented parameters in various resource functions now include detailed descriptions, enhancing clarity and usability.

2. **Resource path simplification**:  
   * Removed `/users/{userId}/settings` due to complex sub-paths with limited utility.
   * Excluded `/users/{userId}/watch` and `/users/{userId}/stop`, as they are covered under Google Pub/Sub.

3. **Enhanced response descriptions**:  
   Updated generic "Successful Response" labels to reflect specific return types.

4. **Deprecated parameters removal**:  
   Removed deprecated parameters from resource paths to streamline the connector.

5. **Detailed type descriptions**:  
   Added comprehensive descriptions for undocumented types.
    * Calendar, FreeBusyCalendar, ConferenceSolution, EventDateTime, EntryPoint, FreeBusyRequestItem, ConferenceData, ConferenceRequestStatus, TimePeriod, CreateConferenceRequest, Colors, ConferenceProperties, EventWorkingLocationProperties, CalendarListEntry, Events, CalendarList, ColorDefinition, EventReminder, EventAttendee, Error, Acl, FreeBusyGroup, CalendarNotification, FreeBusyRequest, EventAttachment, ConferenceSolutionKey, ConferenceParametersAddOnParameters, ConferenceParameters, Event, AclRule.

## OpenAPI cli command

```bash
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina/oas
