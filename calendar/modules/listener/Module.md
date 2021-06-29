## Listener Overview

The Google Calendar Ballerina Connector listener allows you to get notification for the created, updated and deleted events in the calendar.

# Prerequisites

* Java Development Kit (JDK) with version 11 is required.

*   Ballerina is required.
Download the required Ballerina [distribution](https://ballerinalang.org/downloads/) version

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

* Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has support for bearer token config and OAuth 2.0 refresh token grant config to access listener. 

    * Bearer Token 
    The Google Calendar connector can be minimally instantiated in the HTTP client config using the OAuth 2.0 access token as bearer token. As access token has defined time limit, client operations can be accessed for a certain time period.  
    ``` 
    calendar:CalendarConfiguration config = {
        oauth2Config: {
            token: <access token>
        }
    }
    ```

    * OAuth2 Refresh Token
    The Google Calendar connector can also be instantiated in the HTTP client config with the refresh token using the client ID, client secret, and refresh token. In this authorization client can function until refresh token stop working.
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

* Callback address and domain verification file content are additionally required in order to use Google Calendar listener. It is the path of the listener resource function. The time-to-live in seconds for the notification channel is provided in optional parameter expiration time. By default it is 604800 seconds.
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
  calendarId = "<calendar_id>"
  callbackUrl = "<call_back url>"
  domainVerificationFileContent = "<domain_verification_file_content>"
  ```

# Quickstart

## Create a listener for new event creation
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

# Samples

Samples are available at : https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/samples.

- #### [Trigger for new event](../../../samples/trigger_create_event.bal)

  This sample shows how to create a trigger on new event. When a new event is occurred, that event details can be captured in this listener.

- #### [Trigger for updated event](../../../samples/trigger_update_event.bal)

  This sample shows how to create a trigger on an event update. When a new event is updated, that event details can be captured in this listener.

- #### [Trigger for deleted event](../../../samples/trigger_delete_event.bal)

  This sample shows how to create a trigger on cancelled event. When a new event is cancelled, that event details can be captured in this listener.


> **NOTE:**
At user function implementation if there was an error we throw it up & the http client will return status 500 error. 
If no any error occured & the user logic is executed successfully we respond with status 200 OK. 
If the user logic in listener remote operations include heavy processing, the user may face http timeout issues. 
To solve this issue, user must use asynchronous processing when it includes heavy processing.

- #### [Trigger for heavy event processing](../../../samples/trigger_on_heavy_processing.bal)
