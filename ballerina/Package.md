
## Overview

[OpenAI](https://openai.com/), an AI research organization focused on creating friendly AI for humanity, offers the [OpenAI API](https://platform.openai.com/docs/api-reference/introduction) to access its powerful AI models for tasks like natural language processing and image generation.

The [OpenAI Fine-tunes API v1](https://platform.openai.com/docs/guides/fine-tuning) allows users to customize OpenAI's AI models to meet specific needs. The `ballarinax/openai.finetune` package facilitates connection to this API.

## Setup guide

To use the OpenAI Connector, you must have access to the OpenAI API through a [OpenAI Platform account](https://platform.openai.com) and a project under it. If you do not have a OpenAI Platform account, you can sign up for one [here](https://platform.openai.com/signup).

#### Create a OpenAI API Key

1. Open the [OpenAI Platform Dashboard](https://platform.openai.com).

2. Navigate to Dashboard -> API keys
<img src=https://raw.githubusercontent.com/KATTA-00/module-ballerinax-openai.finetunes/docs/docs/setup/resources/navigate-api-key-dashboard.png alt="OpenAI Platform" style="width: 70%;">

3. Click on the "Create new secret key" button
<img src=https://raw.githubusercontent.com/KATTA-00/module-ballerinax-openai.finetunes/docs/docs/setup/resources/api-key-dashboard.png alt="OpenAI Platform" style="width: 70%;">

4. Fill the details and click on Create secret key
<img src=https://raw.githubusercontent.com/KATTA-00/module-ballerinax-openai.finetunes/docs/docs/setup/resources/create-new-secret-key.png alt="OpenAI Platform" style="width: 70%;">

5. Store the API key securely to use in your application 
<img src=https://raw.githubusercontent.com/KATTA-00/module-ballerinax-openai.finetunes/docs/docs/setup/resources/saved-key.png alt="OpenAI Platform" style="width: 70%;">

## Quickstart

To use the OpenAI Fine-tunes connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the connector
First, import the `ballerinax/openai.finetunes` module (along with the other required imports) as given below.

```ballerina
import ballerinax/openai.finetunes;
import ballerina/io;
```

### Step 2: Instantiate a new connector

Create a `finetunes:ConnectionConfig` with the obtained API Key and initialize the connector.

```ballerina
configurable string apiKey = ?;

final finetunes:Client openaiFinetunes = check new({
    auth: {
        apiKey
    }
});
```

### Step 3: Invoke the connector operation
1. Now, you can use the operations available within the connector. 

   Following is an example on fine tuning the gpt-3.5-turbo model:

    ```ballerina
    public function main() returns error? {

        finetunes:CreateFileRequest req = {
            file: {fileContent: check io:fileReadBytes("sample.jsonl"), fileName: "sample.jsonl"},
            purpose: "fine-tune"
        };

        finetunes:OpenAIFile fileRes = check openaiFinetunes->/files.post(req);

        string fileId = fileRes.id;

        CreateFineTuningJobRequest fineTuneRequest = {
            model: "gpt-3.5-turbo",
            training_file: fileId
        };

        FineTuningJob fineTuneResponse = 
            check openaiFinetunes->/fine_tuning/jobs.post(fineTuneRequest);
        
        io:println(fineTuneResponse.id);
    }
    ``` 
2. Use the `bal run` command to compile and run the Ballerina program.

## Examples

The `OpenAI Finetunes` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-openai-finetunes/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)