import ballerina/log;
import ballerinax/googleapis.calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string eventId = ?;

public function main() returns error? {
  
    calendar:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };
    calendar:Client calendarClient = check new (config);

    calendar:Event|error res = calendarClient->getEvent(calendarId, eventId);
    if (res is calendar:Event) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}
