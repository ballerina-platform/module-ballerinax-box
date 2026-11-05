// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string accessToken = isLiveServer ? os:getEnv("BOX_ACCESS_TOKEN") : "test_token";
final string serviceUrl = isLiveServer ? "https://api.box.com/2.0" : "http://localhost:9090";

final Client box = check new ({auth: {token: accessToken}, httpVersion: http:HTTP_1_1}, serviceUrl);

final string FILE_ID = isLiveServer ? os:getEnv("BOX_FILE_ID") : "12345";
final string FOLDER_ID = isLiveServer ? os:getEnv("BOX_FOLDER_ID") : "22222";
const string USER_ID = "33333";

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetFileInformation() returns error? {
    FileFull? response = check box->getFileInformation(FILE_ID);
    test:assertEquals(response?.id, FILE_ID);
    test:assertEquals(response?.'type, "file");
}

@test:Config {groups: ["mock_tests"]}
function testUpdateFile() returns error? {
    FileFull response = check box->updateFile(FILE_ID, {name: "Renamed Report.pdf"});
    test:assertEquals(response.id, FILE_ID);
}

@test:Config {groups: ["mock_tests"]}
function testCopyFile() returns error? {
    FileFull? response = check box->copyFile(FILE_ID, {parent: {id: FOLDER_ID}, name: "Report Copy.pdf"});
    test:assertTrue(response is FileFull);
}

@test:Config {groups: ["mock_tests"]}
function testDeleteGroup() returns error? {
    if isLiveServer {
        return;
    }
    GroupFull group = check box->createGroup({name: "Group To Delete"});
    check box->removeGroup(group.id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetFolderInformation() returns error? {
    FolderFull? response = check box->getFolderInformation(FOLDER_ID);
    test:assertEquals(response?.id, FOLDER_ID);
    test:assertEquals(response?.'type, "folder");
}

@test:Config {groups: ["mock_tests"]}
function testCreateFolder() returns error? {
    FolderFull response = check box->createFolder({name: "Archive", parent: {id: "0"}});
    test:assertEquals(response.name, "Archive");
}

@test:Config {groups: ["mock_tests"]}
function testUpdateFolder() returns error? {
    FolderFull response = check box->updateFolder(FOLDER_ID, {name: "Finance Archive"});
    test:assertEquals(response.id, FOLDER_ID);
}

@test:Config {groups: ["mock_tests"]}
function testDeleteFolder() returns error? {
    if isLiveServer {
        return;
    }
    FolderFull folder = check box->createFolder({name: "Folder To Delete", parent: {id: "0"}});
    check box->deleteFolder(folder.id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListItemsInFolder() returns error? {
    Items response = check box->listItemsInFolder("0");
    test:assertTrue((response.entries ?: []).length() >= 0);
}

@test:Config {groups: ["mock_tests"]}
function testCreateComment() returns error? {
    CommentFull response = check box->createComment({message: "Great work!", item: {id: FILE_ID, 'type: "file"}});
    test:assertEquals(response.message, "Great work!");
}

@test:Config {groups: ["mock_tests"]}
function testGetComment() returns error? {
    CommentFull response = check box->getComment("11111");
    test:assertEquals(response.id, "11111");
}

@test:Config {groups: ["mock_tests"]}
function testListFileComments() returns error? {
    Comments response = check box->listFileComments(FILE_ID);
    test:assertTrue((response.entries ?: []).length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testCreateTask() returns error? {
    Task response = check box->createTask({item: {id: FILE_ID, 'type: "file"}, action: "review", message: "Review the report"});
    test:assertTrue(response.id is string);
}

@test:Config {groups: ["mock_tests"]}
function testGetTask() returns error? {
    Task response = check box->getTask("66666");
    test:assertEquals(response.id, "66666");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListEnterpriseUsers() returns error? {
    Users response = check box->listEnterpriseUsers();
    test:assertTrue((response.entries ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCurrentUser() returns error? {
    UserFull response = check box->getCurrentUser();
    test:assertEquals(response.'type, "user");
}

@test:Config {groups: ["mock_tests"]}
function testCreateUser() returns error? {
    UserFull response = check box->createUser({name: "Carol White", login: "carol@example.com"});
    test:assertEquals(response.name, "Carol White");
}

@test:Config {groups: ["mock_tests"]}
function testGetUser() returns error? {
    UserFull response = check box->getUser(USER_ID);
    test:assertEquals(response.id, USER_ID);
}

@test:Config {groups: ["mock_tests"]}
function testDeleteUser() returns error? {
    if isLiveServer {
        return;
    }
    UserFull user = check box->createUser({name: "User To Delete", login: "delete.me@example.com"});
    check box->deleteUser(user.id);
}

@test:Config {groups: ["mock_tests"]}
function testCreateGroup() returns error? {
    GroupFull response = check box->createGroup({name: "Engineering"});
    test:assertEquals(response.name, "Engineering");
}

@test:Config {groups: ["mock_tests"]}
function testGetGroup() returns error? {
    GroupFull response = check box->getGroup("55555");
    test:assertEquals(response.id, "55555");
}

@test:Config {groups: ["mock_tests"]}
function testCreateCollaboration() returns error? {
    Collaboration response = check box->createCollaboration({
        item: {id: FOLDER_ID, 'type: "folder"},
        accessibleBy: {id: USER_ID, 'type: "user"},
        role: "editor"
    });
    test:assertEquals(response.'type, "collaboration");
}

@test:Config {groups: ["mock_tests"]}
function testCreateWebhook() returns error? {
    Webhook response = check box->createWebhook({
        target: {id: FOLDER_ID, 'type: "folder"},
        address: "https://example.com/webhooks/box",
        triggers: ["FILE.UPLOADED"]
    });
    test:assertEquals(response.address, "https://example.com/webhooks/box");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchForContent() returns error? {
    SearchResultsResponse response = check box->searchForContent(query = "report");
    test:assertTrue(response is SearchResults);
    if !isLiveServer && response is SearchResults {
        test:assertEquals((response.entries ?: []).length(), 1);
    }
}

@test:Config {groups: ["mock_tests"]}
function testCreateWebLink() returns error? {
    WebLink response = check box->createWebLink({url: "https://developer.box.com", parent: {id: "0"}, name: "Box Developer Docs"});
    test:assertEquals(response.'type, "web_link");
}
