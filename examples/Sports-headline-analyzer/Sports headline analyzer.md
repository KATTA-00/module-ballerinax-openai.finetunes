
## Sports Headlines Analyzer

This use case demonstrates how the OpenAI Fine-tunes API v1 can be harnessed to fine-tune the GPT-4o-mini model to extract structured information from sports headlines. The example showcases a series of steps that utilize the OpenAI Files API v1 to upload training data, followed by using the OpenAI Fine-tunes API v1 to fine-tune the GPT-4o-mini model with that data.

## Prerequisites

### 1. Generate an API Key

Refer to the [Setup guide](https://central.ballerina.io/ballerinax/openai.finetunes/latest#setup-guide) to obtain the API key.

### 2. Configuration

Create a `Config.toml` file in the example's root directory as follows:

```bash
token = "<API key>"
```

## Run the Example

Execute the following command to run the example:

```bash
bal run
```
