# Examples

The `ballerinax/box` connector provides practical examples illustrating usage in various scenarios.

1. **[Project workspace setup](https://github.com/ballerina-platform/module-ballerinax-box/tree/main/examples/project_workspace_setup)** - Create a project folder, add a reference web link, optionally invite a collaborator and list the folder contents.

2. **[File review workflow](https://github.com/ballerina-platform/module-ballerinax-box/tree/main/examples/file_review_workflow)** - Read a file, leave a review comment, optionally create a review task and list the file's comments.

## Prerequisites

1. Generate Box credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/box/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "https://api.box.com/oauth2/token"
```

Each example lists the additional values it needs in its own README.

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

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for newly released modules, the following steps are recommended for building examples with the local module.

**NOTE**: If the module contains any breaking changes, make sure to replace the dependency in the example's `Ballerina.toml` with the local one.

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
