# Examples

This directory contains a collection of sample code examples written in Ballerina. These examples demonstrate various
use cases of the module. You can follow the instructions below to build and run these examples.

## Running an Example

Execute the following commands to build an example from the source.

* To build an example

  `bal build <example-name>`

* To run an example

  `bal run <example-name>`

## Building the Examples with the Local Module

**Warning**: Because of the absence of support for reading local repositories for single Ballerina files, the bala of
the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your
local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally.

* To build all the examples

  `./build.sh build`

* To run all the examples

  `./build.sh run`

## Scenario 01: Sarah's Work Schedule Management with Google Calendar API

Sarah relies on the Google Calendar API to efficiently manage her work schedule. Her application interacts with the API for various tasks related to scheduling and organizing work-related events and meetings.

### Step 1: Import connector

Import the `ballerinax/googleapis.calendar` module into the Ballerina project.

```ballerina
import ballerinax/googleapis.calendar;
```

### Step 2: Create a new connector instance

Create a `calendar:ConnectionConfig` with the OAuth2.0 tokens obtained and initialize the connector with it.

```ballerina
calendar:ConnectionConfig config = {
    auth: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,
    }
};

calendar:Client calendarClient = check new(config);
```

Now, the `calendar:Client` instance can be used for the following steps.

#### Creating a Work Calendar

To keep her work events organized, Sarah's application creates a dedicated calendar. It sets the calendar's title, ensuring clarity for work-related events.

```ballerina
calendar:Calendar calendarResult = check calendarClient->createCalendar({
    summary: "Work Schedule"
});
```

#### Scheduling Work Events

Sarah's application empowers her to schedule work-related events, meetings, and deadlines using the Google Calendar API. It specifies the event's title, date, time, and time zone, ensuring all details are accurately captured.

```ballerina
calendar:Event event = check calendarClient->createEvent(<string>calendarResult.id, {
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

#### Managing Invitations and Notifications

When Sarah schedules meetings, her application uses the Google Calendar API to invite attendees by email. It sends out invitations and notifications, ensuring that all participants receive the necessary information.

```ballerina
calendar:Event updatedEvent = check calendarClient->updateEvent(<string>calendarResult.id, <string>event.id, {
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

#### Setting Recurrence and Reminders

Sarah's application allows her to schedule weekly team meetings as recurring events. It also sets reminders to ensure that all team members receive timely notifications before each meeting.

#### Updating and Deleting Events

In case there are changes to a meeting schedule or cancellations, Sarah's application leverages the API to update or delete events in her calendar. Attendees are automatically notified of any changes, ensuring everyone stays informed.

```ballerina
calendar:Event|error reminderEvent = calendarClient->updateEvent(<string>calendarResult.id, <string>updatedEvent.id, {
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

#### Sharing with Team

To ensure efficient collaboration, Sarah shares her work calendar with her project team members. She assigns appropriate permissions, such as read-only or edit access, to make sure the team is aware of her schedule and can coordinate their activities.

```ballerina
calendar:AclRule acl = check calendarClient->createAclRule(<string>calendarResult.id, {
    scope: {
        'type: "user",
        value: "team-member@gmail.com"
    },
    role: "reader"
});
```

#### Access Control

If necessary, Sarah can fine-tune access to her calendar using the API. For instance, she might restrict access to specific events or grant different permissions to different users.

```ballerina
calendar:AclRule|error response = calendarClient->updateAclRule(<string>calendarResult.id, <string>acl.id, {
    scope: {
        'type: "user",
        value: "colleague@gmail.com"
    },
    role: "writer"
});
```

## Scenario 02: Alex's Personal Project Management with Google Calendar API

Let's explore how Alex, a software developer, leverages the Google Calendar API in Ballerina for managing his personal project schedule and collaborating with team members.

### Step 1: Import Google Calendar Connector

Alex begins by importing the `ballerinax/googleapis.calendar` module into his Ballerina project.

```ballerina
import ballerinax/googleapis.calendar;
```

### Step 2: Create a Connector Instance

Next, Alex creates a `calendar:ConnectionConfig` with his OAuth2.0 tokens and initializes the connector.

```ballerina
calendar:ConnectionConfig config = {
    auth: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>,
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,
    }
};

calendar:Client calendarClient = check new(config);
```

### Step 3: Create a Project Calendar

To keep his project events organized, Alex's application creates a dedicated calendar with a descriptive title.

```ballerina
calendar:Calendar projectCalendar = check calendarClient->createCalendar({
    summary: "Software Project - Alex"
});
```

### Step 4: Schedule Project Tasks

Alex schedules various project-related tasks using the Google Calendar API. This includes coding sessions, design reviews, and testing phases.

```ballerina
calendar:Event codingSession = check calendarClient->createEvent(<string>projectCalendar.id, {
    'start: {
        dateTime: "2023-10-20T10:00:00+00:00",
        timeZone: "UTC"
    },
    end: {
        dateTime: "2023-10-20T12:00:00+00:00",
        timeZone: "UTC"
    },
    summary: "Code Review"
});

calendar:Event designReview = check calendarClient->createEvent(<string>projectCalendar.id, {
    'start: {
        dateTime: "2023-10-25T14:00:00+00:00",
        timeZone: "UTC"
    },
    end: {
        dateTime: "2023-10-25T16:00:00+00:00",
        timeZone: "UTC"
    },
    summary: "Design Review"
});

// More tasks scheduled...
```

### Step 5: Collaborate with Team

Alex invites team members to project events by utilizing the Google Calendar API. This ensures that everyone involved is aware of and aligned on project milestones.

```ballerina
calendar:Event updatedCodingSession = check calendarClient->updateEvent(<string>projectCalendar.id, <string>codingSession.id, {
    'start: {
        dateTime: "2023-10-20T10:00:00+00:00",
        timeZone: "UTC"
    },
    end: {
        dateTime: "2023-10-20T12:00:00+00:00",
        timeZone: "UTC"
    },
    summary: "Code Review - Team A",
    attendees: [
        {
            "email": "team-member1@gmail.com"
        },
        {
            "email": "team-member2@gmail.com"
        }
    ]
});

// Similar updates for other events...
```

### Step 6: Set Project Milestone Reminders

To stay on top of project deadlines, Alex sets reminders for important milestones using the Google Calendar API.

```ballerina
calendar:Event milestoneEvent = check calendarClient->createEvent(<string>projectCalendar.id, {
    'start: {
        dateTime: "2023-11-15T09:00:00+00:00",
        timeZone: "UTC"
    },
    end: {
        dateTime: "2023-11-15T17:00:00+00:00",
        timeZone: "UTC"
    },
    summary: "Project Beta Release"
    reminders: {
        useDefault: false,
        overrides: [
            {
                method: "popup",
                minutes: 60
            },
            {
                method: "email",
                minutes: 1440
            }
        ]
    }
});
```

### Step 7: Monitor Project Progress

Alex regularly retrieves and analyzes project events using the Google Calendar API to monitor progress and make data-driven decisions.

```ballerina
calendar:Events projectEvents = check calendarClient->getEvents(<string>projectCalendar.id, {
    'timeMin': "2023-10-01T00:00:00Z",
    'timeMax': "2023-12-31T23:59:59Z",
    'orderBy': "startTime",
    'singleEvents': true
});

// Analyze project events for progress monitoring...
```

This scenario illustrates how Alex, a software developer, utilizes the Google Calendar API in Ballerina for effective personal project management and collaboration with his team.
