import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

public function main() returns error? {

    calendar:CalendarConfiguration config = {
       oauth2Config: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };

    calendar:Client calendarClient = check new (config);

    error? res = calendarClient->deleteEvent(calendarId, eventId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:print("Event is deleted");
    }
}
