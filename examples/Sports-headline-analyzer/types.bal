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

import ballerina/http;

# The `File` object represents a document that has been uploaded to OpenAI.
public type OpenAIFile record {
    # The file identifier, which can be referenced in the API endpoints.
    string id;
    # The size of the file, in bytes.
    int bytes;
    # The Unix timestamp (in seconds) for when the file was created.
    int created_at;
    # The name of the file.
    string filename;
    # The object type, which is always `file`.
    "file" 'object;
    # The intended purpose of the file. Supported values are `assistants`, `assistants_output`, `batch`, `batch_output`, `fine-tune`, `fine-tune-results` and `vision`.
    "assistants"|"assistants_output"|"batch"|"batch_output"|"fine-tune"|"fine-tune-results"|"vision" purpose;
    # Deprecated. The current status of the file, which can be either `uploaded`, `processed`, or `error`.
    # 
    # # Deprecated
    @deprecated
    "uploaded"|"processed"|"error" status;
    # Deprecated. For details on why a fine-tuning training file failed validation, see the `error` field on `fine_tuning.job`.
    string? status_details?;
};

public type CreateFineTuningJobRequest record {
    # The name of the model to fine-tune. You can select one of the
    # [supported models](/docs/guides/fine-tuning/what-models-can-be-fine-tuned).
    string|"babbage-002"|"davinci-002"|"gpt-3.5-turbo" model;
    # The ID of an uploaded file that contains training data.
    # 
    # See [upload file](/docs/api-reference/files/create) for how to upload a file.
    # 
    # Your dataset must be formatted as a JSONL file. Additionally, you must upload your file with the purpose `fine-tune`.
    # 
    # The contents of the file should differ depending on if the model uses the [chat](/docs/api-reference/fine-tuning/chat-input) or [completions](/docs/api-reference/fine-tuning/completions-input) format.
    # 
    # See the [fine-tuning guide](/docs/guides/fine-tuning) for more details.
    string training_file;
    CreateFineTuningJobRequest_hyperparameters hyperparameters?;
    # A string of up to 18 characters that will be added to your fine-tuned model name.
    # 
    # For example, a `suffix` of "custom-model-name" would produce a model name like `ft:gpt-3.5-turbo:openai:custom-model-name:7p4lURel`.
    string? suffix?;
    # The ID of an uploaded file that contains validation data.
    # 
    # If you provide this file, the data is used to generate validation
    # metrics periodically during fine-tuning. These metrics can be viewed in
    # the fine-tuning results file.
    # The same data should not be present in both train and validation files.
    # 
    # Your dataset must be formatted as a JSONL file. You must upload your file with the purpose `fine-tune`.
    # 
    # See the [fine-tuning guide](/docs/guides/fine-tuning) for more details.
    string? validation_file?;
    # A list of integrations to enable for your fine-tuning job.
    CreateFineTuningJobRequest_integrations[]? integrations?;
    # The seed controls the reproducibility of the job. Passing in the same seed and job parameters should produce the same results, but may differ in rare cases.
    # If a seed is not specified, one will be generated for you.
    int? seed?;
};

# The `fine_tuning.job.checkpoint` object represents a model checkpoint for a fine-tuning job that is ready to use.
public type FineTuningJobCheckpoint record {
    # The checkpoint identifier, which can be referenced in the API endpoints.
    string id;
    # The Unix timestamp (in seconds) for when the checkpoint was created.
    int created_at;
    # The name of the fine-tuned checkpoint model that is created.
    string fine_tuned_model_checkpoint;
    # The step number that the checkpoint was created at.
    int step_number;
    FineTuningJobCheckpoint_metrics metrics;
    # The name of the fine-tuning job that this checkpoint was created from.
    string fine_tuning_job_id;
    # The object type, which is always "fine_tuning.job.checkpoint".
    "fine_tuning.job.checkpoint" 'object;
};

public type ListPaginatedFineTuningJobsResponse record {
    FineTuningJob[] data;
    boolean has_more;
    "list" 'object;
};

