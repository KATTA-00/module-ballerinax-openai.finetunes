# Ballerina OpenAI Finetunes connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/actions/workflows/build-with-bal-test-native.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-openai.finetunes.svg)](https://github.com/ballerina-platform/module-ballerinax-openai.finetunes/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/openai.finetunes.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%openai.finetunes)


## Overview

This is a generated connector for the [OpenAI Fine-tunes API](https://platform.openai.com/docs/api-reference/fine-tuning) OpenAPI specification. OpenAI is an American artificial intelligence research laboratory consisting of a non-profit corporation and a for-profit subsidiary. OpenAI conducts AI research with the declared intention of promoting and developing friendly AI. The OpenAI Fine-tunes API provides a way to customize new AI models developed by OpenAI for your specific needs.

## Setup guide

To use the OpenAI Connector, you must have access to the OpenAI API through a [OpenAI Platform account](https://platform.openai.com) and a project under it. If you do not have a OpenAI Platform account, you can sign up for one [here](https://platform.openai.com/signup).

#### Create a OpenAI API Key

1. Open the [OpenAI Platform Dashboard](https://platform.openai.com).

2. Navigate to Dashboard -> API keys
<img src=https://raw.githubusercontent.com/KATTA-00/module-ballerinax-openai.finetunes/docs/docs/setup/resources/api-key-dashboard.png alt="OpenAI platform dashboard" style="width: 70%;">

3. Click on the "Create new secret key" button
<img src=https://raw.githubusercontent.com/KATTA-00/module-ballerinax-openai.finetunes/docs/docs/setup/resources/create-new-secrete-key.png alt="OpenAI platform api key" style="width: 70%;">

4. Fill the details and click on Create secret key
<img src=https://raw.githubusercontent.com/KATTA-00/module-ballerinax-openai.finetunes/docs/docs/setup/resources/saved-key.png alt="OpenAI platform api key" style="width: 70%;">

5. Store the API key securely to use in your application

## Quickstart

To use the OpenAI Fine-tunes connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the connector
First, import the `ballerinax/openai.finetunes` module (along with the other required imports) as given below.

```ballerina
import ballerinax/openai.finetunes;
import ballerina/io;
```

### Step 2: Create a new connector instance

1. Create a `Config.toml` file and, configure the obtained API key in the above steps as follows:

```bash
token = "<API Key>"
```

2. Create and initialize a `finetunes:Client` with the obtained `token`.

```ballerina
finetunes:Client finetunesClient = check new ({
    auth: {
        token
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

        finetunes:OpenAIFile fileRes = check finetunesClient->/files.post(req);

        string fileId = fileRes.id;

        CreateFineTuningJobRequest fineTuneRequest = {
            model: "gpt-3.5-turbo",
            training_file: fileId
        };

        FineTuningJob fineTuneResponse = 
            check finetunesClient->/fine_tuning/jobs.post(fineTuneRequest);
        
        io:println(fineTuneResponse.id);
    }
    ``` 
2. Use the `bal run` command to compile and run the Ballerina program.

## Examples

The `OpenAI Finetunes` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-openai-finetunes/tree/main/examples/), covering the following use cases:

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