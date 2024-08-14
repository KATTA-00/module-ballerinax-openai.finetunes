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
string serviceUrl = "https://api.openai.com/v1";
string trainingFileName = "training.jsonl";
string trainingFilePath = "./data/" + trainingFileName;

final finetunes:ConnectionConfig config = {auth: {token}};
final finetunes:Client openAIFinetunes = check new finetunes:Client(config, serviceUrl);

public function main() returns error? {

    byte[] trainingFileContent = check io:fileReadBytes(trainingFilePath);

    finetunes:CreateFileRequest trainingFileRequest = {
        file: {fileContent: trainingFileContent, fileName: trainingFileName},
        purpose: "fine-tune"
    };

    finetunes:OpenAIFile trainingFileResponse =
        check openAIFinetunes->/files.post(trainingFileRequest);

    string trainingFileId = trainingFileResponse.id;
    io:println("Training file id: " + trainingFileId);

    finetunes:CreateFineTuningJobRequest fineTuneRequest = {
        model: "gpt-4o-mini-2024-07-18",
        training_file: trainingFileId,
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
    while (fineTuneJob.status == "validating_files") {
        io:print(".");
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        runtime:sleep(1);
    }

    io:print("\nFiles validated successfully.");
    while (fineTuneJob.status == "queued") {
        io:print(".");
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        runtime:sleep(1);
    }

    io:print("\nTraining...");
    while (fineTuneJob.status == "running") {
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        io:print(".");
        runtime:sleep(1);
    }

    if fineTuneJob.status != "succeeded" {
        io:println("Fine-tuning job failed.");
        finetunes:DeleteFileResponse deleteFileResponse =
            check openAIFinetunes->/files/[trainingFileId].delete();
        if (deleteFileResponse.deleted == true) {
            io:println("Training file deleted successfully.");
        } else {
            io:println("Failed to delete the training file.");
        }

        return;
    }

    io:println("\n");
    finetunes:ListFineTuningJobCheckpointsResponse checkpointsResponse =
        check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId]/checkpoints.get();

    foreach finetunes:FineTuningJobCheckpoint item in checkpointsResponse.data.reverse() {
        io:print("step: ", item.metrics.step);
        io:print(", train loss: ", item.metrics.train_loss);
        io:println(", train mean token accuracy: ", item.metrics.train_mean_token_accuracy);
    }

    io:println("\nFine-tuning job details: ");
    io:println("Fine-tuned Model: ", fineTuneJob.fine_tuned_model);
    io:println("Model: ", fineTuneJob.model);
    io:println("Fine-tuning job completed successfully.");

    finetunes:DeleteFileResponse deleteFileResponse =
        check openAIFinetunes->/files/[trainingFileId].delete();
    if (deleteFileResponse.deleted == true) {
        io:println("Training file deleted successfully.");
    } else {
        io:println("Failed to delete the training file.");
    }
}
