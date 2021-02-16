import ballerina/config;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

public function main() {

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

    calendar:Event|error res = calendarClient->getEvent(config:getAsString("CALENDAR_ID"),
            config:getAsString("EVENT_ID"));
    if (res is calendar:Event) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
