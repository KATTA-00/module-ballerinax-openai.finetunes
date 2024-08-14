import ballerina/io;
import ballerina/lang.runtime;

// import ballerinax/openai.finetunes;

configurable string token = ?;
string serviceUrl = "https://api.openai.com/v1";
string trainingFileName = "training.jsonl";
string trainingFilePath = "./data/" + trainingFileName;

final ConnectionConfig config = {auth: {token}};
final Client openAIFinetunes = check new Client(config, serviceUrl);

public function main() returns error? {

    byte[] trainingFileContent = check io:fileReadBytes(trainingFilePath);

    CreateFileRequest trainingFileRequest = {
        file: {fileContent: trainingFileContent, fileName: trainingFileName},
        purpose: "fine-tune"
    };

    OpenAIFile trainingFileResponse =
        check openAIFinetunes->/files.post(trainingFileRequest);

    string trainingFileId = trainingFileResponse.id;
    io:println("Training file id: " + trainingFileId);

    CreateFineTuningJobRequest fineTuneRequest = {
        model: "gpt-4o-mini-2024-07-18",
        training_file: trainingFileId,
        hyperparameters: {
            n_epochs: 15,
            batch_size: 3,
            learning_rate_multiplier: 0.3
        }
    };

    FineTuningJob fineTuneResponse =
        check openAIFinetunes->/fine_tuning/jobs.post(fineTuneRequest);
    string fineTuneJobId = fineTuneResponse.id;
    io:println("Fine-tuning job id: " + fineTuneJobId);

    FineTuningJob fineTuneJob =
        check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();

    io:print("Validating files...");
    while (fineTuneJob.status == "validating_files") {
        io:print(".");
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        runtime:sleep(1);
    }

    io:print("\nFiles validated successfully.");
    while (fineTuneJob.status == "queued") {
        io:print(".");
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        runtime:sleep(1);
    }

    io:print("\nTraining...");
    while (fineTuneJob.status == "running") {
        fineTuneJob = check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId].get();
        io:print(".");
        runtime:sleep(1);
    }

    if (fineTuneJob.status != "succeeded") {
        io:println("Fine-tuning job failed.");
        DeleteFileResponse deleteFileResponse =
            check openAIFinetunes->/files/[trainingFileId].delete();
        if (deleteFileResponse.deleted == true) {
            io:println("Training file deleted successfully.");
        } else {
            io:println("Failed to delete the training file.");
        }

        return;
    }

    io:println("\n");
    ListFineTuningJobCheckpointsResponse checkpointsResponse =
            check openAIFinetunes->/fine_tuning/jobs/[fineTuneJobId]/checkpoints.get();

    foreach FineTuningJobCheckpoint item in checkpointsResponse.data.reverse() {
        io:print("step: ", item.metrics.step);
        io:print(", train loss: ", item.metrics.train_loss);
        io:println(", train mean token accuracy: ", item.metrics.train_mean_token_accuracy);
    }

    io:println("\nFine-tuning job details: ");
    io:println("Fine-tuned Model: ", fineTuneJob.fine_tuned_model);
    io:println("Model: ", fineTuneJob.model);
    io:println("Fine-tuning job completed successfully.");

    DeleteFileResponse deleteFileResponse =
        check openAIFinetunes->/files/[trainingFileId].delete();
    if (deleteFileResponse.deleted == true) {
        io:println("Training file deleted successfully.");
    } else {
        io:println("Failed to delete the training file.");
    }

}
