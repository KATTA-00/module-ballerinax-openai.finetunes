# Examples

The `ballerinax/openai.finetunes` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/tree/main/examples), covering use cases like file uploading, finetuning models, getting events/checkpoints of a job and deleting files.

1. [Sarcastic Bot](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/tree/main/examples/sarcastic-bot) - Fine-tune the GPT-3.5-turbo model to generate sarcastic responses 

2. [Sports Headline Analyzer](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/tree/main/examples/sports-headline-analyzer) - Fine-tune the GPT-4o-mini model to extract structured information (player, team, sport, and gender) from sports headlines.

## Prerequisites

1. Generate an API key as described in the [Setup guide](https://central.ballerina.io/ballerinax/openai.finetunes/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    token = "<API Key>"
    ```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```