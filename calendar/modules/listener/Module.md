## Overview
This module provides you a notification for the events created, updated and deleted in the calendar.

This module supports [Google Calendar API](https://developers.google.com/calendar/api) version V3.

## Prerequisites
Before using this connector in your Ballerina application, complete the following:
- Create[Google account](https://accounts.google.com/signup/v2/webcreateaccount?utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp)
- [Domain registered callback URL](https://developers.google.com/calendar/api/guides/push#registering-your-domain)
- Obtain tokens - Follow [this link](https://developers.google.com/identity/protocols/oauth2)

## Quickstart
To use the Google Calendar listener connector in your Ballerina application, update the .bal file as follows:

### Step 1: Import connector
First, import the `ballerinax/googleapis.calendar` and `ballerinax/googleapis.calendar.'listener as listen` modules into the Ballerina project.

```ballerina
import ballerinax/googleapis.calendar;
import ballerinax/googleapis.calendar.'listener as listen;
```

### Step 2: Create a new connector instance
Create a `calendar:CalendarConfiguration` with the OAuth2 tokens obtained, and initialize the connector with it.

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

### Step 3: Invoke connector operation
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

## Quick reference
Code snippets of some frequently used functions: 

- On event update
  ```ballerina
  remote function onEventUpdate(calendar:Event event) returns error? {
    //
  }
  ```

- On event delete
  ```ballerina
  remote function onEventDelete(calendar:Event event) returns error? {
    //
  }
  ```
 
**[You can find a list of samples here](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/master/samples)**