# The hyperparameters used for the fine-tuning job.
public type CreateFineTuningJobRequest_hyperparameters record {
    # Number of examples in each batch. A larger batch size means that model parameters
    # are updated less frequently, but with lower variance.
    "auto"|int batch_size = "auto";
    # Scaling factor for the learning rate. A smaller learning rate may be useful to avoid
    # overfitting.
    "auto"|decimal learning_rate_multiplier = "auto";
    # The number of epochs to train the model for. An epoch refers to one full cycle
    # through the training dataset.
    "auto"|int n_epochs = "auto";
};

# Represents the Queries record for the operation: listFineTuningEvents
public type ListFineTuningEventsQueries record {
    # Number of events to retrieve.
    int 'limit = 20;
    # Identifier for the last event from the previous pagination request.
    string after?;
};

# Represents the Queries record for the operation: listFineTuningJobCheckpoints
public type ListFineTuningJobCheckpointsQueries record {
    # Number of checkpoints to retrieve.
    int 'limit = 10;
    # Identifier for the last checkpoint ID from the previous pagination request.
    string after?;
};

# The settings for your integration with Weights and Biases. This payload specifies the project that
# metrics will be sent to. Optionally, you can set an explicit display name for your run, add tags
# to your run, and set a default entity (team, username, etc) to be associated with your run.
public type CreateFineTuningJobRequest_wandb record {
    # The name of the project that the new run will be created under.
    string project;
    # A display name to set for the run. If not set, we will use the Job ID as the name.
    string? name?;
    # The entity to use for the run. This allows you to set the team or username of the WandB user that you would
    # like associated with the run. If not set, the default entity for the registered WandB API key is used.
    string? entity?;
    # A list of tags to be attached to the newly created run. These tags are passed through directly to WandB. Some
    # default tags are generated by OpenAI: "openai/finetune", "openai/{base-model}", "openai/{ftjob-abcdef}".
    string[] tags?;
};

# The hyperparameters used for the fine-tuning job. See the [fine-tuning guide](/docs/guides/fine-tuning) for more details.
public type FineTuningJob_hyperparameters record {
    # The number of epochs to train the model for. An epoch refers to one full cycle through the training dataset.
    # "auto" decides the optimal number of epochs based on the size of the dataset. If setting the number manually, we support any number between 1 and 50 epochs.
    "auto"|int n_epochs;
};

# Represents the Queries record for the operation: listFiles
public type ListFilesQueries record {
    # Only return files with the given purpose.
    string purpose?;
};

public type ListFineTuningJobCheckpointsResponse record {
    FineTuningJobCheckpoint[] data;
    "list" 'object;
    string? first_id?;
    string? last_id?;
    boolean has_more;
};

public type DeleteModelResponse record {
    string id;
    boolean deleted;
    string 'object;
};

public type FineTuningIntegration record {
    # The type of the integration being enabled for the fine-tuning job
    "wandb" 'type;
    CreateFineTuningJobRequest_wandb wandb;
};

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

# Metrics at the step number during the fine-tuning job.
public type FineTuningJobCheckpoint_metrics record {
    decimal step?;
    decimal train_loss?;
    decimal train_mean_token_accuracy?;
    decimal valid_loss?;
    decimal valid_mean_token_accuracy?;
    decimal full_valid_loss?;
    decimal full_valid_mean_token_accuracy?;
};

public type CreateFileRequest record {|
    # The File object (not file name) to be uploaded.
    record {byte[] fileContent; string fileName;} file;
    # The intended purpose of the uploaded file.
    # 
    # Use "assistants" for [Assistants](/docs/api-reference/assistants) and [Message](/docs/api-reference/messages) files, "vision" for Assistants image file inputs, "batch" for [Batch API](/docs/guides/batch), and "fine-tune" for [Fine-tuning](/docs/api-reference/fine-tuning).
    "assistants"|"batch"|"fine-tune"|"vision" purpose;
|};

