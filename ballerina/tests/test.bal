// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is auto-generated by the Ballerina OpenAPI tool.

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

import ballerina/test;

// Configurable variables for environment setup.
configurable boolean isLiveServer = ?;
configurable string token = ?;
configurable string serviceUrl = isLiveServer ? "https://api.openai.com/v1" : "http://localhost:9090";
configurable string apiKey = isLiveServer ? token : "";

// Initialize the connection configuration and client.
final ConnectionConfig config = {auth: {token: apiKey}};
final Client openaiFinetunes = check new Client(config, serviceUrl);

// Define sample file content and name.
final string fileName = "sample.jsonl";
const byte[] fileContent = [123,13,10,32,32,32,32,34,112,114,111,109,112,116,34,58,32,34,87,104,97,116,32,105,115,32,116,104,101,32,97,110,115,119,101,114,32,116,111,32,50,43,50,34,44,13,10,32,32,32,32,34,99,111,109,112,108,101,116,105,111,110,34,58,32,34,52,34,13,10,125];

// Record type to hold test data.
public type TestData record {
    string fileId;
    string modelId;
    string jobId;
};

// Initialize test data.
TestData testData = {fileId: "", modelId: "", jobId: ""};

// Function to generate test data.
function dataGen() returns TestData[][] {
    return [[testData]];
}

// Test case to list models.
@test:Config {
    dataProvider:  dataGen
}

