## Overview
The module provides the capability to manage events and calendar operations and supports service account authorization that can provide delegated domain-wide access to GSuite domain and support admin to do operations on behalf of the domain users.

This module supports [Google Calendar API](https://developers.google.com/calendar/api) version V3.
 
## Prerequisites
Before using this connector in your Ballerina application, complete the following:
- Create [Google account](https://accounts.google.com/signup/v2/webcreateaccount?utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp)
- Obtain tokens - Follow [this link](https://developers.google.com/identity/protocols/oauth2)

## Quickstart
To use the Google Calendar connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import connector
First, import the `ballerinax/googleapis.calendar` module into the Ballerina project.
```ballerina
import ballerinax/googleapis.calendar;
```

### Step 2: Create a new connector instance
Create a `calendar:CalendarConfiguration` with the OAuth2 tokens obtained, and initialize the connector with it.
```ballerina
calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,
    }
};

calendar:Client calendarClient = check new(config);
```

### Step 3: Invoke  connector operation
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

## Quick reference
Code snippets of some frequently used functions: 

- Create event
    ```ballerina
    string calendarId = "primary";
    calendar:InputEvent event = {
            'start: {
                dateTime:  "2021-02-28T09:00:00+0530"
            },
            end: {
                dateTime:  "2021-02-28T09:30:00+0530"
            },
            summary: "Sample Event"
        };

    public function main() returns error? {
        calendar:Event response = check calendarClient->createEvent(calendarId, event);
    }
    ``` 

- Create a quick event using service account
    ```ballerina
    import ballerinax/googleapis.calendar;

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            issuer: <issuer>,
            audience: <audience>,
            customClaims: {"scope": <scope>},
            signatureConfig: {
                config: {
                    keyStore: {
                        path: <path>,
                        password: <password>
                    },
                    keyAlias: <keyAlias>,
                    keyPassword: <keyPassword>
                }}
        }
    };

    calendar:Client calendarClient = check new(config);

    string calendarId = <calendarId>;
    string title = "Sample Event";
    string userAccount = <userEmail>;

    public function main() returns error? {
        calendar:Event response = check calendarClient->quickAddEvent(calendarId, title, userAccount = userAccount);
    }
    ```

**[You can find a list of samples here](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/master/samples)**
