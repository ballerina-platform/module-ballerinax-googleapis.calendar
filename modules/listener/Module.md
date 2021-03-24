## Listener Overview

The Google Calendar Ballerina Connector listener allows you to get notification for the created, updated and deleted events in the calendar.

# Prerequisites

* Java Development Kit (JDK) with version 11 is required.

*   Ballerina Swan Lake Alpha Version 2 is required.
Download the Ballerina [distribution](https://ballerinalang.org/downloads/) SLAlpha2

## Compatibility

|                             |            Versions             |
|:---------------------------:|:-------------------------------:|
| Ballerina Language          |     Swan Lake Alpha2            |
| Google Calendar API         |             V3                  |


### Obtaining tokens to run the samples

1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Calendar scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token. 

### Add configurations file

* Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for OAuth 2.0. Google Calendar uses OAuth 2.0 to authenticate and authorize requests. 
  * The Google Calendar connector can be minimally instantiated in the HTTP client config using the  the client ID, client secret, refresh token and refresh URL.
    * Access Token
    * Client ID
    * Client Secret
    * Refresh Token
    * Refresh URL
    * Calendar ID
  * Callback address is additionally required in order to use Google Calendar listener. It is the path of the listener resource function. The time-to-live in seconds for the notification channel is provided in optional parameter expiration time. By default it is 604800 seconds.
    * Callback address
    * Expiration time

Add the configuration file by creating a `Config.toml` file under the root path of the project structure.
This file should have following configurations. Add the tokens obtained in the previous step to the `Config.toml` file.

```
port = "<port>"
clientId = "<client_id">
clientSecret = "<client_secret>"
refreshToken = "<refresh_token>"
refreshUrl = "<refresh_URL>"
calendarId = "<calendar_id>"
address = "<address>"
```


# Samples

Samples are available at : https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/samples. To run a sample, create a new TOML file with name `Config.toml` in the same directory as the `.bal` file with above-mentioned configurable values.

### Watch event changes

This sample shows how to watch for changes to events in an authorized user's calendar. It is a subscription to receive push notification from Google on events changes.  The calendar id and callback url are required to do this operation. Channel live time can be provided via an optional parameter. By default it is 604800 seconds. This operation returns  `WatchResponse` if successful. Else returns `error`. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;

public function main() returns error? {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = check new (config);

    calendar:WatchResponse|error res = calendarClient->watchEvents(calendarId, address);
    if (res is calendar:WatchResponse) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}
```

### Stop a channel subscription

This sample shows how to stop an existing subscription. The channel id and resource is are required to do this operation. This operation returns an error `true` if unsuccessful. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string testChannelId = ?;
configurable string testResourceId = ?;

public function main() returns error? {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = check new (config);

    error? res = calendarClient->stopChannel(testChannelId, testResourceId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:printInfo("Channel is terminated");
    }
}
```

## Listener

### Trigger for new event

This sample shows how to create a trigger on new event. When a new event is occurred, that event details can be captured in this listener.

```ballerina
import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable int port = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;
configurable string expiration = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = check new (config);
listener listen:Listener googleListener = new (port, calendarClient, calendarId, address, expiration);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request) returns error? {
        listen:EventInfo payload = check googleListener.getEventType(caller, request);
        if (payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:CREATED) {
                var event = payload?.event;
                string? summary = event?.summary;
                if (summary is string) {
                    log:printInfo(summary);
                } 
            }
        }
    }
}
```

### Trigger for updated event

This sample shows how to create a trigger on an event update. When a new event is occurred, that event details can be captured in this listener.

```ballerina
import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable int port = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;
configurable string expiration = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = check new (config);
listener listen:Listener googleListener = new (port, calendarClient, calendarId, address, expiration);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request) returns error? {
        listen:EventInfo payload = check googleListener.getEventType(caller, request);
        if (payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:UPDATED) {
                var event = payload?.event;
                string? summary = event?.summary;
                if (summary is string) {
                    log:printInfo(summary);
                } 
            }
        }
    }
}
```

### Trigger for deleted event

This sample shows how to create a trigger on delete event. When a new event is occurred, that event details can be captured in this listener.

```ballerina
import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable int port = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;
configurable string expiration = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = check new (config);
listener listen:Listener googleListener = new (port, calendarClient, calendarId, address, expiration);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request) returns error? {
        listen:EventInfo payload = check googleListener.getEventType(caller, request);
        if (payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:DELETED) {
                log:printInfo("Event deleted");
            }
        }
    }
}
```
