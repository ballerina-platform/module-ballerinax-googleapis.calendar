# Running Tests

There are two test environments for the Google Calendar connector. The default test environment is the mock server for Calendar API. The other test environment is testing against the actual Calendar API endpoint. You can run the tests in either of these environments and each has its own compatible set of tests.

   Groups | Environment
   ---| ---
   mock | Mock server
   calendar | Calendar API

## Running Tests in the Mock Server

To execute the tests on the mock server, ensure that the `IS_TEST_ON_LIVE_SERVER` environment variable is either set to false or unset before initiating the tests.

You can set your authentication credentials as environment variables:
```bash
export IS_TEST_ON_LIVE_SERVER=false
```

Then, run the following command to run the tests:
```bash
   ./gradlew clean test
```

## Running Tests against Calendar API


You can set your authentication credentials as environment variables:
```bash
export IS_TEST_ON_LIVE_SERVER=true
export CLIENT_ID="<your-google-account-client-id>"
export CLIENT_SECRET="<your-google-account-client-secret>"
export REFRESH_TOKEN="<refresh-token-for-authorized-calendar-api>"
export REFRESH_URL="<refresh-url>"
```

Then, run the following command to run the tests:
```bash
   ./gradlew clean test -Pgroups="live"
```
