import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

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

    stream<calendar:Calendar>|error res = calendarClient->getCalendars();
    if (res is stream<calendar:Calendar>) {
        var cal = res.next();
        string id = check cal?.value?.id;
        log:print(id);
    } else {
        log:printError(res.message());
    }
}
