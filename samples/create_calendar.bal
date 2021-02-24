import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

public function main() {

    calendar:CalendarConfiguration config = {
       oauth2Config: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };
    calendar:Client calendarClient = new (config);

    CalendarResource|error res = calendarClient->createCalendar("testCalendar");
    if (res is calendar:CalendarResource) {
       log:print(res.id);
    } else {
       log:printError(res.message());
    }
}
