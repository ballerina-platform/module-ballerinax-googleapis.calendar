# Configure Google Calendar API

_Owners_: @Nuvindu \
_Reviewers_:  \
_Created_: 2022/11/15 \
_Updated_: 2023/11/15 \

## Introduction

To utilize the Calendar connector, you must have access to the Calendar REST API through a [Google Cloud Platform (GCP)](https://console.cloud.google.com/) account and a project under it. If you do not have a GCP account, you can sign up for one [here](https://cloud.google.com/).

## Step 1: Create a Google Cloud Platform Project

1. Open the [GCP Console](https://console.cloud.google.com/).
2. Click on the project drop-down and either select an existing project or create a new one for which you want to add an API key.

    ![GCP Console](resources/gcp-console-project-view.png)

3. Navigate to the **Library** and enable the Calendar API.

    ![Enable Calendar API](resources/enable-calendar-api.png)

## Step 2: Create OAuth Client ID

1. Navigate to the **Credentials** tab in your Google Cloud Platform console.

2. Click  **Create credentials** and from the dropdown menu, select **OAuth client ID**.

    ![Create Credentials](resources/create-credentials.png)

3. You will be directed to the **OAuth consent** screen, in which you need to fill in the necessary information below.

    | Field                     | Value |
    | ------------------------- | ----- |
    | Application type          | Web Application |
    | Name                      | CalendarConnector  |
    | Authorized redirect URIs  | https://developers.google.com/oauthplayground |

    After filling in these details, click **Create**.

    **Note**: Save the provided Client ID and Client secret.

## Step 3: Get the access token and refresh token

**Note**: It is recommended to use the OAuth 2.0 playground to obtain the tokens.

1. Configure the OAuth playground with the OAuth client ID and client secret.

    ![OAuth Playground](resources/oauth-playground.png)

2. Authorize the Calendar APIs.

    ![Authorize APIs](resources/authorize-calendar-apis.png)

3. Exchange the authorization code for tokens.

    ![Exchange Tokens](resources/exchange-tokens.png)
