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

    stream<calendar:Event>|error res = calendarClient->getEvents(config:getAsString("CALENDAR_ID"));
    if (res is stream<calendar:Event>) {
        var eve = res.next();
        string id = check eve?.value?.id;
        log:print(id);
    } else {
        log:printError(res.message());
    }
}
