// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/jwt;

const string OAUTH_URL = "https://oauth2.googleapis.com";

# Defines the OAuth2 handler for client authentication.
isolated class ClientOAuth2ExtensionGrantHandler {

    private final OAuth2ExtensionGrantProvider provider;

    public isolated function init(jwt:IssuerConfig? config = ()) returns error? {
        self.provider = check new (config);
        return;
    }

    # Returns the headers map with the relevant authentication requirements.
    #
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + headers - The headers map to be enriched with the OAuth2 token
    # + return - The updated headers map or else an `Error` in case of an error
    public isolated function getSecurityHeaders(string? userAccount, map<string|string[]> headers) returns error? {
        if userAccount !is string {
            return error("User account is not provided.");
        }
        string|error result = self.provider.generateToken(userAccount);
        if result is string {
            headers[http:AUTH_HEADER] = http:AUTH_SCHEME_BEARER + " " + result;
        } else {
            return error("Failed to enrich headers with OAuth2 token.", result);
        }
    }

    isolated function isServiceAccount() returns boolean {
        return self.provider.getServiceAccountState();
    }
}

isolated class OAuth2ExtensionGrantProvider {

    private jwt:IssuerConfig jwtIssuerConfig = {};
    private boolean isServiceAccount = false;
    private final http:Client clientEndpoint;

    public isolated function init(jwt:IssuerConfig? config) returns error? {
        self.clientEndpoint = check new (OAUTH_URL);
        if config is jwt:IssuerConfig {
            self.jwtIssuerConfig = config.clone();
            self.isServiceAccount = true;
        }
        return;
    }

    # Get an OAuth2 access token from authorization server for the OAuth2 authentication.
    #
    # + userAccount - The email address of the user for requesting delegated access in service account
    # + return - Generated OAuth2 token or else an `Error` if an error occurred
    public isolated function generateToken(string userAccount) returns string|error {
        lock {
            self.jwtIssuerConfig.customClaims["sub"] = userAccount;
            string|jwt:Error jwt = jwt:issue(self.jwtIssuerConfig);
            if jwt is string {
                json payload = {"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer", "assertion": jwt};
                http:Response|http:ClientError response = self.clientEndpoint->post("/token", payload);
                if response is http:Response {
                    return extractAccessToken(response);
                } else {
                    return error("Failed to call the token endpoint.", response);
                }
            }
            return error("Failed to generate JWT.", <error>jwt);
        }
    }

    isolated function getServiceAccountState() returns boolean {
        lock {
            return self.isServiceAccount;
        }
    }
}

isolated function extractAccessToken(http:Response response) returns string|error {
    json|error jsonResponse = response.getJsonPayload();
    if jsonResponse is json {
        json|error accessToken = jsonResponse.access_token;
        if accessToken is json {
            return accessToken.toJsonString();
        } else {
            return error("Failed to access 'access_token' property from the JSON.", accessToken);
        }
    } else {
        return error("Failed to retrieve access-token since the response payload is not a JSON.", jsonResponse);
    }
}
