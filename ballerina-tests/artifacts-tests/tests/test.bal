// Copyright (c) 2024 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/http;
import ballerina/test;
import ballerinax/wso2.controlplane as cp;

configurable string testURL = ?;
configurable int testPort = ?;

@test:Config {}
public function testGetBallerinaNode() returns error? {
    http:Client icpClient = check new (testURL,
        secureSocket = {
            enable: false
        }
    );
    cp:Node|error node = icpClient->get("management");
    test:assertTrue(node is cp:Node, "Invalid response received");
}

@test:Config {}
public function testGetBallerinaArtifacts() returns error? {
    http:Client rmClient = check new (testURL,
        secureSocket = {
            enable: false
        }
    );
    cp:Artifacts|error artifacts = rmClient->get("management/Service");
    test:assertTrue(artifacts is cp:Artifacts, "Invalid response received");
    test:assertTrue(artifacts.count() == 1, "No services found");
}

service /hello on new http:Listener(testPort) {
    resource function get greeting() returns string {
        return "Hello, World!";
    }
}
