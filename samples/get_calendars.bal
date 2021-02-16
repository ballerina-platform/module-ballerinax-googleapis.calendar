import ballerina/config;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

public function main() returns @tainted error? {

    calendar:CalendarConfiguration calendarConfig = {
        oauth2Config: {
            accessToken: config:getAsString("ACCESS_TOKEN"),
            refreshConfig: {
                refreshUrl: config:getAsString("REFRESH_URL"),
                refreshToken: config:getAsString("REFRESH_TOKEN"),
                clientId: config:getAsString("CLIENT_ID"),
                clientSecret: config:getAsString("CLIENT_SECRET")
            }
        }
    };

    calendar:Client calendarClient = new (calendarConfig);

    stream<calendar:Calendar>|error res = calendarClient->getCalendars();
    if (res is stream<calendar:Calendar>) {
        var cal = res.next();
        string id = check cal?.value?.id;
        log:print(id);
    } else {
        log:printError(res.message());
    }
}
