# Project management with Google Calendar API

This example demonstrates the use of the Google Calendar API in Ballerina for managing a personal project schedule and collaborating with team members.

## Step 1: Import Google Calendar module

Import the `ballerinax/googleapis.gcalendar` module.

```ballerina
import ballerinax/googleapis.gcalendar;
```

## Step 2: Create a connector instance

Next, create a `gcalendar:ConnectionConfig` with OAuth2.0 tokens and initialize the connector.

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

Now, the `gcalendar:Client` instance can be used for the following steps.

## Step 3: Create a project calendar

To keep project events organized, create a dedicated calendar with a descriptive title.

```ballerina
gcalendar:Calendar projectCalendar = check calendar->createCalendar({
    summary: "Software Project - Alex"
});
```

## Step 4: Schedule project tasks

The following steps are to schedule various project-related tasks using the Google Calendar API.

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

## Step 5: Collaborate with team

Invite team members to project events ensures that everyone involved is aware of and aligned on project milestones.

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

## Step 6: Set project milestone reminders

Set reminders for important milestones.

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

## Step 7: Monitor project progress

Retrieve and analyze project events to monitor progress and make data-driven decisions.

```ballerina
gcalendar:Events projectEvents = check calendar->getEvents(<string>projectCalendar.id, {
    'timeMin': "2023-10-01T00:00:00Z",
    'timeMax': "2023-12-31T23:59:59Z",
    'orderBy': "startTime",
    'singleEvents': true
});
```
