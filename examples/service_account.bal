// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerinax/googleapis.calendar;

configurable string issuer = ?;
configurable string audience = ?;
configurable string scope = ?;
configurable string path = ?;
configurable string password = ?;
configurable string keyAlias = ?;
configurable string keyPassword = ?;
configurable string calendarId = ?;
configurable string userAccount = ?;

calendar:ConnectionConfig config = {
    auth: {
        issuer: issuer,
        audience: audience,
        customClaims: {"scope": scope},
        signatureConfig: {
            config: {
                keyStore: {
                    path: path,
                    password: password
                },
                keyAlias: keyAlias,
                keyPassword: keyPassword
            }}
    }
};

calendar:Client calendarClient = check new(config);

string title = "Sample Event";

public function main() returns error? {
    calendar:Event response = check calendarClient->quickAddEvent(calendarId, title, userAccount = userAccount);
}
