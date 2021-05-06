import ballerina/log;
import ballerinax/googleapis.calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

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

    calendar:InputEvent event = {
        'start: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        end: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        summary: "Sample Event"
    };
    calendar:Event|error res = calendarClient->createEvent(calendarId, event);
    if (res is calendar:Event) {
       log:printInfo(res.id);
    } else {
       log:printError(res.message());
    }
}
