## Package overview

The Ballerina Google Calendar Connector provides the capability to manage events and calendar operations. It also provides the capability to support service account authorization that can provide delegated domain-wide access to the GSuite domain and support admins to do operations on behalf of the domain users.

The Ballerina Google Calendar module supports [Google Calendar API V3](https://developers.google.com/calendar/api).

## Setup guide

To utilize the Calendar connector, you must have access to the Calendar REST API through a [Google Cloud Platform (GCP)](https://console.cloud.google.com/) account and a project under it. If you do not have a GCP account, you can sign up for one [here](https://cloud.google.com/).

### Step 1: Create a Google Cloud Platform project

In order to use the Google Calendar connector, you need to first create the Calendar credentials for the connector to interact with Calendar.

1. Open the [Google Cloud Platform console](https://console.cloud.google.com/).

2. Click on the project drop-down menu and either select an existing project or create a new one for which you want to add an API key.

    ![GCP Console](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/gcp-console-project-view.png)

### Step 2: Enable Calendar API

1. Navigate to the **Library** and enable the Calendar API.

    ![Enable Calendar API](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/enable-calendar-api.png)

### Step 3: Configure OAuth consent

1. Click on the **OAuth consent screen** tab in the Google Cloud Platform console.

    ![Consent Screen](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/consent-screen.png)

2. Provide a name for the consent application and save your changes.

### Step 4: Create OAuth client

1. Navigate to the **Credentials** tab in your Google Cloud Platform console.

2. Click  **Create credentials** and from the dropdown menu, select **OAuth client ID**.

    ![Create Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/create-credentials.png)

3. You will be directed to the **OAuth consent** screen, in which you need to fill in the necessary information below.

    | Field                     | Value |
    | ------------------------- | ----- |
    | Application type          | Web Application |
    | Name                      | CalendarConnector  |
    | Authorized redirect URIs  | <https://developers.google.com/oauthplayground> |

4. After filling in these details, click **Create**.

5. Make sure to save the provided Client ID and Client secret.

### Step 5: Get the access and refresh tokens

**Note**: It is recommended to use the OAuth 2.0 playground to obtain the tokens.

1. Configure the OAuth playground with the OAuth client ID and client secret.

    ![OAuth Playground](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/oauth-playground.png)

2. Authorize the Calendar APIs.

    ![Authorize APIs](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/authorize-calendar-apis.png)

3. Exchange the authorization code for tokens.

    ![Exchange Tokens](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/exchange-tokens.png)

## Quickstart

To use the Google Calendar connector in your Ballerina project, modify the `.bal` file as follows:

### Step 1: Import the module

Import the `ballerinax/googleapis.gcalendar` module.

```ballerina
import ballerinax/googleapis.gcalendar;
```

### Step 2: Instantiate a new connector

Create a `gcalendar:ConnectionConfig` with the obtained OAuth2.0 tokens and initialize the connector with it.

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

gcalendar:Client calendar = check new ({
   auth: {
      clientId,
      clientSecret,
      refreshToken,
      refreshUrl
   }
});
```

### Step 3: Invoke the connector operation

You can now utilize the operations available within the connector.

```ballerina
public function main() returns error? {
    gcalendar:Client calendar = ...//

    // create a calendar
    gcalendar:Calendar calendar = check calendar->/calendars.post({
        summary: "Work Schedule"
    });

    // quick add new event
    string eventTitle = "Sample Event";
    gcalendar:Event event = check calendar->/calendars/[calendarId]/events/quickAdd.post(eventTitle);
}
```

Use the following command to compile and run the Ballerina program.

```bash
bal run
```

## Examples

The Google Calendar connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples), covering use cases like creating calendar, scheduling meeting events, and adding reminders.

1. [Project management with Calendar API](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/project-management-with-calendar)
    This example shows how to use Google Calendar APIs to efficiently manage work schedule of a person. It interacts with the API for various tasks related to scheduling and organizing work-related events and meetings.
2. [Work schedule management with Calendar API](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/work-schedule-management-with-calendar)
    This example shows how to use Google Calendar APIs to managing personal project schedule and collaborating with team members.

For comprehensive information about the connector's functionality, configuration, and usage in Ballerina programs, refer to the Google Calendar connector's reference guide in [Ballerina Central](https://central.ballerina.io/ballerinax/googleapis.calendar/latest).
