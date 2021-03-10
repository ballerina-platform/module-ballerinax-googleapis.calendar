import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable int port = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = ?;
configurable string address = ?;
configurable string expiration = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = check new (config);
listener listen:Listener googleListener = new (port, calendarClient, calendarId, address, expiration);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request) returns error? {
        listen:EventInfo payload = check googleListener.getEventType(caller, request);
        if(payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:DELETED) {
                log:print("Event deleted");
            }
        }      
    }
}
