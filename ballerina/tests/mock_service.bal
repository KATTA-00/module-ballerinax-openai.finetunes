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

import ballerina/http;
import ballerina/log;

public type OkFineTuningJob record {|
    *http:Ok;
    FineTuningJob body;
    map<string|string[]> headers;
|};

public type OkOpenAIFile record {|
    *http:Ok;
    OpenAIFile body;
    map<string|string[]> headers;
|};

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {

    # Delete a fine-tuned model. You must have the Owner role in your organization to delete a model.
    #
    # + model - The model to delete
    # + return - OK
    resource function delete models/[string model]() returns DeleteModelResponse {

        DeleteModelResponse response = {
            'object: "model",
            id: model,
            deleted: true
        };

        return response;
    }

    # Immediately cancel a fine-tune job.
    #
    # + fine_tuning_job_id - The ID of the fine-tuning job to cancel.
    # + return - OK
    resource function post fine_tuning/jobs/[string fine_tuning_job_id]/cancel() returns OkFineTuningJob {

        OkFineTuningJob response = {
            body: {
                'object: "fine_tuning.job",
                id: fine_tuning_job_id,
                model: "gpt-3.5-turbo-0125",
                createdAt: 1723110882,
                finishedAt: (),
                fineTunedModel: (),
                organizationId: "org-Gzp0rlPk9gw4JaNXmPqDJ1H4",
                resultFiles: [],
                status: "validating_files",
                validationFile: (),
                trainingFile: "file-JZMH9Xxnt7Hg2io6N2kzmlzM",
                hyperparameters: {
                    nEpochs: "auto",
                    "batchSize": "auto",
                    "learningRateMultiplier": "auto"
                },
                trainedTokens: (),
                'error: {},
                "userProvidedSuffix": (),
                seed: 1776549854,
                estimatedFinish: (),
                integrations: []
            },
            headers: {
                "Content-Type": "application/json"
            }
        };

        return response;
    }

    # Delete a file.
    #
    # + file_id - The ID of the file to use for this request.
    # + return - OK
    resource function delete files/[string file_id]() returns DeleteFileResponse {

        DeleteFileResponse response = {
            'object: "file",
            id: file_id,
            deleted: true
        };

        return response;
    }

    # Returns a list of files that belong to the user's organization.
    #
    # + purpose - Only return files with the given purpose.
    # + return - OK
    resource function get files(string? purpose) returns ListFilesResponse {

        ListFilesResponse response = {
            'object: "list",
            data: [
                {
                    'object: "file",
                    id: "file-JZMH9Xxnt7Hg2io6N2kzmlzM",
                    purpose: "fine-tune",
                    filename: "sample.jsonl",
                    bytes: 71,
                    created_at: 1723097702,
                    status: "processed",
                    status_details: ()
                },
                {
                    'object: "file",
                    id: "file-JZMH9Xxnt7Hg2io6N2kzmlzM",
                    purpose: "fine-tune",
                    filename: "sample.jsonl",
                    bytes: 71,
                    created_at: 1723097702,
                    status: "processed",
                    status_details: ()
                }
            ]
        };

        return response;
    }

    # Returns information about a specific file.
    #
    # + file_id - The ID of the file to use for this request.
    # + return - OK
    resource function get files/[string file_id]() returns OpenAIFile {

        OpenAIFile response = {
            'object: "file",
            id: file_id,
            purpose: "fine-tune",
            filename: "sample.jsonl",
            bytes: 71,
            created_at: 1723097702,
            status: "processed",
            status_details: ()
        };

        return response;
    }

    # Returns the contents of the specified file.
    #
    # + file_id - The ID of the file to use for this request.
    # + return - OK
    resource function get files/[string file_id]/content() returns byte[] {

        byte[] response = [123, 34, 116, 101, 120, 116, 34, 58, 34, 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 34, 125];

        return response;
    }

    # List your organization's fine-tuning jobs
    #
    # + after - Identifier for the last job from the previous pagination request.
    # + 'limit - Number of fine-tuning jobs to retrieve.
    # + return - OK
    resource function get fine_tuning/jobs(string? after, int 'limit = 20) returns ListPaginatedFineTuningJobsResponse {

        ListPaginatedFineTuningJobsResponse response = {
            'object: "list",
            data: [
                {
                    'object: "fine_tuning.job",
                    id: "ftjob-G0rwrYUnRwEWPjDRvxByxPxU",
                    model: "gpt-3.5-turbo-0125",
                    createdAt: 1723097706,
                    finishedAt: (),
                    fineTunedModel: (),
                    organizationId: "org-Gzp0rlPk9gw4JaNXmPqDJ1H4",
                    resultFiles: [],
                    status: "failed",
                    validationFile: (),
                    trainingFile: "file-JZMH9Xxnt7Hg2io6N2kzmlzM",
                    hyperparameters: {
                        nEpochs: "auto",
                        "batchSize": "auto",
                        "learningRateMultiplier": "auto"
                    },
                    trainedTokens: (),
                    'error: {
                        code: "invalid_training_file",
                        param: "training_file",
                        message: "The job failed due to an invalid training file. Expected file to have JSONL format, where every line is a valid JSON dictionary. Line 1 is not a dictionary."
                    },
                    "userProvidedSuffix": (),
                    seed: 1913581589,
                    estimatedFinish: (),
                    integrations: []
                }
            ],
            hasMore: false
        };

        return response;
    }

    # Get info about a fine-tuning job.
    #
    # [Learn more about fine-tuning](/docs/guides/fine-tuning)
    #
    # + fine_tuning_job_id - The ID of the fine-tuning job.
    # + return - OK
    resource function get fine_tuning/jobs/[string fine_tuning_job_id]() returns FineTuningJob {

        FineTuningJob response = {
            'object: "fine_tuning.job",
            id: fine_tuning_job_id,
            model: "gpt-3.5-turbo-0125",
            createdAt: 1723097706,
            finishedAt: (),
            fineTunedModel: (),
            organizationId: "org-Gzp0rlPk9gw4JaNXmPqDJ1H4",
            resultFiles: [],
            status: "failed",
            validationFile: (),
            trainingFile: "file-JZMH9Xxnt7Hg2io6N2kzmlzM",
            hyperparameters: {
                nEpochs: "auto",
                "batchSize": "auto",
                "learningRateMultiplier": "auto"
            },
            trainedTokens: (),
            'error: {
                code: "invalid_training_file",
                param: "training_file",
                message: "The job failed due to an invalid training file. Expected file to have JSONL format, where every line is a valid JSON dictionary. Line 1 is not a dictionary."
            },
            "userProvidedSuffix": (),
            seed: 1913581589,
            estimatedFinish: (),
            integrations: []
        };

        return response;
    }

    # List checkpoints for a fine-tuning job.
    #
    # + fine_tuning_job_id - The ID of the fine-tuning job to get checkpoints for.
    # + after - Identifier for the last checkpoint ID from the previous pagination request.
    # + 'limit - Number of checkpoints to retrieve.
    # + return - OK
    resource function get fine_tuning/jobs/[string fine_tuning_job_id]/checkpoints(string? after, int 'limit = 10) returns ListFineTuningJobCheckpointsResponse {

        ListFineTuningJobCheckpointsResponse response = {
            'object: "list",
            data: [
                {
                    id: "checkpoint-1",
                    createdAt: 1723110882,
                    'object: "fine_tuning.job.checkpoint",
                    fineTunedModelCheckpoint: "gpt-3.5-turbo-0125-1",
                    fineTuningJobId: fine_tuning_job_id,
                    metrics: {
                        step: 1
                    },
                    stepNumber: 2
                }
            ],
            hasMore: false
        };

        return response;
    }

    # Get status updates for a fine-tuning job.
    #
    # + fine_tuning_job_id - The ID of the fine-tuning job to get events for.
    # + after - Identifier for the last event from the previous pagination request.
    # + 'limit - Number of events to retrieve.
    # + return - OK
    resource function get fine_tuning/jobs/[string fine_tuning_job_id]/events(string? after, int 'limit = 20) returns ListFineTuningJobEventsResponse {

        ListFineTuningJobEventsResponse response = {
            "object": "list",
            "data": [
                {
                    id: fine_tuning_job_id,
                    createdAt: 1723110882,
                    level: "warn",
                    message: "Fine-tuning job started.",
                    'object: "fine_tuning.job.event"
                }
            ]
        };

        return response;
    }

    # Lists the currently available models, and provides basic information about each one such as the owner and availability.
    #
    # + return - OK
    resource function get models() returns ListModelsResponse {

        ListModelsResponse response = {
            'object: "list",
            data: [
                {
                    id: "dall-e-3",
                    'object: "model",
                    created: 1698785189,
                    owned_by: "system"
                },
                {
                    id: "dall-e-3",
                    'object: "model",
                    created: 1698785189,
                    owned_by: "system"
                }
            ]
        };

        return response;
    }

    # Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
    #
    # + model - The ID of the model to use for this request
    # + return - OK
    resource function get models/[string model]() returns Model {

        Model response = {
            id: model,
            'object: "model",
            created: 1698785189,
            owned_by: "system"
        };

        return response;
    }

    # Upload a file that can be used across various endpoints. Individual files can be up to 512 MB, and the size of all files uploaded by one organization can be up to 100 GB.
    #
    # The Assistants API supports files up to 2 million tokens and of specific file types. See the [Assistants Tools guide](/docs/assistants/tools) for details.
    #
    # The Fine-tuning API only supports `.jsonl` files. The input also has certain required formats for fine-tuning [chat](/docs/api-reference/fine-tuning/chat-input) or [completions](/docs/api-reference/fine-tuning/completions-input) models.
    #
    # The Batch API only supports `.jsonl` files up to 100 MB in size. The input also has a specific required [format](/docs/api-reference/batch/request-input).
    #
    # Please [contact us](https://help.openai.com/) if you need to increase these storage limits.
    #
    # + return - OK
    resource function post files(http:Request request) returns OkOpenAIFile {

        OkOpenAIFile response = {
            body: {
                'object: "file",
                id: "file-JZMH9Xxnt7Hg2io6N2kzmlzM",
                purpose: "fine-tune",
                filename: "sample.jsonl",
                bytes: 71,
                created_at: 1723097702,
                status: "processed",
                status_details: ()
            },
            headers: {
                "Content-Type": "application/json"
            }
        };

        return response;
    }

    # Creates a fine-tuning job which begins the process of creating a new model from a given dataset.
    #
    # Response includes details of the enqueued job including job status and the name of the fine-tuned models once complete.
    #
    # [Learn more about fine-tuning](/docs/guides/fine-tuning)
    #
    # + return - OK
    resource function post fine_tuning/jobs(@http:Payload CreateFineTuningJobRequest payload) returns OkFineTuningJob {

        OkFineTuningJob response = {
            body: {
                'object: "fine_tuning.job",
                id: "ftjob-5NikxOY1BsPHxt8Z8YBm8AX1",
                model: "gpt-3.5-turbo-0125",
                createdAt: 1723110882,
                finishedAt: (),
                fineTunedModel: (),
                organizationId: "org-Gzp0rlPk9gw4JaNXmPqDJ1H4",
                resultFiles: [],
                status: "validating_files",
                validationFile: (),
                trainingFile: "file-JZMH9Xxnt7Hg2io6N2kzmlzM",
                hyperparameters: {
                    nEpochs: "auto",
                    "batchSize": "auto",
                    "learningRateMultiplier": "auto"
                },
                trainedTokens: (),
                'error: {},
                "userProvidedSuffix": (),
                seed: 1776549854,
                estimatedFinish: (),
                integrations: []
            },
            headers: {
                "Content-Type": "application/json"
            }
        };

        return response;
    }
};

function init() returns error? {

    if isLiveServer {
        log:printInfo("Skipping mock server initialization as the tests are running on live server");
        return;
    }

    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
