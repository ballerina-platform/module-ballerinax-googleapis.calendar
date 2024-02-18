# Work schedule management with Google Calendar API

This example demonstrates the use of the Google Calendar API in Ballerina to efficiently manage work schedules, interacting with various tasks related to scheduling and organizing work-related events and meetings.

## Step 1: Import Google Calendar module

Import the `ballerinax/googleapis.gcalendar` module.

```ballerina
import ballerinax/googleapis.gcalendar;
```

## Step 2: Create a new connector instance

Create a `gcalendar:ConnectionConfig` with the obtained OAuth 2.0 tokens, and initialize the connector with it.

```ballerina
gcalendar:ConnectionConfig config = {
    auth: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,
    }
};

gcalendar:Client calendar = check new(config);
```

Now, the `gcalendar:Client` instance can be used for the following steps.

### Creating a work calendar

Create a dedicated calendar to organize work events.

```ballerina
gcalendar:Calendar calendarResult = check calendar->/calendars.post({
    summary: "Work Schedule"
});
```

### Scheduling work events

Schedule work-related events, meetings, and deadlines by specifying the event's title, date, time, and time zone, as well as any other relevant details.

```ballerina
gcalendar:Event event = check calendar->/calendars/[calendarId]/events.post({
    'start: {
        dateTime: "2023-10-19T09:00:00+05:30",
        timeZone: "Asia/Colombo"
    },
    end: {
        dateTime: "2023-10-19T09:30:00+05:30",
        timeZone: "Asia/Colombo"
    },
    summary: "Project Kickoff Meeting"
});
```

### Managing invitations and notifications

Invite attendees by email, sending out invitations and notifications to ensure that all participants receive the necessary information.

```ballerina
gcalendar:Event updatedEvent = check calendar->/calendars/[calendarId]/events/[eventId].put({
    'start: {
        dateTime: "2023-10-19T09:00:00+05:30",
        timeZone: "Asia/Colombo"
    },
    end: {
        dateTime: "2023-10-19T09:30:00+05:30",
        timeZone: "Asia/Colombo"
    },
    summary: "Team Meeting",
    location: "Conference Room",
    description: "Weekly team meeting to discuss project status.",
    attendees: [
        {
            "email": "team-member1@gmail.com"
        },
        {
            "email": "team-member2@gmail.com"
        }
    ]
});
```

### Setting recurrence and reminders

Schdule weekly team meetings as recurring events, setting reminders to ensure all team members receive timely notifications before each meeting.

```ballerina
gcalendar:Event|error reminderEvent = calendar->/calendars/[calendarId]/events/[updatedEventId].put({
    'start: {
        dateTime: "2023-10-19T03:00:00+05:30",
        timeZone: "Asia/Colombo"
    },
    end: {
        dateTime: "2023-10-19T03:30:00+05:30",
        timeZone: "Asia/Colombo"
    },
    reminders: {
        useDefault: false,
        overrides: [
            {
                method: "popup",
                minutes: 15
            },
            {
                method: "email",
                minutes: 30
            }
        ]
    }
});
```

### Sharing with team

The work calendar can be shared among project team members to facilitate efficient collaboration. Permissions, such as read-only or edit access, can be assigned to ensure the team is aware of the work schedule and can coordinate their activities.

```ballerina
gcalendar:AclRule acl = check calendar->/calendars/[calendarId]/acl.post({
    scope: {
        'type: "user",
        value: "team_member@gmail.com"
    },
    role: "reader"
});
```

### Access control

Limit access to specific events or assign different permissions to various users.

```ballerina
gcalendar:AclRule|error response = calendar->/calendars/[calendarId]/acl/[aclId].put({
    scope: {
        'type: "user",
        value: "team_member@gmail.com"
    },
    role: "writer"
});
```
