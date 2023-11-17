## Introduction

This file records the sanitation done on top of the OAS from APIs guru. Google uses Google discovery format to expose API details. APIs guru uses a conversion tool to change the discovery documentation to OAS. These sanitation's are done for improving usability and as workaround for known limitations in language side.

1. Add descriptions to undocumented parameters in `calendar:Client`
In certain APIs within the `calendar:Client`, descriptions have been added to previously undocumented `record` types and parameters, specifically the `payload` parameter.

2. Removed resource paths:

 - <b>users/me/settings</b>: This path has been removed as it did not significantly contribute to usability and was infrequently utilized.

 - <b>calendars/[string calendarId]/events/watch & channels/stop</b>: These operations will be handled through Google PubSub, enhancing maintainability.

3. Remove deprecated parameters
Deprecated parameters in the OpenAPI Specification have been removed, notably the `userIp` parameter. This parameter has been deprecated, and the updated specification recommends using the `quotaUser` parameter as a replacement for the same purpose.

### OpenAPI cli command

```bash
bal openapi -i docs/oas/openapi.yaml --mode client -o ballerina/
```
