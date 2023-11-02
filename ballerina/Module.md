## Overview
The Google Calendar Connector provides the capability to manage events and calendar operations. It also provides the capability to support service account authorization that can provide delegated domain-wide access to the GSuite domain and support admins to do operations on behalf of the domain users.

This module supports [Google Calendar API V3](https://developers.google.com/calendar/api).
 
## Prerequisites
Before using this connector in your Ballerina application, complete the following:
1. Create a [Google account](https://accounts.google.com/signup/v2/webcreateaccount?utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp).
2. Obtain tokens - Follow the steps [here](https://developers.google.com/identity/protocols/oauth2) to obtain tokens.

## Quickstart
To use the Google Calendar connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import connector
Import the `ballerinax/googleapis.calendar` module into the Ballerina project.
```ballerina
import ballerinax/googleapis.calendar;
```

### Step 2: Create a new connector instance
Create a `calendar:ConnectionConfig` with the OAuth2.0 tokens obtained and initialize the connector with it.

```ballerina
calendar:ConnectionConfig config = {
    auth: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,
    }
};

calendar:Client calendarClient = check new(config);
```

### Step 3: Invoke connector operation
1. Now you can use the operations available within the connector. Note that they are in the form of remote operations.  
Following is an example on how to create quick event using the connector.

```ballerina
string calendarId = "primary";
string title = "Sample Event";

public function main() returns error? {
    calendar:Event response = check calendarClient->quickAddEvent(calendarId, title);
}
``` 
2. Use `bal run` command to compile and run the Ballerina program.

**[You can find a list of examples here](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/master/examples)**
