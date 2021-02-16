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

    calendar:InputEvent event = {
        'start: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        end: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        summary: "Sample Event"
    };
    calendar:Event|error res = calendarClient->createEvent(config:getAsString("CALENDAR_ID"), event);
    if (res is calendar:Event) {
        log:print(res.id);
    } else {
        log:printError(res.message());
    }
}
