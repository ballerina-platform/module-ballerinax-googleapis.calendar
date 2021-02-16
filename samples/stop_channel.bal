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

    boolean|error res = calendarClient->stopChannel(testChannelId, testResourceId);
    if (res is boolean) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
