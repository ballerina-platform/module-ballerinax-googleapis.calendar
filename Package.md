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

The Google Calendar Ballerina Connector allows you to access the Google Calendar API Version V3 through Ballerina. The connector can be used to implement some of the most common use cases of Google Calendar. The connector provides the capability to programmatically manage events and calendar, CRUD operations on event and calendar operations through the connector endpoints and listener for the events created in the calendar.

# Prerequisites

* Java 11 Installed
  Java Development Kit (JDK) with version 11 is required.

* Download the Ballerina [distribution](https://ballerinalang.org/downloads/) SLAlpha2
  Ballerina Swan Lake Alpha Version 2 is required.

* Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for BasicAuth and OAuth 2.0. Google Calendar uses OAuth 2.0 to authenticate and authorize requests. 
  * The Google Calendar connector can be minimally instantiated in the HTTP client config using the access token or the client ID, client secret, and refresh token.
    * Access Token
    * Client ID
    * Client Secret
    * Refresh Token
    * Refresh URL
    * Calendar ID
  * In order to use listener address, resource id and channel id are additionally required. Address URL is url path of the listener. Channel id and resource id will be provided when channel is registered using watch operation.
    * Address URL
    * Resource ID
    * Channel ID

## Compatibility

|                             |            Versions             |
|:---------------------------:|:-------------------------------:|
| Ballerina Language          |     Swan Lake Alpha2            |
| Google Calendar API         |             V3                  |


Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for OAuth 2.0. Google Calendar uses OAuth 2.0 to authenticate and authorize requests. The Google Calendar connector can be minimally instantiated in the HTTP client config using the access token or the client ID, client secret, and refresh token.

**Obtaining Tokens to Run the Sample**

1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Calendar scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token. 

**Add project configurations file**

Add the project configuration file by creating a `Config.toml` file under the root path of the project structure.
This file should have following configurations. Add the tokens obtained in the previous step to the `Config.toml` file.

#### For client operations
```
[ballerinax.googleapis_calendar]
accessToken = "<access_token>"
clientId = "<client_id">
clientSecret = "<client_secret>"
refreshToken = "<refresh_token>"
refreshUrl = "<refresh_URL>"

calendarId = "<calendar_id>"
addressUrl = "<address_url>"
```

#### For listener operations
```
[ballerinax.googleapis_calendar]
accessToken = "<access_token>"
clientId = "<client_id">
clientSecret = "<client_secret>"
refreshToken = "<refresh_token>"
refreshUrl = "<refresh_URL>"

calendarId = "<calendar_id>"
resourceId = "<resource_id>"
channelId = "<channel_id>"
```

# **Samples**

Samples are available at : https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/samples

### Create Calendar
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

public function main() {

    calendar:CalendarConfiguration config = {
       oauth2Config: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };
    calendar:Client calendarClient = new (config);

    CalendarResource|error res = calendarClient->createCalendar("testCalendar");
    if (res is calendar:CalendarResource) {
       log:print(res.id);
    } else {
       log:printError(res.message());
    }
}
```

### Delete Calendar
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

public function main() {

    calendar:CalendarConfiguration config = {
       oauth2Config: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };

    calendar:Client calendarClient = new (config);

    boolean|error res = calendarClient->deleteCalendar(calendarId);
    if (res is boolean) {
        log:print("Calendar is deleted");
    } else {
        log:printError(res.message());
    }
}
```

### Create Event
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

public function main() {

    calendar:CalendarConfiguration config = {
       oauth2Config: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };
    calendar:Client calendarClient = new (config);

    calendar:InputEvent event = {
       'start: {
           dateTime:  "2021-02-28T09:00:00+0530"
       },
       end: {
           dateTime:  "2021-02-28T09:00:00+0530"
       },
       summary: "Sample Event"
    };
    calendar:Event|error res = calendarClient->createEvent(calendarId, event);
    if (res is calendar:Event) {
       log:print(res.id);
    } else {
       log:printError(res.message());
    }
}
```

### Create Quick Event
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

public function main() {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = new (config);

    calendar:Event|error res = calendarClient->quickAddEvent(calendarId, "Sample Event");
    if (res is calendar:Event) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
```
### Get Event
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

