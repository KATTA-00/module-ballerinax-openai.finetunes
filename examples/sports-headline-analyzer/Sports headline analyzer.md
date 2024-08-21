
## Sports headlines analyzer

This use case illustrates how the OpenAI Fine-tunes API v1 can be used to fine-tune the GPT-4o-mini model for extracting structured information from sports headlines. The example outlines a series of steps that include using the OpenAI Files API v1 to upload training data, then employing the OpenAI Fine-tunes API v1 to fine-tune the GPT-4o-mini model with this data, and finally printing the model's checkpoints and deleting the data file.

## Prerequisites

### 1. Generate an API key

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