# The `fine_tuning.job` object represents a fine-tuning job that has been created through the API.
public type FineTuningJob record {
    # The object identifier, which can be referenced in the API endpoints.
    string id;
    # The Unix timestamp (in seconds) for when the fine-tuning job was created.
    int created_at;
    FineTuningJob_error? 'error;
    # The name of the fine-tuned model that is being created. The value will be null if the fine-tuning job is still running.
    string? fine_tuned_model;
    # The Unix timestamp (in seconds) for when the fine-tuning job was finished. The value will be null if the fine-tuning job is still running.
    int? finished_at;
    FineTuningJob_hyperparameters hyperparameters;
    # The base model that is being fine-tuned.
    string model;
    # The object type, which is always "fine_tuning.job".
    "fine_tuning.job" 'object;
    # The organization that owns the fine-tuning job.
    string organization_id;
    # The compiled results file ID(s) for the fine-tuning job. You can retrieve the results with the [Files API](/docs/api-reference/files/retrieve-contents).
    string[] result_files;
    # The current status of the fine-tuning job, which can be either `validating_files`, `queued`, `running`, `succeeded`, `failed`, or `cancelled`.
    "validating_files"|"queued"|"running"|"succeeded"|"failed"|"cancelled" status;
    # The total number of billable tokens processed by this fine-tuning job. The value will be null if the fine-tuning job is still running.
    int? trained_tokens;
    # The file ID used for training. You can retrieve the training data with the [Files API](/docs/api-reference/files/retrieve-contents).
    string training_file;
    # The file ID used for validation. You can retrieve the validation results with the [Files API](/docs/api-reference/files/retrieve-contents).
    string? validation_file;
    # A list of integrations to enable for this fine-tuning job.
    (FineTuningIntegration)[]? integrations?;
    # The seed used for the fine-tuning job.
    int seed;
    # The Unix timestamp (in seconds) for when the fine-tuning job is estimated to finish. The value will be null if the fine-tuning job is not running.
    int? estimated_finish?;
};

# Proxy server configurations to be used with the HTTP client endpoint.
public type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

# For fine-tuning jobs that have `failed`, this will contain more information on the cause of the failure.
public type FineTuningJob_error record {
    # A machine-readable error code.
    string code?;
    # A human-readable error message.
    string message?;
    # The parameter that was invalid, usually `training_file` or `validation_file`. This field will be null if the failure was not parameter-specific.
    string? param?;
};

public type CreateFineTuningJobRequest_integrations record {
    # The type of integration to enable. Currently, only "wandb" (Weights and Biases) is supported.
    "wandb" 'type;
    CreateFineTuningJobRequest_wandb wandb;
};

public type ListModelsResponse record {
    "list" 'object;
    Model[] data;
};

# Fine-tuning job event object
public type FineTuningJobEvent record {
    string id;
    int created_at;
    "info"|"warn"|"error" level;
    string message;
    "fine_tuning.job.event" 'object;
};

public type DeleteFileResponse record {
    string id;
    "file" 'object;
    boolean deleted;
};

# Provides settings related to HTTP/1.x protocol.
public type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Describes an OpenAI model offering that can be used with the API.
public type Model record {
    # The model identifier, which can be referenced in the API endpoints.
    string id;
    # The Unix timestamp (in seconds) when the model was created.
    int created;
    # The object type, which is always "model".
    "model" 'object;
    # The organization that owns the model.
    string owned_by;
};

public type ListFineTuningJobEventsResponse record {
    FineTuningJobEvent[] data;
    "list" 'object;
};

public type ListFilesResponse record {
    OpenAIFile[] data;
    "list" 'object;
};

# Represents the Queries record for the operation: listPaginatedFineTuningJobs
public type ListPaginatedFineTuningJobsQueries record {
    # Number of fine-tuning jobs to retrieve.
    int 'limit = 20;
    # Identifier for the last job from the previous pagination request.
    string after?;
};
