# File review workflow

This example reads a file from Box, leaves a comment asking for a review, optionally creates a review task for the file, and prints all comments on the file.

## Prerequisites

### 1. Set up a Box application

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-box/blob/main/ballerina/README.md#setup-guide) to obtain a client ID, client secret and refresh token. The app needs the scope to read and write all files and folders stored in Box.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "<token-url, e.g. https://api.box.com/oauth2/token>"
fileId = "<id-of-the-file-to-review>"
reviewMessage = "<review-request-message>"
reviewDueAt = "<due-date-time, e.g. 2026-10-15T10:00:00Z>"
createReviewTask = false
```

Creating a task notifies reviewers, so the example only creates it when `createReviewTask` is `true`. `reviewDueAt` is optional; leave it out to create the task without a due date.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
