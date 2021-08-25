import ballerina/log;
import ballerinax/googleapis.calendar;

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

    stream<calendar:Calendar,error?> resultStream = check calendarClient->getCalendars();
    record {|calendar:Calendar value;|}|error? res = resultStream.next();
    if (res is record {|calendar:Calendar value;|}) {
        log:printInfo(res.value["id"]);
    } else {
        if (res is error) {
            log:printError(res.message());
        }
    }
}
