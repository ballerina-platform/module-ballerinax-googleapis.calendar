import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;
import ballerinax/googleapis_calendar.'listener as listen;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string channelId = ?;
configurable string resourceId = ?;
configurable string calendarId = ?;

calendar:CalendarConfiguration config = {
    oauth2Config: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        refreshUrl: refreshUrl   
    }
};

calendar:Client calendarClient = new (config);
listener listen:Listener googleListener = new (4567,calendarClient, channelId, resourceId, calendarId);

service /calendar on googleListener {
    resource function post events(http:Caller caller, http:Request request){
        listen:EventInfo payload = checkpanic googleListener.getEventType(caller, request);
        if(payload?.eventType is string && payload?.event is calendar:Event) {
            if (payload?.eventType == listen:UPDATED) {
                var event = payload?.event;
                string? summary = event?.summary;        
                if (summary is string) {
                    log:print(summary);
                } 
            }
        }      
    }
}
