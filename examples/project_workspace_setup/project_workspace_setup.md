# Project workspace setup

This example creates a project folder in Box, adds a reference web link to it, optionally invites a collaborator as an editor, and lists the folder contents.

## Prerequisites

### 1. Set up a Box application

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-box/blob/main/ballerina/README.md#setup-guide) to obtain a client ID, client secret and refresh token. The app needs the scope to read and write all files and folders stored in Box, and to manage collaborations if you invite a collaborator.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "<token-url, e.g. https://api.box.com/oauth2/token>"
parentFolderId = "<id-of-the-parent-folder, 0 for the root folder>"
workspaceName = "<name-of-the-new-folder>"
referenceUrl = "<url-of-the-reference-link>"
collaboratorLogin = "<collaborator-email>"
inviteCollaborator = false
```

Inviting a collaborator sends an invitation email, so the example only does it when `inviteCollaborator` is `true`.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
