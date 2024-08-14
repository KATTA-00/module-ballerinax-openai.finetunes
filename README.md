# Ballerina OpenAI Finetunes connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/build-with-bal-test-native.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-openai.finetunes.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/openai.finetunes.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%openai.finetunes)

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

    finetunes:OpenAIFile fileRes = check openaiFinetunes->/files.post(req);

    string fileId = fileRes.id;

    finetunes:CreateFineTuningJobRequest fineTuneRequest = {
        model: "gpt-3.5-turbo",
        training_file: fileId
    };

    finetunes:FineTuningJob fineTuneResponse = 
        check openaiFinetunes->/fine_tuning/jobs.post(fineTuneRequest);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `OpenAI Finetunes` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-openai.finetunes/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`openai.finetunes` package](https://central.ballerina.io/ballerinax/openai.finetunes/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