public function main() {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };
    calendar:Client calendarClient = new (config);

    calendar:Event|error res = calendarClient->getEvent(calendarId, eventId);
    if (res is calendar:Event) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}`
```

### Get Events
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

public function main() returns @tainted error? {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = new (config);

    stream<calendar:Event>|error res = calendarClient->getEvents(calendarId);
    if (res is stream<calendar:Event>) {
        var eve = res.next();
        string id = check eve?.value?.id;
        log:print(id);
    } else {
        log:printError(res.message());
    }
}
```

### Update Event
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

public function main() {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = new (config);

    calendar:InputEvent event = {
        'start: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        end: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        summary: "Sample Event"
    };

    calendar:Event|error res = calendarClient->updateEvent(calendarId, eventId, event);
    if (res is calendar:Event) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
```

### Delete event
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

public function main() {

    calendar:CalendarConfiguration config = {
       oauth2Config: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };

    calendar:Client calendarClient = new (config);

    boolean|error res = calendarClient->deleteEvent(calendarId, eventId);
    if (res is boolean) {
        log:print("Event is deleted");
    } else {
        log:printError(res.message());
    }
}
```
### Get Calendars
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

public function main() returns @tainted error? {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };
    calendar:Client calendarClient = new (config);

    stream<calendar:Calendar>|error res = calendarClient->getCalendars();
    if (res is stream<calendar:Calendar>) {
        var cal = res.next();
        string id = check cal?.value?.id;
        log:print(id);
    } else {
        log:printError(res.message());
    }
}
```

### Watch Channel
```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;

public function main() {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = new (config);

    calendar:WatchConfiguration watchConfig = {
        id: "testId",
        token: "testToken",
        'type: "webhook",
        address: address,
        params: {
            ttl: "300"
        }
    };
    calendar:WatchResponse|error res = calendarClient->watchEvents(calendarId, watchConfig);
    if (res is calendar:WatchResponse) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
```

### Stop Channel
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

public function main() {

    calendar:CalendarConfiguration config = {
        oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = new (config);

    boolean|error res = calendarClient->stopChannel(testChannelId, testResourceId);
    if (res is boolean) {
        log:print("Channel is terminated");
    } else {
        log:printError(res.message());
    }
}
```

## Listener

### Create Event Trigger
```ballerina
import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string channelId = ?;
configurable string resourceId = ?;
configurable string calendarId = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = new (config);
listener listen:Listener googleListener = new (4567,calendarClient, channelId, resourceId, calendarId);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request){
        listen:EventInfo payload = checkpanic googleListener.getEventType(caller, request);
        if(payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:CREATED) {
                var event = payload?.event;
                string? summary = event?.summary;        
                if (summary is string) {
                    log:print(summary);
                } 
            }
        }      
    }
}
```

### Update Event Trigger
```ballerina
import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string channelId = ?;
configurable string resourceId = ?;
configurable string calendarId = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = new (config);
listener listen:Listener googleListener = new (4567,calendarClient, channelId, resourceId, calendarId);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request){
        listen:EventInfo payload = checkpanic googleListener.getEventType(caller, request);
        if(payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:UPDATED) {
                var event = payload?.event;
                string? summary = event?.summary;        
                if (summary is string) {
                    log:print(summary);
                } 
            }
        }      
    }
}
```

### Delete Event Trigger
```ballerina
import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string channelId = ?;
configurable string resourceId = ?;
configurable string calendarId = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = new (config);
listener listen:Listener googleListener = new (4567,calendarClient, channelId, resourceId, calendarId);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request){
        listen:EventInfo payload = checkpanic googleListener.getEventType(caller, request);
        if(payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:DELETED) {
                log:print("Event deleted");
            }
        }      
    }
}
```
