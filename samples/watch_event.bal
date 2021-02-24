import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;

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

    calendar:WatchConfiguration watchConfig = {
        id: "testId",
        token: "testToken",
        'type: "webhook",
        address: address,
        params: {
            ttl: "300"
        }
    };
    calendar:WatchResponse|error res = calendarClient->watchEvents(calendarId, watchConfig);
    if (res is calendar:WatchResponse) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
