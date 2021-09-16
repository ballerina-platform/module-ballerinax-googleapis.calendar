import ballerina/log;
import ballerinax/googleapis.calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string testChannelId = ?;
configurable string testResourceId = ?;

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

    error? res = calendarClient->stopChannel(testChannelId, testResourceId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:printInfo("Channel is terminated");
    }
}
