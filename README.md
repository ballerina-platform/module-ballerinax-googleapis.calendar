# Ballerina Google Calendar Connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/trivy-scan.yml)
[![codecov](https://codecov.io/gh/ballerina-platform/module-ballerinax-googleapis.calendar/branch/main/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerinax-googleapis.calendar)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-googleapis.calendar.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/googleapis.calendar.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fgoogleapis.calendar)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Google Calendar](https://developers.google.com/calendar) is a time-management and scheduling calendar service developed by Google. It lets users to organize their schedule and share events with others.This connector provides the capability to programmatically manage events and calendars.
For more information about configuration and operations, go to the module.

- [googleapis.gcalendar](calendar/Module.md) - Perform Google Calendar related operations programmatically

## Overview

The Google Calendar Connector provides the capability to manage events and calendar operations. It also provides the capability to support service account authorization that can provide delegated domain-wide access to the GSuite domain and support admins to do operations on behalf of the domain users.

This module supports [Google Calendar API V3](https://developers.google.com/calendar/api).

## Setup Guide

To utilize the Calendar connector, you must have access to the Calendar REST API through a [Google Cloud Platform (GCP)](https://console.cloud.google.com/) account and a project under it. If you do not have a GCP account, you can sign up for one [here](https://cloud.google.com/).

### Step 1: Create a Google Cloud Platform Project

In order to use the Google Calendar connector, you need to first create the Calendar credentials for the connector to interact with Calendar.

1. Open the [Google Cloud Platform Console](https://console.cloud.google.com/).

2. Click on the project drop-down menu and either select an existing project or create a new one for which you want to add an API key.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/gcp-console-project-view.png alt="GCP Console Project View" width="50%">

### Step 2: Enable Calendar API

1. Navigate to the **Library** and enable the Calendar API.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/enable-calendar-api.png alt="Enable Calendar API" width="50%">

### Step 3: Configure OAuth Consent

1. Click on the **OAuth consent screen** tab in the Google Cloud Platform console.

    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/consent-screen.png alt="Consent Screen" width="50%">

2. Provide a name for the consent application and save your changes.

### Step 4: Create OAuth Client

1. Navigate to the **Credentials** tab in your Google Cloud Platform console.

2. Click  **Create credentials** and from the dropdown menu, select **OAuth client ID**.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/create-credentials.png alt="Create Credentials" width="50%">

3. You will be directed to the **OAuth consent** screen, in which you need to fill in the necessary information below.

    | Field                     | Value |
    | ------------------------- | ----- |
    | Application type          | Web Application |
    | Name                      | CalendarConnector  |
    | Authorized redirect URIs  | <https://developers.google.com/oauthplayground> |

4. After filling in these details, click **Create**.

5. Make sure to save the provided **Client ID** and **Client secret**.

### Step 5: Get the Access and Refresh Tokens

**Note**: It is recommended to use the OAuth 2.0 playground to obtain the tokens.

1. Configure the OAuth playground with the OAuth client ID and client secret.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/oauth-playground.png alt="OAuth Playground" width="50%">

2. Authorize the Calendar APIs.

    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/authorize-calendar-apis.png alt="Authorize APIs" width="50%">

3. Exchange the authorization code for tokens.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-googleapis.calendar/main/ballerina/resources/exchange-tokens.png alt="Exchange Tokens" width="50%">

## Quickstart

This sample demonstrates a scenario of creating a secondary calendar and adding a new event to it using the Ballerina Google Calendar connector.

### Step 1: Import the package

Import the `ballerinax/googleapis.gcalendar` package into your Ballerina project.

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

gcalendar:Client calendarClient = check new ({
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
   gcalendar:Client calendarClient = ...//

   // create a calendar
   gcalendar:Calendar calendar = check calendarClient->/calendars.post({
      summary: "Work Schedule"
   });

   // quick add new event
   string eventTitle = "Sample Event";
   gcalendar:Event event = check calendarClient->/calendars/[calendarId]/events/quickAdd.post(eventTitle);
}
```

## Examples

The Google calendar connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples), covering use cases like creating calendar, scheduling meeting events, and adding reminders.

1. [Project Management With Calendar API](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/project-management-with-calendar)
    This example shows how to use Google calendar APIs to efficiently manage work schedule of a person. It interacts with the API for various tasks related to scheduling and organizing work-related events and meetings.
2. [Work Schedule Management With Calendar API](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/work-schedule-management-with-calendar)
    This example shows how to use Google calendar APIs to managing personal project schedule and collaborating with team members.

For comprehensive information about the connector's functionality, configuration, and usage in Ballerina programs, refer to the Google Calendar connector's reference guide in [Ballerina Central](https://central.ballerina.io/ballerinax/googleapis.calendar/latest).

## Issues and projects

The **Issues** and **Projects** tabs are disabled for this repository as this is part of the Ballerina library. To report bugs, request new features, start new discussions, view project boards, etc., visit the Ballerina library [parent repository](https://github.com/ballerina-platform/ballerina-library).

This repository only contains the source code for the package.

## Building from the Source

### Prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

   - [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
   - [OpenJDK](https://adoptium.net/)

    > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

    > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Generate a Github access token with read package permissions, then set the following `env` variables:

    ```bash
   export packageUser=<Your GitHub Username>
   export packagePAT=<GitHub Personal Access Token>
    ```

To utilize the Google Calendar connector in your Ballerina application, modify the `.bal` file as follows:

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To debug package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

5. To debug with Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

6. Publish the generated artifacts to the local Ballerina central repository:

   ```bash
   ./gradlew clean build -PpublishToLocalCentral=true
   ```

7. Publish the generated artifacts to the Ballerina central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contributing to Ballerina

As an open source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

- Discuss code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
- Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
- Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
