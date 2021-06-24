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
configurable string domainVerificationFileContent = ?;

listen:ListenerConfiguration listenerConfig = {
    port: port,
    clientConfiguration: {oauth2Config: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }},
    calendarId: calendarId,
    callbackUrl: callbackUrl,
    domainVerificationFileContent: domainVerificationFileContent
};

listener listen:Listener googleListener = new (listenerConfig);

service / on googleListener {
    remote function onEventUpdate(calendar:Event event) returns error? {
        log:printInfo("Updated an event : " + event.toString());
    }
}
