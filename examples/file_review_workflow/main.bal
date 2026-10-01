// Requests a review of a file: reads the file, leaves a comment, optionally creates a review
// task and prints the file's comments.

import ballerina/io;
import ballerinax/box;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string fileId = ?;
configurable string reviewMessage = ?;
configurable string reviewDueAt = "";
configurable boolean createReviewTask = false;

public function main() returns error? {
    box:Client boxClient = check new ({
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            refreshUrl
        }
    });

    // Step 1: Read the file to review.
    box:FileFull? file = check boxClient->getFileInformation(fileId);
    if file is () {
        return error("File " + fileId + " was not modified or could not be read");
    }
    io:println("Reviewing file ", file.name, " (", file.id, ")");

    // Step 2: Leave a comment asking for the review.
    box:CommentFull comment = check boxClient->createComment({
        message: reviewMessage,
        item: {id: file.id, 'type: "file"}
    });
    io:println("Created comment ", comment.id);

    // Step 3: Create a review task. Reviewers are notified, so it only runs when enabled.
    if createReviewTask {
        box:CreateTaskRequest taskRequest = {
            item: {id: file.id, 'type: "file"},
            action: "review",
            message: reviewMessage
        };
        if reviewDueAt != "" {
            taskRequest.dueAt = reviewDueAt;
        }
        box:Task task = check boxClient->createTask(taskRequest);
        io:println("Created task ", task.id);
    }

    // Step 4: Print all comments on the file.
    box:Comments comments = check boxClient->listFileComments(file.id);
    foreach box:CommentFull c in comments.entries ?: [] {
        io:println(c.createdAt, ": ", c.message);
    }
}
