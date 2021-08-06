## Overview
The Google Calendar Connector listener provides you to capture the events created, updated and deleted in the calendar.

This module supports [Google Calendar API V3](https://developers.google.com/calendar/api).

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
1. Create a [Google account](https://accounts.google.com/signup/v2/webcreateaccount?.utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp)
2. [Register the callback URL domain.](https://developers.google.com/calendar/api/guides/push#registering-your-domain)
3. Obtain tokens - Follow the steps [here](https://developers.google.com/identity/protocols/oauth2) to obtain tokens.

## Quickstart
To use the Google Calendar listener connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import connector
Import the `ballerinax/googleapis.calendar` and `ballerinax/googleapis.calendar.'listener` modules into the Ballerina project.

```ballerina
import ballerinax/googleapis.calendar;
import ballerinax/googleapis.calendar.'listener as listen;
```

### Step 2: Create a new listener instance
Create a `calendar:CalendarConfiguration` with the OAuth2.0 tokens obtained and initialize the connector with it.

```ballerina
int port = 4567;
string calendarId = "primary";
string address = "<call_back url + "/calendar/events">";

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,   
    }
};

listener listen:Listener googleListener = new (port, config, calendarId, address);
```

### Step 3: Define Ballerina service with the listener
1. Now you can use the operations available within the connector. Note that they are in the form of remote operations.
Following is an example on how to create a listener for new event occurred in the calendar using the connector.
    ```ballerina
    service /calendar on googleListener {
        remote function onNewEvent(calendar:Event event) returns error? {
          //
        }
    }
    ```
2. Use `bal run` command to compile and run the Ballerina program.
 
**[You can find a list of samples here](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/master/samples)**
