# Project management with Google Calendar API

Let's explore how Alex, a software developer, leverages the Google Calendar API in Ballerina for managing his personal project schedule and collaborating with team members.

## Step 1: Import Google Calendar Connector

Alex begins by importing the `ballerinax/googleapis.gcalendar` module into his Ballerina project.

```ballerina
import ballerinax/googleapis.gcalendar;
```

## Step 2: Create a Connector Instance

Next, Alex creates a `gcalendar:ConnectionConfig` with his OAuth2.0 tokens and initializes the connector.

```ballerina
gcalendar:ConnectionConfig config = {
    auth: {
        clientId: <CLIENT_ID>,
        clientSecret: <CLIENT_SECRET>,
        refreshToken: <REFRESH_TOKEN>,
        refreshUrl: <REFRESH_URL>,
    }
};

gcalendar:Client calendar = check new(config);
```

## Step 3: Create a Project Calendar

To keep his project events organized, Alex's application creates a dedicated calendar with a descriptive title.

```ballerina
gcalendar:Calendar projectCalendar = check calendar->createCalendar({
    summary: "Software Project - Alex"
});
```

## Step 4: Schedule Project Tasks

Alex schedules various project-related tasks using the Google Calendar API. This includes coding sessions, design reviews, and testing phases.

```ballerina
gcalendar:Event codingSession = check calendar->createEvent(<string>projectCalendar.id, {
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

gcalendar:Event designReview = check calendar->createEvent(<string>projectCalendar.id, {
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
```

## Step 5: Collaborate with Team

Alex invites team members to project events by utilizing the Google Calendar API. This ensures that everyone involved is aware of and aligned on project milestones.

```ballerina
gcalendar:Event updatedCodingSession = check calendar->updateEvent(<string>projectCalendar.id, <string>codingSession.id, {
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
```

## Step 6: Set Project Milestone Reminders

To stay on top of project deadlines, Alex sets reminders for important milestones using the Google Calendar API.

```ballerina
gcalendar:Event milestoneEvent = check calendar->createEvent(<string>projectCalendar.id, {
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

## Step 7: Monitor Project Progress

Alex regularly retrieves and analyzes project events using the Google Calendar API to monitor progress and make data-driven decisions.

```ballerina
gcalendar:Events projectEvents = check calendar->getEvents(<string>projectCalendar.id, {
    'timeMin': "2023-10-01T00:00:00Z",
    'timeMax': "2023-12-31T23:59:59Z",
    'orderBy': "startTime",
    'singleEvents': true
});
```
