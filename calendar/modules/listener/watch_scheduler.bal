import ballerina/task;
import ballerina/time;

class Job {
    *task:Job;
    private Listener 'listener;

    isolated function init(Listener 'listener) {
        self.'listener = 'listener;
    }

    public isolated function execute() {
        checkpanic self.'listener.registerWatchChannel();
        checkpanic self.scheduleNextChannelRenewal();
    }

    isolated function scheduleNextChannelRenewal() returns error? {
        time:Utc currentUtc = time:utcNow();
        decimal timeDifference = (self.'listener.expirationTime/1000) - (<decimal>currentUtc[0]) - 60;
        time:Utc scheduledUtcTime = time:utcAddSeconds(currentUtc, timeDifference);
        time:Civil scheduledTime = time:utcToCivil(scheduledUtcTime);
        task:JobId result = check task:scheduleOneTimeJob(self, scheduledTime);
    }
}
