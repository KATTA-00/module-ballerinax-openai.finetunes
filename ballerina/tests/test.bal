// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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

import ballerina/os;
import ballerina/test;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string token = isLiveServer ? os:getEnv("OPENAI_API_KEY") : "";
configurable string serviceUrl = isLiveServer ? "https://api.openai.com/v1" : "http://localhost:9090";

final ConnectionConfig config = {
    auth: {
        token
    }
};
final Client openAIFinetunes = check new Client(config, serviceUrl);

const string fileName = "sample.jsonl";
const byte[] fileContent = [123, 34, 109, 101, 115, 115, 97, 103, 101, 115, 34, 58, 32, 91, 123, 34, 114, 111, 108, 101, 34, 58, 32, 34, 117, 115, 101, 114, 34, 44, 32, 34, 99, 111, 110, 116, 101, 110, 116, 34, 58, 32, 34, 87, 104, 97, 116, 32, 105, 115, 32, 116, 104, 101, 32, 99, 97, 112, 105, 116, 97, 108, 32, 111, 102, 32, 70, 114, 97, 110, 99, 101, 63, 34, 125, 44, 32, 123, 34, 114, 111, 108, 101, 34, 58, 32, 34, 97, 115, 115, 105, 115, 116, 97, 110, 116, 34, 44, 32, 34, 99, 111, 110, 116, 101, 110, 116, 34, 58, 32, 34, 84, 104, 101, 32, 99, 97, 112, 105, 116, 97, 108, 32, 111, 102, 32, 70, 114, 97, 110, 99, 101, 32, 105, 115, 32, 80, 97, 114, 105, 115, 46, 34, 125, 93, 125, 13, 10, 123, 34, 109, 101, 115, 115, 97, 103, 101, 115, 34, 58, 32, 91, 123, 34, 114, 111, 108, 101, 34, 58, 32, 34, 117, 115, 101, 114, 34, 44, 32, 34, 99, 111, 110, 116, 101, 110, 116, 34, 58, 32, 34, 87, 104, 97, 116, 32, 105, 115, 32, 116, 104, 101, 32, 112, 114, 105, 109, 97, 114, 121, 32, 102, 117, 110, 99, 116, 105, 111, 110, 32, 111, 102, 32, 116, 104, 101, 32, 104, 101, 97, 114, 116, 63, 34, 125, 44, 32, 123, 34, 114, 111, 108, 101, 34, 58, 32, 34, 97, 115, 115, 105, 115, 116, 97, 110, 116, 34, 44, 32, 34, 99, 111, 110, 116, 101, 110, 116, 34, 58, 32, 34, 84, 104, 101, 32, 112, 114, 105, 109, 97, 114, 121, 32, 102, 117, 110, 99, 116, 105, 111, 110, 32, 111, 102, 32, 116, 104, 101, 32, 104, 101, 97, 114, 116, 32, 105, 115, 32, 116, 111, 32, 112, 117, 109, 112, 32, 98, 108, 111, 111, 100, 32, 116, 104, 114, 111, 117, 103, 104, 111, 117, 116, 32, 116, 104, 101, 32, 98, 111, 100, 121, 46, 34, 125, 93, 125, 13, 10];
string modelId = "gpt-3.5-turbo";
string fileId = "";
string jobId = "";

