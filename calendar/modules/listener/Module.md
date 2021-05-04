## Listener Overview

The Google Calendar Ballerina Connector listener allows you to get notification for the created, updated and deleted events in the calendar.

# Prerequisites

* Java Development Kit (JDK) with version 11 is required.

*   Ballerina is required.
Download the required Ballerina [distribution](https://ballerinalang.org/downloads/) version

## Compatibility

|                             |            Versions             |
|:---------------------------:|:-------------------------------:|
| Ballerina Language          |     Swan Lake Alpha5            |
| Google Calendar API         |             V3                  |
| Java Development Kit (JDK)  |             11                  |

### Obtaining tokens to run the samples

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

### Add configurations file

* Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for Bearer Token Authentication and OAuth 2.0. Google Calendar uses OAuth 2.0 to authenticate and authorize requests. It uses the Direct Token Grant Type. The Google Calendar connector can be minimally instantiated in the HTTP client config using the OAuth 2.0 access token.
    * Access Token 
    ``` 
    calendar:CalendarConfiguration config = {
        oauth2Config: {
            token: <access token>
        }
    }
    ```

    The Google Calendar connector can also be instantiated in the HTTP client config without the access token using the client ID, client secret, and refresh token.
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
* Callback address is additionally required in order to use Google Calendar listener. It is the path of the listener resource function. The time-to-live in seconds for the notification channel is provided in optional parameter expiration time. By default it is 604800 seconds.
  * Callback address
  * Expiration time

* Add the configuration file by creating a `Config.toml` file under the root path of the project structure.
This file should have following configurations. Add the tokens obtained in the previous step to the `Config.toml` file.

  ```
  port = "<port>"
  clientId = "<client_id">
  clientSecret = "<client_secret>"
  refreshToken = "<refresh_token>"
  refreshUrl = "<refresh_URL>"
  address = "<address>"
  ```

# Samples

Samples are available at : https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/samples. To run a sample, create a new TOML file with name `Config.toml` in the same directory as the `.bal` file with above-mentioned configurable values.
- #### [Watch event changes](samples/watch_event.bal) 

  This sample shows how to watch for changes to events in an authorized user's calendar. It is a subscription to receive push notification from Google on events changes.  The calendar id and callback url are required to do this operation. Channel live time can be provided via an optional parameter. By default it is 604800 seconds. This operation returns  `WatchResponse` if successful. Else returns `error`.

- #### [Stop a channel subscription](samples/stop_channel.bal)

  This sample shows how to stop an existing subscription. The channel id and resource is are required to do this operation. This operation returns an error `true` if unsuccessful.

## Listener

- #### [Trigger for new event](samples/trigger_create_event.bal)

  This sample shows how to create a trigger on new event. When a new event is occurred, that event details can be captured in this listener.

- #### [Trigger for updated event](samples/trigger_update_event.bal)

  This sample shows how to create a trigger on an event update. When a new event is updated, that event details can be captured in this listener.

- #### [Trigger for deleted event](samples/trigger_delete_event.bal)

  This sample shows how to create a trigger on cancelled event. When a new event is cancelled, that event details can be captured in this listener.