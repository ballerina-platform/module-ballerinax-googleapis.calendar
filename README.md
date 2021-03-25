[![Build](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions?query=workflow%3ACI)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-googleapis.calendar.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/commits/master)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Ballerina Google Calendar Connector 
Connects to Google Calendar using Ballerina.

# Introduction
## Google Calendar
[Google Calendar](https://developers.google.com/calendar) is a time-management and scheduling calendar service developed by Google. It lets users to organize their schedule and share events with others. The Google Calendar endpoint allows you to access the Google Calendar API Version v3 through Ballerina.

## Key Features of Google Calendar
* Manage events
* Manage calendars
* [Push notification for events](https://developers.google.com/calendar/v3/push)

## Connector Overview

The Google Calendar Ballerina Connector allows you to access the Google Calendar API Version V3 through Ballerina. The connector can be used to implement some of the most common use cases of Google Calendar. The connector provides the capability to programmatically manage events and calendar, CRUD operations on event and calendar operations through the connector endpoints and listener for the events push notification from the calendar.

![image](docs/images/calendar_connector.png)


## Compatibility

|                             |            Versions             |
|:---------------------------:|:-------------------------------:|
| Ballerina Language          |     Swan Lake Alpha2            |
| Google Calendar API         |             V3                  |




## Obtaining Tokens

1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials -> OAuth consent screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create credentials** and select **OAuth client ID**. 
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
[OAuth 2.0 playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the 
access token and refresh token). 
5. Click **Create**. Your client ID and client secret appear. 
6. Enable Calendar API in API console.
7. In a separate browser window or tab, visit [OAuth 2.0 playground](https://developers.google.com/oauthplayground), select the required Google Calendar scopes, and then click **Authorize APIs**.
8. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token. 


### Add configurations file

* Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for OAuth 2.0. Google Calendar uses OAuth 2.0 to authenticate and authorize requests. 
  * The Google Calendar connector can be minimally instantiated in the HTTP client config using the the client ID, client secret, refresh token and access url.
    * Client ID
    * Client Secret
    * Refresh Token
    * Refresh URL
  * Callback address is additionally required in order to use Google Calendar listener. This refers the path of the listener resource function. The time-to-live in seconds for the notification channel is provided by optional parameter expiration time. By default it is 604800 seconds.
    * Calendar ID
    * Callback Address
    * Expiration Time

Add the project configuration file by creating a `Config.toml` file under the root path of the project structure.
This file should have following structure. Add the obtained tokens in the `Config.toml` file.

```
[ballerinax.googleapis_calendar]
clientId = "<client_id">
clientSecret = "<client_secret>"
refreshToken = "<refresh_token>"
refreshUrl = "<refresh_URL>"
calendarId = "<calendar_id>"
address = "<address>"
```


# Quickstart(s)

## Create an quick add event
### Step 1: Import the Calendar module
First, import the `ballerinax/googleapis_calendar` module into the Ballerina project.
```ballerina
import ballerinax/googleapis_calendar as calendar;
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
Note: Must specify the **Refresh token**, obtained with exchanging the authorization code, the **Client ID** and the 
**Client Secret** obtained in the App creation, when configuring the Calendar connector client.


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
    log:print(response.id);
} else {
    // If unsuccessful
    log:printError("Error: " + response.toString());
}
```

## Create an listener for new event creation
### Step 1: Import the Calendar module
First, import the `ballerinax/googleapis_calendar`, `import ballerinax/googleapis_calendar.'listener as listen` and `import ballerina/http` modules into the Ballerina project.

```ballerina
import ballerina/http;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;
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

### Step 3: Initialize the Calendar Listener
Define all the data required to create

```ballerina
int port = 4567;
string calendarId = "primary";
string address = "callback_url;

listener listen:Listener googleListener = new (port, calendarClient, calendarId, address);
```

### Step 4: Create the listener service
If there is an event created in calendar, log will print the event title

```ballerina
service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request)  returns error? {
        listen:EventInfo payload = check googleListener.getEventType(caller, request);
        if (payload?.eventType is string && payload?.event is calendar:Event) {
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

# Samples

Samples are available at : https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/samples
To run a sample, create a new TOML file with name `Config.toml` in the same directory as the `.bal` file with above-mentioned configurable values. Configurable value port is additionally required in order to use listener.

```
port = "<port>"
```
Run this command inside sample directory:
    ```shell
    $ bal run "<ballerina_file>"
    ```

### Get all calendars

This sample shows how to get all calendars that are available in an authorized user's account.  This operation returns stream `Calendar` if successful. Else returns `error`. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

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

### Create a new calendar

This sample shows how to create a new calendar in an authorized user's account. The name of the new calendar is required to do this. This operation will return a `CalenderResource` if successful. Else return an `error`.

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

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

    calendar:CalendarResource|error res = calendarClient->createCalendar("testCalendar");
    if (res is calendar:CalendarResource) {
       log:print(res.id);
    } else {
       log:printError(res.message());
    }
}
```

### Delete a calendar

This sample shows how to delete a calendar in an authorized user's account. The calendar id is required to do this operation. This operation returns an error `true` if unsuccessful.

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

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

    error? res = calendarClient->deleteCalendar(calendarId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:print("Calendar is deleted");
    }
}
```

### Create a new event

This sample shows how to create an event in an authorized user's calendar. The calendar id and input event are required to do this operation. This operation returns an `Event` if successful. Else returns `error`. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

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

### Create an quick add event

This sample shows how to create an quick add in an authorized user's calendar. It creates an event based on a simple text string. The calendar id and event title are required to do this operation. This operation returns an `Event` if successful. Else returns `error`. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

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

    calendar:Event|error res = calendarClient->quickAddEvent(calendarId, "Sample Event");
    if (res is calendar:Event) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
```
### Get an event

This sample shows how to get an event that is available in an authorized user's calendar. The calendar and event ids are required to do this operation. This operation returns an `Event` if successful. Else returns `error`. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

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

    calendar:Event|error res = calendarClient->getEvent(calendarId, eventId);
    if (res is calendar:Event) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}`
```

### Get all events

This sample shows how to get all events that are available in an authorized user's calendar. The calendar id is required to do this operation. This operation returns stream `Event` if successful. Else returns `error`. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

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

### Update an existing event

This sample shows how to update an existing event that is available in an authorized user's calendar. The calendar and event ids are required to do this operation. This operation returns an `Event` if successful. Else returns `error`.

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

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

### Delete an event

This sample shows how to delete an event in an authorized user's calendar. The calendar and event ids are required to do this operation. This operation returns an error `true` if unsuccessful. 

```ballerina
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

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

    error? res = calendarClient->deleteEvent(calendarId, eventId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:print("Event is deleted");
    }
}
```

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
        log:print(res.id);
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
        log:print("Channel is terminated");
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
                    log:print(summary);
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
                    log:print(summary);
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
                log:print("Event deleted");
            }
        }
    }
}
```

### Building the Source

Execute the commands below to build from the source after installing Ballerina SLAlpha2 version.

1. To clone the repository:
Clone this repository using the following command:
```shell
    git clone https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar.git
```
Execute the commands below to build from the source after installing Ballerina SLAlpha2 version.

2. To build the module:
Run this command from the module-ballerinax-googleapis.calendar root directory:
```shell script
    bal build
```

3. To build the module without the tests:
```shell script
    bal build --skip-tests
```

## Contributing to Ballerina

As an open source project, Ballerina welcomes contributions from the community. 

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of Conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful Links

* Discuss the code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Slack channel](https://ballerina.io/community/slack/).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.

## How you can contribute

As an open source project, we welcome contributions from the community. Check the [issue tracker](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/issues) for open issues that interest you. We look forward to receiving your contributions.