isolated function testListModels(TestData testData) returns error? {

    // Fetch the list of models from the API.
    ListModelsResponse modelsResponse = check baseClient->/models.get();

    // Set modelId for further testing (hardcoded for demonstration).
    testData.modelId = "gpt-3.5-turbo";

    // Assertions to verify response correctness.
    test:assertEquals(modelsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(modelsResponse.hasKey("data"), "Response does not have the key 'data'");
}

// Test case to retrieve a specific model by ID.
@test:Config {
    dataProvider:  dataGen,
    dependsOn: [testListModels]
}
isolated function testRetrieveModel(TestData testData) returns error? {

    // Retrieve the model using the model ID.
    string modelId = testData.modelId;
    Model modelResponse = check baseClient->/models/[modelId].get();

    // Assertions to verify response correctness.
    test:assertEquals(modelResponse.id, modelId, "Model id mismatched");
    test:assertTrue(modelResponse.hasKey("object"), "Response does not have the key 'object'");
}

// Test case to delete a model.
@test:Config {
    dependsOn: [testCreateFineTuningJob, testListModels, testRetrieveModel, testListFineTuningJobCheckpoints, testListFineTuningEvents],
    dataProvider:  dataGen,
    enable: isLiveServer? false : true // Enable this test only for mock server.
}
isolated function testDeleteModel(TestData testData) returns error? {

    // Delete the model using the model ID.
    string modelIdCreated = testData.modelId;
    DeleteModelResponse modelResponseDelete = check baseClient->/models/[modelIdCreated].delete();

    // Assertions to verify response correctness.
    test:assertEquals(modelResponseDelete.id, modelIdCreated, "Model id mismatched");
    test:assertTrue(modelResponseDelete.hasKey("object"), "Response does not have the key 'object'");
}

// Files
// Test case to list all files.
@test:Config {}
isolated function testListFiles() returns error? {

    // Fetch the list of files from the API.
    ListFilesResponse filesResponse = check baseClient->/files.get();

    // Assertions to verify response correctness.
    test:assertEquals(filesResponse.'object, "list", "Object type mismatched");
    test:assertTrue(filesResponse.hasKey("data"), "Response does not have the key 'data'");
}

// Test case to create a new file.
@test:Config {
    dependsOn: [testListFiles],
    dataProvider: dataGen
}
isolated function testCreateFile(TestData testData) returns error? {

    // Prepare the request to create a new file.
    CreateFileRequest fileRequest = {
        file: {fileContent, fileName},
        purpose: "fine-tune"
    };

    // Send the request to create the file.
    OpenAIFile fileResponse = check baseClient->/files.post(fileRequest);

    // Store the file ID for subsequent tests.
    testData.fileId = fileResponse.id;

    // Assertions to verify response correctness.
    test:assertEquals(fileResponse.purpose, "fine-tune", "Purpose mismatched");
    test:assertTrue(fileResponse.id !is "", "File id is empty");
}

// Test case to retrieve details of a specific file.
@test:Config {
    dependsOn: [testCreateFile],
    dataProvider:  dataGen
}
isolated function testRetrieveFile(TestData testData) returns error? {

    // Retrieve the file details using the file ID.
    string fileId = testData.fileId;
    OpenAIFile fileResponse = check baseClient->/files/[fileId].get();

    // Assertions to verify response correctness.
    test:assertEquals(fileResponse.id, fileId, "File id mismatched");
    test:assertTrue(fileResponse.hasKey("object"), "Response does not have the key 'object'");
}

// Test case to download a file's content.
@test:Config {
    dependsOn: [testCreateFile],
    dataProvider:  dataGen
}
isolated function testDownloadFile(TestData testData) returns error? {

    // Download the content of the file using the file ID.
    string fileId = testData.fileId;
    byte[] fileContentDownload = check baseClient->/files/[fileId]/content.get();

    // Assertions to verify response correctness.
    test:assertFalse(fileContentDownload.length() <= 0, "File content is empty");

}

// Test case to delete a specific file.
@test:Config {
    dependsOn: [testCreateFile, testRetrieveFile, testDownloadFile, testCreateFineTuningJob],
    dataProvider:  dataGen
}
isolated function testDeleteFile(TestData testData) returns error? {
    
    // Delete the file using the file ID.
    string fileId = testData.fileId;
    DeleteFileResponse fileResponseDelete = check baseClient->/files/[fileId].delete();

    // Assertions to verify response correctness.
    test:assertEquals(fileResponseDelete.id, fileId, "File id mismatched");
    test:assertTrue(fileResponseDelete.hasKey("object"), "Response does not have the key 'object'");
}


// Fine Tuning Jobs
// Test case to list all fine-tuning jobs with pagination.
@test:Config {}
isolated function testListPaginatedFineTuningJobs() returns error? {

    // Fetch the list of fine-tuning jobs from the API.
    ListPaginatedFineTuningJobsResponse jobsResponse = check baseClient->/fine_tuning/jobs.get();

    // Assertions to verify response correctness.
    test:assertEquals(jobsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(jobsResponse.hasKey("data"), "Response does not have the key 'data'");
}

// Test case to create a new fine-tuning job.
@test:Config {
    dependsOn: [testListModels, testCreateFile],
    dataProvider:  dataGen
}
isolated function testCreateFineTuningJob(TestData testData) returns error? {

    // Retrieve the file ID and model ID from the test data.
    string fileId = testData.fileId;
    string modelId = testData.modelId;

    // Prepare the request to create a fine-tuning job.
    CreateFineTuningJobRequest fineTuneRequest = {
        model: modelId,
        training_file: fileId
    };

    // Send the request to create the fine-tuning job.
    FineTuningJob fineTuneResponse = check baseClient->/fine_tuning/jobs.post(fineTuneRequest);

    // Store the job ID for subsequent tests.
    testData.jobId = fineTuneResponse.id;

    // Assertions to verify response correctness.
    test:assertTrue(fineTuneResponse.hasKey("object"), "Response does not have the key 'object'");
    test:assertTrue(fineTuneResponse.hasKey("id"), "Response does not have the key 'id'");
}

// Test case to retrieve details of a specific fine-tuning job.
@test:Config {
    dependsOn: [testCreateFineTuningJob],
    dataProvider:  dataGen
}
isolated function testRetrieveFineTuningJob(TestData testData) returns error? {

    // Retrieve the fine-tuning job details using the job ID.
    string jobId = testData.jobId;
    FineTuningJob jobResponse = check baseClient->/fine_tuning/jobs/[jobId].get();

    // Assertions to verify response correctness.
    test:assertEquals(jobResponse.id, jobId, "Job id mismatched");
    test:assertEquals(jobResponse.'object, "fine_tuning.job", "Response does not have the key 'object'");
}

// Test case to list events associated with a fine-tuning job.
@test:Config {
    dependsOn: [testCreateFineTuningJob],
    dataProvider:  dataGen
}
isolated function testListFineTuningEvents(TestData testData) returns error? {

    // Retrieve the fine-tuning job ID from the test data.
    string fine_tuning_job_id = testData.jobId;

    // Fetch the list of events for the fine-tuning job.
    ListFineTuningJobEventsResponse eventsResponse = check baseClient->/fine_tuning/jobs/[fine_tuning_job_id]/events.get();

    // Assertions to verify response correctness.
    test:assertEquals(eventsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(eventsResponse.hasKey("data"), "Response does not have the key 'data'");
}

// Test case to list checkpoints of a fine-tuning job.
@test:Config {
    dependsOn: [testCreateFineTuningJob],
    dataProvider:  dataGen
}
isolated function testListFineTuningJobCheckpoints(TestData testData) returns error? {

    // Retrieve the fine-tuning job ID from the test data.
    string fine_tuning_job_id = testData.jobId;

    // Fetch the list of checkpoints for the fine-tuning job.
    ListFineTuningJobCheckpointsResponse checkpointsResponse = check baseClient->/fine_tuning/jobs/[fine_tuning_job_id]/checkpoints.get();

    // Assertions to verify response correctness.
    test:assertEquals(checkpointsResponse.'object, "list", "Object type mismatched");
    test:assertTrue(checkpointsResponse.hasKey("data"), "Response does not have the key 'data'");
}

// Test case to cancel a fine-tuning job.
@test:Config {
    dependsOn: [testCreateFineTuningJob],
    dataProvider:  dataGen,
    enable: isLiveServer? false : true // Enable this test only for mock server.
}
isolated function testCancelFineTuningJob(TestData testData) returns error? {

    // Retrieve the fine-tuning job ID from the test data.
    string fine_tuning_job_id = testData.jobId;

    // Send the request to cancel the fine-tuning job.
    FineTuningJob jobResponse = check baseClient->/fine_tuning/jobs/[fine_tuning_job_id]/cancel.post();

    // Assertions to verify response correctness.
    test:assertEquals(jobResponse.id, fine_tuning_job_id, "Job id mismatched");
    test:assertTrue(jobResponse.hasKey("object"), "Response does not have the key 'object'");
}
