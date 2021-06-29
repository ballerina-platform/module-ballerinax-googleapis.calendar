import ballerina/log;
import ballerinax/googleapis.calendar;
import ballerinax/googleapis.calendar.'listener as listen;

configurable int port = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string callbackUrl = ?;
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
    remote function onNewEvent(calendar:Event event) returns error? {
        // Write your logic here.....
        log:printInfo("Received onAppendRow-message ", eventMsg = event);
        _ = @strand { thread: "any" } start userLogic(event);
    }
}

function userLogic(calendar:Event event) returns error? {
    // Write your logic here
    log:printInfo("Received onAppendRow-message 1 ", eventMsg = event);
}
