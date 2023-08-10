import ballerina/log;
import ballerinax/googleapis.calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;

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

    stream<calendar:Event,error?> resultStream  = check calendarClient->getEvents(calendarId);
    record {|calendar:Event value;|}|error? res = resultStream.next();
    if (res is record {|calendar:Event value;|}) {
        log:printInfo(res.value["id"]);
    } else {
        if (res is error) {
            log:printError(res.message());
        }
    }
}
