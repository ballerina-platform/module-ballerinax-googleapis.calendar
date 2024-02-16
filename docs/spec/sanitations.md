# Sanitations for OpenAPI specification

_Authors_: @Nuvindu \
_Reviewers_: @shafreenAnfar @ThisaruGuruge \
_Created_: 2024/02/14 \
_Updated_: 2024/02/14 \
_Edition_: Swan Lake

## Introduction

The Ballerina Google Calendar connector facilitates integration with the [Google Calendar API V3](https://developers.google.com/calendar/api) through the generation of client code using the [OpenAPI specification](https://github.com/Nuvindu/module-ballerinax-googleapis.calendar/blob/main/docs/spec/openapi.yaml). To enhance usability, the following modifications have been applied to the original specification.

1. Descriptive parameters
Undocumented parameters in the payload parameter of various resource functions have now been provided with clear descriptions. This improvement ensures better understanding and usage of the payload within the respective resource functions.

2. Resource path removals
    * /users/{userId}/settings - This path has some odd sub paths and does not add significant usability.
    * /users/{userId}/watch & /users/{userId}/stop - This will be covered in Google PubSub

3. Response Descriptions
Previously, all responses for resource functions were labeled with a generic "Successful Response". This has been revised to align with the actual return types of the functions, providing more accurate and informative response descriptions.

4. Removal of deprecated parameters
Deprecated parameters in certain resource paths have been removed to enhance usability and streamline the connector.

## OpenAPI cli command

```bash
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina
```
