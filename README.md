Ballerina Google Calendar Connector 
===================

[![Build](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/actions?query=workflow%3ACI)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-googleapis.calendar.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.calendar/commits/master)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Google Calendar](https://developers.google.com/calendar) is a time-management and scheduling calendar service developed by Google. It lets users to organize their schedule and share events with others.

This connector provides the capability to programmatically manage events and calendar and listen the events occurred in the calendar. 
For more information about configuration and operations, go to the module.
- [ballerinax/googleapis.calendar](calendar/Module.md)
- [ballerinax/googleapis.calendar.listener](calendar/modules/listener/Module.md)
 
## Building from the Source
### Setting Up the Prerequisites
1. Download and install Java SE Development Kit (JDK) version 11 (from one of the following locations).
 
  * [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)
 
  * [OpenJDK](https://adoptopenjdk.net/)
 
       > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed
       JDK.
 
2. Download and install [Ballerina Swan Lake Beta2](https://ballerina.io/)

### Building the Source
 
Execute the commands below to build from the source.

1. To build Java dependency
   ```   
   ./gradlew build
   ```
2. To build the package:
   ```   
   bal build -c ./calendar
   ```
3. To run the without tests:
   ```
   bal build -c --skip-tests ./calendar
   ```
## Contributing to Ballerina
 
As an open source project, Ballerina welcomes contributions from the community.
 
For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).
 
## Code of Conduct
 
All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).
 
## Useful Links
 
* Discuss code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Slack channel](https://ballerina.io/community/slack/).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
 