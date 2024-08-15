
## Overview

[OpenAI](https://openai.com/), an AI research organization focused on creating friendly AI for humanity, offers the [OpenAI API](https://platform.openai.com/docs/api-reference/introduction) to access its powerful AI models for tasks like natural language processing and image generation.

The `ballarinax/openai.finetunes` package offers APIs to connect and interact with [the fine-tuning related endpoints of OpenAI REST API v1](https://platform.openai.com/docs/guides/fine-tuning) allowing users to customize OpenAI's AI models to meet specific needs.

## Setup guide

To use the OpenAI Connector, you must have access to the OpenAI API through a [OpenAI Platform account](https://platform.openai.com) and a project under it. If you do not have a OpenAI Platform account, you can sign up for one [here](https://platform.openai.com/signup).

#### Create a OpenAI API Key

1. Open the [OpenAI Platform Dashboard](https://platform.openai.com).

2. Navigate to Dashboard -> API keys
<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-openai.finetunes/main/docs/setup/resources/navigate-api-key-dashboard.png alt="OpenAI Platform" style="width: 70%;">

3. Click on the "Create new secret key" button
<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-openai.finetunes/main/docs/setup/resources/api-key-dashboard.png alt="OpenAI Platform" style="width: 70%;">

4. Fill the details and click on Create secret key
<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-openai.finetunes/main/docs/setup/resources/create-new-secret-key.png alt="OpenAI Platform" style="width: 70%;">

5. Store the API key securely to use in your application 
<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-openai.finetunes/main/docs/setup/resources/saved-key.png alt="OpenAI Platform" style="width: 70%;">

## Quickstart

To use the `OpenAI Finetunes` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `openai.finetunes` module.

```ballerina
import ballerinax/openai.finetunes;
import ballerina/io;
```

### Step 2: Instantiate a new connector

Create a `finetunes:ConnectionConfig` with the obtained API Key and initialize the connector.

```ballerina
configurable string apiKey = ?;

final finetunes:Client openAIFinetunes = check new({
    auth: {
        token: apiKey
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

**Note**:  First, create a sample.jsonl file in the same directory. This file should contain the training data formatted according to the guidelines provided [here](https://platform.openai.com/docs/api-reference/files/create).

#### Fine tuning the gpt-3.5-turbo model

```ballerina
public function main() returns error? {

    finetunes:CreateFileRequest req = {
        file: {fileContent: check io:fileReadBytes("sample.jsonl"), fileName: "sample.jsonl"},
        purpose: "fine-tune"
    };

    finetunes:OpenAIFile fileRes = check openAIFinetunes->/files.post(req);

    string fileId = fileRes.id;

    finetunes:CreateFineTuningJobRequest fineTuneRequest = {
        model: "gpt-3.5-turbo",
        training_file: fileId
    };

    finetunes:FineTuningJob fineTuneResponse = 
        check openAIFinetunes->/fine_tuning/jobs.post(fineTuneRequest);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `OpenAI Finetunes` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-openai.finetunes/tree/main/examples/), covering the following use cases:

1. [Sarcastic bot](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/tree/main/examples/Sarcastic-bot) - Fine-tune the GPT-3.5-turbo model to generate sarcastic responses 

2. [Sports headline analyzer](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/tree/main/examples/Sports-headline-analyzer) - Fine-tune the GPT-4o-mini model to extract structured information (player, team, sport, and gender) from sports headlines.
