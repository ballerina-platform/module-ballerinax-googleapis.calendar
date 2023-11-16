Ballerina Google Calendar Connector 
===================

[![Build](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/ballerina-platform/module-ballerinax-googleapis.calendar/branch/main/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerinax-googleapis.calendar)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-googleapis.calendar.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/commits/main)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions/workflows/build-with-bal-test-native.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Google Calendar](https://developers.google.com/calendar) is a time-management and scheduling calendar service developed by Google. It lets users to organize their schedule and share events with others.

This connector provides the capability to programmatically manage events and calendars. 
For more information about configuration and operations, go to the module.
- [googleapis.calendar](calendar/Module.md) - Perform Google Calendar related operations programmatically
 
## Building from the Source
### Setting up the prerequisites
1. Download and install Java SE Development Kit (JDK) version 11. You can install either [OpenJDK](https://adoptopenjdk.net/) or [Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).
 
      > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed
      JDK.
 
2. Download and install [Ballerina Swan Lake](https://ballerina.io/)

3. Generate a Github access token with read package permissions, then set the following `env` variables:
    ```
   export packageUser=<Your GitHub Username>
   export packagePAT=<GitHub Personal Access Token>
    ```

To utilize the `calendar` connector in your Ballerina application, modify the `.bal` file as follows:

### Step 1: Import the connector
Import the `ballerinax/googleapis.calendar` package into your Ballerina project.
```ballerina
import ballerinax/googleapis.calendar;
```

### Step 2: Instantiate a new connector
Create a `calendar:ConnectionConfig` with the obtained OAuth2.0 tokens and initialize the connector with it.
```ballerina
calendar:Client calendarClient = check new ({
   auth: {
      clientId: clientId,
      clientSecret: clientSecret,
      refreshToken: refreshToken,
      refreshUrl: refreshUrl
   }
});
```

### Step 3: Invoke the connector operation
You can now utilize the operations available within the connector.
```ballerina
calendar:Calendar calendarResult = check calendarClient->/calendars.post({ summary: "Work Schedule" });
```

## Examples

The `calendar` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples), covering use cases like creating calendar, scheduling meeting events, and adding reminders.

1. [Project Management](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/project-management/main.bal)
    This example shows how to use Google calendar APIs to efficiently manage work schedule of a person. It interacts with the API for various tasks related to scheduling and organizing work-related events and meetings.

2. [Work Schedule](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/tree/main/examples/work-schedule/main.bal)
    This example shows how to use Google calendar APIs to managing personal project schedule and collaborating with team members.

### Building the source
 
Execute the commands below to build from the source.

1. To build the package:
   ```
   ./gradlew clean build
   ```

2. To run the tests:
   ```
   ./gradlew clean test
   ```

3. To run a group of tests
   ```
   ./gradlew clean test -Pgroups=<test_group_names>
   ```

4. To build the without the tests:
   ```
   ./gradlew clean build -x test
   ```

5. To debug package with a remote debugger:
   ```
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with Ballerina language:
   ```
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina central repository:
    ```
    ./gradlew clean build -PpublishToLocalCentral=true
    ```
8. Publish the generated artifacts to the Ballerina central repository:
   ```
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contributing to Ballerina
 
As an open source project, Ballerina welcomes contributions from the community.
 
For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct
 
All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).
 
## Useful links
 
* Discuss code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.

