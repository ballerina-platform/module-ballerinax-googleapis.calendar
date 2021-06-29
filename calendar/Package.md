[![Build](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions?query=workflow%3ACI)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-googleapis.calendar.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/commits/master)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Ballerina Google Calendar Connector 
Connects to Google Calendar using Ballerina.

# Introduction
## Google Calendar
[Google Calendar](https://developers.google.com/calendar) is a time-management and scheduling calendar service developed by Google. It lets users to organize their schedule and share events with others. The Google Calendar endpoint allows you to access the Google Calendar API Version v3 through Ballerina.

## Key Features of Google Calendar
* Manage Events
* Manage Calendar
* Listen event changes - [Push Notification](https://developers.google.com/calendar/v3/push)

## Connector Overview

The Google Calendar Ballerina Connector allows users to access the Google Calendar API Version V3 through Ballerina. The connector can be used to access common use cases of Google Calendar. The connector provides the capability to programmatically manage events and calendar, CRUD operations on event and calendar operations through the connector endpoints and listener for the events occurred in the calendar. The connector supports service account authorization that can provide delegated domain-wide access to GSuite domain. So that GSuite admin can do operations for the domain users.

# Prerequisites

* Java 11 Installed
  Java Development Kit (JDK) with version 11 is required.

* Download the required Ballerina [distribution](https://ballerinalang.org/downloads/) version

* Domain used in the callback URL needs to be registered in google console as a verified domain.
https://console.cloud.google.com/apis/credentials/domainverification
(If you are running locally, provide your ngrok url as to the domain verification)
Then you will be able to download a HTML file (e.g : google2c627a893434d90e.html). 
Copy the content of that HTML file & provide that as a config (`domainVerificationFileContent`) to Listener initialization.

* In case if you failed to verify or setup, Please refer the documentation for domain verification process 
https://docs.google.com/document/d/119jTQ1kpgg0hpNl1kycfgnGUIsm0LVGxAvhrd5T4YIA/edit?usp=sharing

## Compatibility

|                             |            Versions             |
|:---------------------------:|:-------------------------------:|
| Ballerina Language          |     Swan Lake Alpha5            |
| Google Calendar API         |             V3                  |
| Java Development Kit (JDK)  |             11                  |

### Obtaining Tokens

1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. [Enable Calendar API in your app's Cloud Platform project.](https://developers.google.com/workspace/guides/create-project#enable-api)
7. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground).
8. Click the gear icon in the upper right corner and check the box labeled **Use your own OAuth credentials** (if it isn't already checked) and enter the OAuth2 client ID and OAuth2 client secret you obtained above.
9. Select required Google Calendar scopes, and then click **Authorize APIs**.
10. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token. 

#### Service account

1. User needs p12 format private key to access connector by using service account. Refer the following link to create p12 key.
https://developers.google.com/identity/protocols/oauth2/service-account#creatinganaccount


2. Refer following link to delegate domain-wide authority to the service account.
https://developers.google.com/identity/protocols/oauth2/service-account#delegatingauthority


### Add configurations file

* Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has support for bearer token config, OAuth 2.0 refresh token grant config and jwt issuer config. 

    * Bearer Token - The Google Calendar connector can be minimally instantiated in the HTTP client config using the OAuth 2.0 access token as bearer token. As access token has defined time limit, client operations can be accessed for a certain time period.  
    ``` 
    calendar:CalendarConfiguration config = {
        oauth2Config: {
            token: <access token>
        }
    }
    ```

    * OAuth2 Refresh Token - The Google Calendar connector can also be instantiated in the HTTP client config with the refresh token using the client ID, client secret, and refresh token. In this authorization client can function until refresh token stop working.
    * Client ID
    * Client Secret
    * Refresh Token
    * Refresh URL
    ```
    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: <clientId>,
            clientSecret: <clientSecret>,
            refreshToken: <refreshToken>,
            refreshUrl: <refreshUrl>
        }
    }
    ```

    * Service account - This authorization method is used to authorize Google application. Here operation are called to Google server on behalf on Google application.
     ```
    calendar:CalendarConfiguration config = {
        oauth2Config: {
            issuer: <issuer>,
            audience: <aud>,
            customClaims: {"scope": <scope>},
            signatureConfig: {
                config: {
                    keyStore: {
                        path: <path>,
                        password: <password>
                    },
                    keyAlias: <keyAlias>,
                    keyPassword: <keyPassword>
                }
            }
        }
    }
    ```
    * issuer - The email address of the service account.
    * audience - A descriptor of the intended target of the assertion. When making an access token request this value is always https://oauth2.googleapis.com/token.
    * scope - A space-delimited list of the permissions that the application requests.
    * path, password, keyAlias, keyPassword - The values of key file configurations.


* Callback address and domain verification file content are additionally required in order to use Google Calendar listener. It is the path of the listener resource function. The time-to-live in seconds for the notification channel is provided in optional parameter expiration time. By default it is 604800 seconds.
  * Callback address
  * Domain verification file content
  * Expiration time

* Add the project configuration file by creating a `Config.toml` file under the root path of the project structure.
This file should have following configurations. Add the tokens obtained in the previous step to the `Config.toml` file.

  ```
  clientId = "<client_id">
  clientSecret = "<client_secret>"
  refreshToken = "<refresh_token>"
  refreshUrl = "<refresh_URL>"
  callbackUrl = "<call_back url>"
  domainVerificationFileContent = "<domain_verification_file_content>"
  ```

# Quickstart(s)

## Create an quick add event
### Step 1: Import the Calendar module
First, import the `ballerinax/googleapis.calendar` module into the Ballerina project.
```ballerina
import ballerinax/googleapis.calendar;
```

### Step 2: Initialize the Calendar Client giving necessary credentials
You can now enter the credentials in the Calendar client config.
```ballerina
calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,
    }
};

calendar:Client calendarClient = check new (config);
```
Note: Must specify the **Refresh token** (obtained by exchanging the authorization code), **Refresh URL**, the **Client ID** and the **Client secret** obtained in the app creation, when configuring the Calendar connector client.


### Step 3: Set up all the data required to create the quick event
The `quickAddEvent` remote function creates an event. The `calendarId` represents the calendar where the event has to be created and `title` refers the name of the event.

```ballerina
string calendarId = "primary";
string title = "Sample Event";
```

### Step 4: Create the quick add event
The response from `quickAddEvent` is either an Event record or an `error` (if creating the event was unsuccessful).

```ballerina
//Create new quick add event.
calendar:Event|error response = calendarClient->quickAddEvent(calendarId, title);

if (response is calendar:Event) {
    // If successful, log event id
    log:printInfo(response.id);
} else {
    // If unsuccessful
    log:printError("Error: " + response.toString());
}
```

## Follow following steps to create an quick event by using service account authorization
### Step 1: Import the Calendar module
First, import the `ballerinax/googleapis.calendar` module into the Ballerina project.
```ballerina
import ballerinax/googleapis.calendar;
```

### Step 2: Initialize the Calendar Client giving necessary credentials
You can now enter the credentials in the Calendar client config.
```ballerina
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

calendar:Client calendarClient = check new (config);
```

### Step 3: Set up all the data required to create the quick event
The `quickAddEvent` remote function creates an event. The `calendarId` represents the calendar where the event has to be created, `title` refers the name of the event and userAccount represents email address of the user for which the application is requesting delegated access.

```ballerina
string calendarId = <calendarId>;
string title = "Sample Event";
string userAccount = <userEmail>;
```

### Step 4: Create the quick add event
The response from `quickAddEvent` is either an Event record or an `error` (if creating the event was unsuccessful).

```ballerina
//Create new quick add event.
calendar:Event|error response = calendarClient->quickAddEvent(calendarId, title, userAccount = userAccount);

if (response is calendar:Event) {
    // If successful, log event id
    log:printInfo(response.id);
} else {
    // If unsuccessful
    log:printError("Error: " + response.toString());
}
```

## Create an listener for new event creation
### Step 1: Import the Calendar module
First, import the `ballerinax/googleapis.calendar` and `import ballerinax/googleapis.calendar.'listener as listen` modules into a Ballerina project.

```ballerina
import ballerinax/googleapis.calendar;
import ballerinax/googleapis.calendar.'listener as listen;
```

### Step 2: Initialize the Calendar Client giving necessary credentials
You can now enter the credentials in the Calendar client config.
```ballerina
listen:ListenerConfiguration listenerConfig = {
    port: "<PORT>",
    clientConfiguration: {oauth2Config: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>,
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>
    }},
    calendarId: "primary",
    callbackUrl: "<CALLBACK_URL>",
    domainVerificationFileContent: "<DOMAIN_VERIFICATION_FILE_CONTENT>"
};
```

### Step 3: Create the listener service
If there is an event created in calendar, log will print the event.

```ballerina
service / on googleListener {
    remote function onNewEvent(calendar:Event event) returns error? {
        log:printInfo("Created new event : " + event.toString());
    }
}
```

# **Samples**

Samples are available at : https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/samples

- #### [Get all calendars](samples/get_calendars.bal)

    This sample shows how to get all calendars that are available in an authorized user's account. This operation returns stream `Calendar` if successful. Else returns `error`.

- #### [Create calendar](samples/create_calendar.bal)

    This sample shows how to create a new calendar in an authorized user's account. The name of the new calendar is required to do this. This operation will return a `CalenderResource` if successful. Else return an `error`.

- #### [Delete calendar](samples/delete_calendar.bal)

    This sample shows how to delete a calendar in an authorized user's account. The calendar id is required to do this operation. This operation returns an error `true` if unsuccessful.

- #### [Create event](samples/create_event.bal)

    This sample shows how to create an event in an authorized user's calendar. The calendar id and input event are required to do this operation. This operation returns an `Event` if successful. Else returns `error`.

- #### [Create quick add event](samples/quick_add_event.bal)

    This sample shows how to create a quick add event in an authorized user's calendar. It creates an event based on a simple text string. The calendar id and event title are required to do this operation. This operation returns an `Event` if successful. Else returns `error`.

- #### [Get event](samples/get_event.bal)

    This sample shows how to get an event that is available in an authorized user's calendar. The calendar and event ids are required to do this operation. This operation returns an `Event` if successful. Else returns `error`.

- #### [Get events](samples/get_events.bal)

    This sample shows how to get events that are available in an authorized user's calendar. The calendar id is required to do this operation. Additionally, user can filter the events using optional parameter `EventFilterCriteria`. The filter helps user to get the events between a time period, events with a certain word, events updated after a time and etc. This operation returns stream `Event` if successful. Else returns `error`.

- #### [Update event](samples/update_event.bal)

    This sample shows how to update an existing event that is available in an authorized user's calendar. The calendar and event ids are required to do this operation. This operation returns an `Event` if successful. Else returns `error`.

- #### [Delete event](samples/delete_event.bal)

    This sample shows how to delete an event in an authorized user's calendar. The calendar and event ids are required to do this operation. This operation returns an error `true` if unsuccessful.

- #### [Watch event changes](samples/watch_event.bal)

    This sample shows how to watch for changes to events in an authorized user's calendar. It is a subscription to receive push notification from Google on events changes.  The calendar id and callback url are required to do this operation. Channel live time can be provided via an optional parameter. By default it is 604800 seconds. This operation returns  `WatchResponse` if successful. Else returns `error`.

- #### [Stop channel](samples/stop_channel.bal)

    This sample shows how to stop an existing subscription. The channel id and resource is are required to do this operation. This operation returns an error `true` if unsuccessful.

## Listener

- #### [Trigger for new event](samples/trigger_create_event.bal)

    This sample shows how to create a trigger on new event. When a new event is occurred, that event details can be captured in this listener.

- #### [Trigger for updated event](samples/trigger_update_event.bal)

    This sample shows how to create a trigger on an event update. When a new event is updated, that event details can be captured in this listener.

- #### [Trigger for deleted event](samples/trigger_delete_event.bal)

    This sample shows how to create a trigger on cancelled event. When a new event is cancelled, that event details can be captured in this listener.