@test:Config {
    groups: ["models", "live_tests", "mock_tests"]
}
function testListModels() returns error? {
    ListModelsResponse modelsResponse = check openAIFinetunes->/models.get();
    test:assertEquals(modelsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(modelsResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {
    dependsOn: [testListModels],
    groups: ["models", "live_tests", "mock_tests"]
}
function testRetrieveModel() returns error? {
    Model modelResponse = check openAIFinetunes->/models/[modelId].get();
    test:assertEquals(modelResponse.id, modelId, "Model id mismatched");
    test:assertTrue(modelResponse.hasKey("object"), "Response does not have the key 'object'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob, testListModels, testRetrieveModel, testListFineTuningJobCheckpoints, testListFineTuningEvents],
    enable: isLiveServer ? false : true, // Enable this test only for mock server.
    groups: ["models", "mock_tests"]
}
function testDeleteModel() returns error? {
    DeleteModelResponse modelResponseDelete = check openAIFinetunes->/models/[modelId].delete();
    test:assertEquals(modelResponseDelete.id, modelId, "Model id mismatched");
    test:assertTrue(modelResponseDelete.hasKey("object"), "Response does not have the key 'object'");
}

@test:Config {
    groups: ["files", "live_tests", "mock_tests"]
}
function testListFiles() returns error? {
    ListFilesResponse filesResponse = check openAIFinetunes->/files.get();
    test:assertEquals(filesResponse.'object, "list", "Object type mismatched");
    test:assertTrue(filesResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {
    dependsOn: [testListFiles],
    groups: ["files", "live_tests", "mock_tests"]
}
function testCreateFile() returns error? {
    CreateFileRequest fileRequest = {
        file: {fileContent, fileName},
        purpose: "fine-tune"
    };

    OpenAIFile fileResponse = check openAIFinetunes->/files.post(fileRequest);
    fileId = fileResponse.id;
    test:assertEquals(fileResponse.purpose, "fine-tune", "Purpose mismatched");
    test:assertTrue(fileResponse.id !is "", "File id is empty");
}

@test:Config {
    dependsOn: [testCreateFile],
    groups: ["files", "live_tests", "mock_tests"]
}
function testRetrieveFile() returns error? {
    OpenAIFile fileResponse = check openAIFinetunes->/files/[fileId].get();
    test:assertEquals(fileResponse.id, fileId, "File id mismatched");
    test:assertTrue(fileResponse.hasKey("object"), "Response does not have the key 'object'");
}

@test:Config {
    dependsOn: [testCreateFile],
    groups: ["files", "live_tests", "mock_tests"]
}
function testDownloadFile() returns error? {
    byte[] fileContentDownload = check openAIFinetunes->/files/[fileId]/content.get();
    test:assertFalse(fileContentDownload.length() <= 0, "File content is empty");
}

@test:Config {
    dependsOn: [testCreateFile, testRetrieveFile, testDownloadFile, testCreateFineTuningJob],
    groups: ["files", "live_tests", "mock_tests"]
}
function testDeleteFile() returns error? {
    DeleteFileResponse fileResponseDelete = check openAIFinetunes->/files/[fileId].delete();
    test:assertEquals(fileResponseDelete.id, fileId, "File id mismatched");
    test:assertTrue(fileResponseDelete.hasKey("object"), "Response does not have the key 'object'");
}

@test:Config {
    groups: ["fine-tuning", "live_tests", "mock_tests"]
}
function testListPaginatedFineTuningJobs() returns error? {
    ListPaginatedFineTuningJobsResponse jobsResponse = check openAIFinetunes->/fine_tuning/jobs.get();
    test:assertEquals(jobsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(jobsResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {
    dependsOn: [testListModels, testCreateFile],
    groups: ["fine-tuning", "live_tests", "mock_tests"]
}
function testCreateFineTuningJob() returns error? {
    CreateFineTuningJobRequest fineTuneRequest = {
        model: modelId,
        trainingFile: fileId
    };

    FineTuningJob fineTuneResponse = check openAIFinetunes->/fine_tuning/jobs.post(fineTuneRequest);
    jobId = fineTuneResponse.id;
    test:assertTrue(fineTuneResponse.hasKey("object"), "Response does not have the key 'object'");
    test:assertTrue(fineTuneResponse.hasKey("id"), "Response does not have the key 'id'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob],
    groups: ["fine-tuning", "live_tests", "mock_tests"]
}
function testRetrieveFineTuningJob() returns error? {
    FineTuningJob jobResponse = check openAIFinetunes->/fine_tuning/jobs/[jobId].get();
    test:assertEquals(jobResponse.id, jobId, "Job id mismatched");
    test:assertEquals(jobResponse.'object, "fine_tuning.job", "Response does not have the key 'object'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob],
    groups: ["fine-tuning", "live_tests", "mock_tests"]
}
function testListFineTuningEvents() returns error? {
    ListFineTuningJobEventsResponse eventsResponse = check openAIFinetunes->/fine_tuning/jobs/[jobId]/events.get();
    test:assertEquals(eventsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(eventsResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob],
    groups: ["fine-tuning", "live_tests", "mock_tests"]
}
function testListFineTuningJobCheckpoints() returns error? {
    ListFineTuningJobCheckpointsResponse checkpointsResponse = check openAIFinetunes->/fine_tuning/jobs/[jobId]/checkpoints.get();
    test:assertEquals(checkpointsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(checkpointsResponse.hasKey("data"), "Response does not have the key 'data'");
}

@test:Config {
    dependsOn: [testCreateFineTuningJob],
    enable: isLiveServer ? false : true, // Enable this test only for mock server.
    groups: ["fine-tuning", "mock_tests"]
}
function testCancelFineTuningJob() returns error? {
    FineTuningJob jobResponse = check openAIFinetunes->/fine_tuning/jobs/[jobId]/cancel.post();
    test:assertEquals(jobResponse.id, jobId, "Job id mismatched");
    test:assertTrue(jobResponse.hasKey("object"), "Response does not have the key 'object'");
}
