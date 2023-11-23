# Package overview

The Google Calendar Connector provides the capability to manage events and calendar operations. It also provides the capability to support service account authorization that can provide delegated domain-wide access to the GSuite domain and support admins to do operations on behalf of the domain users.

This module supports [Google Calendar API V3](https://developers.google.com/calendar/api).

## Set up Calendar API

To utilize the Calendar connector, you must have access to the Calendar REST API through a [Google Cloud Platform (GCP)](https://console.cloud.google.com/) account and a project under it. If you do not have a GCP account, you can sign up for one [here](https://cloud.google.com/).

### Step 1: Create a Google Cloud Platform Project

In order to use the `calendar` connector, you need to first create the Calendar credentials for the connector to interact with Calendar.

1. Open the [GCP Console](https://console.cloud.google.com/).
2. Click on the project drop-down and either select an existing project or create a new one for which you want to add an API key.

    ![GCP Console](resources/gcp-console-project-view.png)

3. Navigate to the **Library** and enable the Calendar API.

    ![Enable Calendar API](resources/enable-calendar-api.png)

### Step 2: Create OAuth Client ID

1. Navigate to the **Credentials** tab in your Google Cloud Platform console.

2. Click  **Create credentials** and from the dropdown menu, select **OAuth client ID**.

    ![Create Credentials](resources/create-credentials.png)

3. You will be directed to the **OAuth consent** screen, in which you need to fill in the necessary information below.

    | Field                     | Value |
    | ------------------------- | ----- |
    | Application type          | Web Application |
    | Name                      | CalendarConnector  |
    | Authorized redirect URIs  | <https://developers.google.com/oauthplayground> |

    After filling in these details, click **Create**.

    **Note**: Save the provided Client ID and Client secret.

### Step 3: Get the access token and refresh token

**Note**: It is recommended to use the OAuth 2.0 playground to obtain the tokens.

1. Configure the OAuth playground with the OAuth client ID and client secret.

    ![OAuth Playground](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/ballerina/resources/oauth-playground.png)

2. Authorize the Calendar APIs.

    ![Authorize APIs](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/ballerina/resources/authorize-calendar-apis.png)

3. Exchange the authorization code for tokens.

    ![Exchange Tokens](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/ballerina/resources/exchange-tokens.png)
