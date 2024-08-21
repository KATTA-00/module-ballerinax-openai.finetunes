
## Sarcastic bot

This use case demonstrates how the OpenAI Fine-tunes API v1 can be harnessed to fine-tune the GPT-3.5-turbo model to produce sarcastic responses. The example showcases a series of steps that utilize the OpenAI Files API v1 to upload training data, followed by using the OpenAI Fine-tunes API v1 to fine-tune the GPT-3.5-turbo model with that data, getting the traning model events.

## Prerequisites

### 1. Generate a API key

Refer to the [Setup guide](https://central.ballerina.io/ballerinax/openai.finetunes/latest#setup-guide) to obtain the API key.

### 2. Configuration

Create a `Config.toml` file in the example's root directory as follows:

```bash
token = "<API key>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```
