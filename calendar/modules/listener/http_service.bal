import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_calendar as calendar;

service class HttpService {

    private boolean isOnNewEventAvailable = false;
    private boolean isOnEventUpdateAvailable = false;
    private boolean isOnEventDeleteAvailable = false;

    private SimpleHttpService httpService;
    private calendar:Client calendarClient;
    private string calendarId;
    public string channelId;
    public string resourceId;
    private string? syncToken = ();

    public isolated function init(SimpleHttpService|HttpService httpService, calendar:Client calendarClient, 
        string calendarId, string channelId, string resourceId) {
        self.httpService = httpService;
        self.calendarClient = calendarClient;
        self.calendarId = calendarId;
        self.channelId = channelId;
        self.resourceId = resourceId;

        string[] methodNames = getServiceMethodNames(httpService);

        foreach var methodName in methodNames {
            match methodName {
                "onNewEvent" => {
                    self.isOnNewEventAvailable = true;
                }
                "onEventUpdate" => {
                    self.isOnEventUpdateAvailable = true;
                }
                "onEventDelete" => {
                    self.isOnEventDeleteAvailable = true;
                }
                _ => {
                    log:printError("Unrecognized method [" + methodName + "] found in the implementation");
                }
            }
        }
    }

    isolated resource function post events(http:Caller caller, http:Request request) returns error? {
        if (check request.getHeader(GOOGLE_CHANNEL_ID) == self.channelId && check request.getHeader(GOOGLE_RESOURCE_ID)
            == self.resourceId) {
            http:Response res = new;
            res.statusCode = http:STATUS_OK;
            if (check request.getHeader(GOOGLE_RESOURCE_STATE) == SYNC) {
                self.syncToken = check self.getNextPageToken(self.calendarClient, self.calendarId);
                check caller->respond(res);
            } else {
                calendar:EventResponse resp = check self.calendarClient->getEventResponse(self.calendarId, syncToken
                  = self.syncToken);
                check caller->respond(res);
                self.syncToken = resp?.nextSyncToken;
                calendar:Event[] events = resp?.items;
                calendar:Event event = events[0];
                string? created = event?.created;
                string? updated = event?.updated;
                calendar:Time? 'start = event?.'start;
                calendar:Time? end = event?.end;
                if (created is string && updated is string && 'start is calendar:Time && end is calendar:Time) {
                    if (created.substring(0, 19) == updated.substring(0, 19)) {
                       if (self.isOnNewEventAvailable) {
                           check callOnNewEventMethod(self.httpService, event);
                       }
                    } else  {
                        if (self.isOnEventUpdateAvailable) {
                            check callOnEventUpdateMethod(self.httpService, event);
                        }
                    }
                } else {
                    if (self.isOnEventDeleteAvailable) {
                        check callOnEventDeleteMethod(self.httpService, event);
                    }
                }
            }
        }
        return error (INVALID_ID_ERROR);
    }

    isolated function getNextPageToken(calendar:Client httpClient, string calendarId, string? pageToken = ()) returns
        @tainted string?|error {
        calendar:EventResponse resp = check httpClient->getEventResponse(calendarId, pageToken = pageToken);
        string? nextPageToken = resp?.nextPageToken;
        if (nextPageToken is string) {
            var token = check self.getNextPageToken(httpClient, calendarId, nextPageToken);
        }
        return resp?.nextSyncToken;
    }
}
