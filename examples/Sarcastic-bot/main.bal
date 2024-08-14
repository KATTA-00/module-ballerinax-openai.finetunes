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

import ballerina/io;
import ballerina/lang.runtime;
import ballerinax/openai.finetunes;

configurable string token = ?;
const SERVICE_URL = "https://api.openai.com/v1";
const TRAINING_FILENAME = "training.jsonl";
const VALIDATION_FILENAME = "validation.jsonl";
const TRAINING_FILEPATH = "./data/" + TRAINING_FILENAME;
const VALIDATION_FILEPATH = "./data/" + VALIDATION_FILENAME;

final finetunes:ConnectionConfig config = {auth: {token}};
final finetunes:Client openAIFinetunes = check new finetunes:Client(config, SERVICE_URL);

public function main() returns error? {

    byte[] trainingFileContent = check io:fileReadBytes(TRAINING_FILEPATH);
    byte[] validationFileContent = check io:fileReadBytes(VALIDATION_FILEPATH);

    finetunes:CreateFileRequest trainingFileRequest = {
        file: {fileContent: trainingFileContent, fileName: TRAINING_FILENAME},
        purpose: "fine-tune"
    };
    finetunes:CreateFileRequest validationFileRequest = {
        file: {fileContent: validationFileContent, fileName: VALIDATION_FILENAME},
        purpose: "fine-tune"
    };

    finetunes:OpenAIFile trainingFileResponse =
        check openAIFinetunes->/files.post(trainingFileRequest);
    finetunes:OpenAIFile validationFileResponse =
        check openAIFinetunes->/files.post(validationFileRequest);

    string trainingFileId = trainingFileResponse.id;
    string validationFileId = validationFileResponse.id;
    io:println("Training file id: " + trainingFileId);
    io:println("Validation file id: " + validationFileId);

    finetunes:CreateFineTuningJobRequest fineTuneRequest = {
        model: "gpt-3.5-turbo",
        training_file: trainingFileId,
        validation_file: validationFileId,
        hyperparameters: {
            n_epochs: 15,
            batch_size: 3,
            learning_rate_multiplier: 0.3
        }
    };

    finetunes:FineTuningJob fineTuneResponse =
        check openAIFinetunes->/fine_tuning/jobs.post(fineTuneRequest);
    string fineTuneJobId = fineTuneResponse.id;
    io:println("Fine-tuning job id: " + fineTuneJobId);

    finetunes:FineTuningJob fineTuneJob =
        check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();

    io:print("Validating files...");
    while fineTuneJob.status == "validating_files" {
        io:print(".");
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        runtime:sleep(1);
    }

    io:print("\nFiles validated successfully.");
    while fineTuneJob.status == "queued" {
        io:print(".");
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        runtime:sleep(1);
    }

    io:println("\nTraining...");
    finetunes:ListFineTuningJobEventsResponse eventsResponse;
    while fineTuneJob.status == "running" {
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        eventsResponse = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId]/events.get();
        io:println(eventsResponse.data[0].message);
        runtime:sleep(1);
    }

    if fineTuneJob.status != "succeeded" {
        io:println("Fine-tuning job failed.");
        return;
    }

    io:println("\nFine-tuning job details: ");
    io:println("Fine-tuned Model: ", fineTuneJob.fine_tuned_model);
    io:println("Model: ", fineTuneJob.model);
    io:println("Fine-tuning job completed successfully.");
}
