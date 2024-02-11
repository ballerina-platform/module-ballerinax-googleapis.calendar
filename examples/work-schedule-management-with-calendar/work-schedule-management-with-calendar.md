# Work Schedule Management with Google Calendar API

Sarah relies on the Google Calendar API to efficiently manage her work schedule. Her application interacts with the API for various tasks related to scheduling and organizing work-related events and meetings.

## Step 1: Import connector

Import the `ballerinax/googleapis.gcalendar` package.

```ballerina
import ballerinax/googleapis.gcalendar;
```

## Step 2: Create a new connector instance

Create a `gcalendar:ConnectionConfig` with the OAuth2.0 tokens obtained and initialize the connector with it.

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

### Creating a Work Calendar

To keep her work events organized, Sarah's application creates a dedicated calendar. It sets the calendar's title, ensuring clarity for work-related events.

```ballerina
gcalendar:Calendar calendarResult = check calendar->createCalendar({
    summary: "Work Schedule"
});
```

### Scheduling Work Events

Sarah's application empowers her to schedule work-related events, meetings, and deadlines using the Google Calendar API. It specifies the event's title, date, time, and time zone, ensuring all details are accurately captured.

```ballerina
gcalendar:Event event = check calendar->createEvent(<string>calendarResult.id, {
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

### Managing Invitations and Notifications

When Sarah schedules meetings, her application uses the Google Calendar API to invite attendees by email. It sends out invitations and notifications, ensuring that all participants receive the necessary information.

```ballerina
gcalendar:Event updatedEvent = check calendar->updateEvent(<string>calendarResult.id, <string>event.id, {
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

### Setting Recurrence and Reminders

Sarah's application allows her to schedule weekly team meetings as recurring events. It also sets reminders to ensure that all team members receive timely notifications before each meeting.

### Updating and Deleting Events

In case there are changes to a meeting schedule or cancellations, Sarah's application leverages the API to update or delete events in her calendar. Attendees are automatically notified of any changes, ensuring everyone stays informed.

```ballerina
gcalendar:Event|error reminderEvent = calendar->updateEvent(<string>calendarResult.id, <string>updatedEvent.id, {
    'start: {
        dateTime: "2023-10-19T09:00:00+05:30",
        timeZone: "Asia/Colombo"
    },
    end: {
        dateTime: "2023-10-19T09:30:00+05:30",
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

### Sharing with Team

To ensure efficient collaboration, Sarah shares her work calendar with her project team members. She assigns appropriate permissions, such as read-only or edit access, to make sure the team is aware of her schedule and can coordinate their activities.

```ballerina
gcalendar:AclRule acl = check calendar->createAclRule(<string>calendarResult.id, {
    scope: {
        'type: "user",
        value: "team-member@gmail.com"
    },
    role: "reader"
});
```

### Access Control

If necessary, Sarah can fine-tune access to her calendar using the API. For instance, she might restrict access to specific events or grant different permissions to different users.

```ballerina
gcalendar:AclRule|error response = calendar->updateAclRule(<string>calendarResult.id, <string>acl.id, {
    scope: {
        'type: "user",
        value: "colleague@gmail.com"
    },
    role: "writer"
});
```
