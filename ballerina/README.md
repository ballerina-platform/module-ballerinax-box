## Overview

[Box](https://www.box.com/) is a content cloud for storing, sharing and managing files, with enterprise features for collaboration, governance and security. The [Box Platform API](https://developer.box.com/reference/) exposes these capabilities programmatically.

The Box connector lets Ballerina applications work with files, folders, users, groups, collaborations, comments, tasks, metadata, retention and legal-hold policies, Box Sign requests and Box AI from integrations. It supports version 2024.0 of the Box Platform API.

### Key features

- Upload, download, copy, update and delete files and folders, including version history and upload sessions
- Share content through shared links, collaborations, web links and webhooks
- Manage enterprise users, groups, memberships and terms of service
- Apply metadata templates and taxonomies, retention policies, legal holds and information barriers
- Search content, add comments and tasks, create Box Sign requests and call Box AI

## Setup guide

To use the Box connector, you need a Box account and a Box Platform application.

### Step 1: Create a Box application

1. Sign in to the [Box Developer Console](https://app.box.com/developers/console) and select **Create Platform App**.
2. Choose **Custom App** and select **User Authentication (OAuth 2.0)** as the authentication method.
3. Enter an application name and create the app.

### Step 2: Configure OAuth 2.0 settings

1. Open the **Configuration** tab of the app and note the **Client ID** and **Client Secret**.
2. Under **OAuth 2.0 Redirect URI**, add the redirect URI of your application, for example `http://localhost:8080/callback`.
3. Under **Application Scopes**, enable the scopes your integration needs, such as **Read all files and folders stored in Box** and **Write all files and folders stored in Box**.
4. Save the configuration. Changes to scopes require the app to be authorized again.

### Step 3: Obtain a refresh token

1. Send the user to the authorization URL, replacing `YOUR_CLIENT_ID` and `YOUR_REDIRECT_URI`:

```
https://account.box.com/api/oauth2/authorize?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI
```

2. After the user grants access, Box redirects to your redirect URI with an authorization `code`.
3. Exchange the code for tokens:

```bash
curl -X POST https://api.box.com/oauth2/token \
  -d "grant_type=authorization_code" \
  -d "code=AUTHORIZATION_CODE" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET"
```

The response contains an `access_token` and a `refresh_token`. Use the refresh token to configure the connector. Alternatively, a developer token from the **Configuration** tab can be used as a short-lived bearer token for testing.

## Quickstart

To use the Box connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `box` module.

```ballerina
import ballerinax/box;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the credentials obtained in the steps above:

```toml
clientId = "<Client ID>"
clientSecret = "<Client Secret>"
refreshToken = "<Refresh Token>"
refreshUrl = "https://api.box.com/oauth2/token"
```

2. Create a `box:ConnectionConfig` with the OAuth 2.0 refresh-token credentials and initialize the connector with it.

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

final box:Client boxClient = check new ({
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Get the current user

```ballerina
public function main() returns error? {
    box:UserFull _ = check boxClient->getCurrentUser();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The Box connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-box/tree/main/examples/), covering the following use cases:

1. [Project workspace setup](https://github.com/ballerina-platform/module-ballerinax-box/tree/main/examples/project_workspace_setup) - Create a project folder, add a reference web link, optionally invite a collaborator and list the folder contents.

2. [File review workflow](https://github.com/ballerina-platform/module-ballerinax-box/tree/main/examples/file_review_workflow) - Read a file, leave a review comment, optionally create a review task and list the file's comments.
