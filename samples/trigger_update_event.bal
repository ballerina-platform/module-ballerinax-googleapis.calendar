import ballerina/log;
import ballerinax/googleapis.calendar;
import ballerinax/googleapis.calendar.'listener as listen;

configurable int port = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;
configurable string expiration = ?;

calendar:ConnectionConfig config = {
    auth: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

listener listen:Listener googleListener = new (port, config, calendarId, address, expiration);

service /calendar on googleListener {
    remote function onEventUpdate(calendar:Event event) returns error? {
        log:printInfo("Updated an event : ", event);
    }
}
