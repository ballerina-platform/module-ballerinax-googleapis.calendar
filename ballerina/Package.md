## Package overview
The `ballerinax/googleapis.calendar` is a [Ballerina](https://ballerina.io/) connector for Google Calendar. It provides the capability to manage events and calendar operations. It also provides the capability to support service account authorization that can provide delegated domain-wide access to the GSuite domain and support admins to do operations on behalf of the domain users.

The `ballerinax/googleapis.calendar` package offers APIs to connect and interact with [Google Calendar API V3](https://developers.google.com/calendar/api).

## Prerequisites

In order to use the `calendar` connector, you need to first create the Calendar credentials for the connector to interact with Calendar.

1. **Create a Google Account**: Create a [Google Account](https://accounts.google.com/signup/v2/webcreateaccount?utm_source=ga-ob-search&utm_medium=google-account&flowName=GlifWebSignIn&flowEntry=SignUp).

2. **Create a Google Cloud Platform project**: You need to create a new project on the Google Cloud Platform (GCP). Once the project is created, you can enable the Calendar API for this project.

3. **Create OAuth client ID**: In the GCP console, you need to create credentials for the OAuth client ID. This process involves setting up the OAuth consent screen and creating the credentials for the OAuth client ID.

4. **Get the access token and refresh token**: You need to generate an access token and a refresh token. The Oauth playground can be used to easily exchange the authorization code for the tokens.

For detailed steps including the necessary links, go to the [Setup Guide](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/docs/setup/setup.md).

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

## Examples

The `calendar` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples), covering use cases like creating calendar, scheduling meeting events, and adding reminders.

1. [Project Management](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/project-management/main.bal)
    Efficiently manage a work schedule by interacting with the APIs for various tasks related to scheduling and organizing work-related events and meetings.
2. [Work Schedule](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/work-schedule/main.bal)
    Managing personal project schedule and collaborating with team members.

For comprehensive information about the connector's functionality, configuration, and usage in Ballerina programs, refer to the `calendar` connector's reference guide in [Ballerina Central](https://central.ballerina.io/ballerinax/googleapis.calendar/latest).

## Set up Calendar API

To use the `calendar` connector, create Calendar credentials to interact with Calendar.

1. **Create a Google Cloud Platform project**: Create a new project on [Google Cloud Platform (GCP)](https://console.cloud.google.com/getting-started?pli=1). Enable the Calendar API for this project.

2. **Create OAuth client ID**: In the GCP console, create credentials for the OAuth client ID by setting up the OAuth consent screen.

3. **Get the access token and refresh token**: Generate an access token and a refresh token using the OAuth playground.

For detailed steps, including necessary links, refer to the [Setup Guide](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/docs/setup/setup.md).
