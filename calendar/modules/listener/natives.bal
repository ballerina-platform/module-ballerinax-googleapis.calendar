import ballerina/jballerina.java;
import ballerinax/googleapis_calendar as calendar;

isolated function callOnNewEventMethod(SimpleHttpService httpService, calendar:Event event) returns error?
    = @java:Method {
    'class: "org.ballerinalang.googleapis.calendar.HttpNativeOperationHandler"
} external;

isolated function callOnEventUpdateMethod(SimpleHttpService httpService, calendar:Event event) returns error?
    = @java:Method {
    'class: "org.ballerinalang.googleapis.calendar.HttpNativeOperationHandler"
} external;

isolated function callOnEventDeleteMethod(SimpleHttpService httpService, calendar:Event event) returns error?
    = @java:Method {
    'class: "org.ballerinalang.googleapis.calendar.HttpNativeOperationHandler"
} external;

# Invoke native method to retrive implemented method names in the subscriber service
#
# + httpService - current http service
# + return - {@code string[]} containing the method-names in current implementation
isolated function getServiceMethodNames(SimpleHttpService httpService) returns string[] = @java:Method {
    'class: "org.ballerinalang.googleapis.calendar.HttpNativeOperationHandler"
} external;
