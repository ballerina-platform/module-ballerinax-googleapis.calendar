import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

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

    stream<calendar:Event>|error res = calendarClient->getEvents(calendarId);
    if (res is stream<calendar:Event>) {
        var eve = res.next();
        string id = check eve?.value?.id;
        log:print(id);
    } else {
        log:printError(res.message());
    }
}
