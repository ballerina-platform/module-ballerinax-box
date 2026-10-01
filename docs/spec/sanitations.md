_Author_:  @DimuthuMadushan \
_Created_: 2026/10/01 \
_Updated_: 2026/10/01 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Box.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/box/box/2024.0/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Rename operation IDs

- **Original**: Operation IDs produced by flatten/align were path-encoded, for example `get_files_id` and `put_files_id_versions_id`.
- **Updated**: Every operation has an intent-revealing camelCase ID derived from its summary, for example `getFileInformation` and `restoreFileVersion`. The Shield information barrier operations use the shorter `ShieldBarrier` form to stay within 37 characters. The decisions are persisted in `docs/spec/ai-mappings.json` so that a regeneration reproduces them.
- **Reason**: Path-encoded names are not usable as Ballerina method names.

2. Rename generated schemas

- **Original**: Flattening produced schema names such as `FilesfileIdBody`, `UsersAllOf1` and `FilesfileIdaddSharedLinkSharedLinkPermissions`.
- **Updated**: Request bodies are named `<Operation>Request` (for example `UpdateFileRequest`), inline objects are lifted to descriptive names (for example `FileLock`, `AddFileSharedLinkPermissions`), and the remaining `allOf`/`oneOf` fragments are named `<Schema>PartN` and `<Schema>VariantN`. The decisions are persisted in `docs/spec/ai-mappings.json`.
- **Reason**: The generated names contain fused path segments and positional suffixes that are not readable.

3. Remove duplicated properties across `allOf` members

- **Original**: `Users` and `Items` include two members that both declare `limit`, and `MetadataTemplateFields` includes two members that both declare `options`.
- **Updated**: The duplicate declaration is removed from the later member in each schema, edited directly in the aligned spec `docs/spec/aligned_ballerina_openapi.json` (`UsersPart12.limit`, `ItemsPart12.limit` and `MetadataFieldReadVariant2.options`). The source `openapi.yaml` is unchanged.
- **Reason**: Ballerina rejects a record that includes two types declaring the same field (`redeclared symbol`).

4. Narrow image responses to binary content

- **Original**: `getFileThumbnail` declares `image/jpg` and `image/png`, and `getUserAvatar` declares `image/jpg`.
- **Updated**: Both return `application/octet-stream` with `format: binary`, edited directly in the aligned spec `docs/spec/aligned_ballerina_openapi.json`.
- **Reason**: Multiple image media types would otherwise generate an `http:Response` return; a single binary type returns `byte[]`.

5. Drop the request body of `OPTIONS /files/content`

- **Original**: `preflightCheckBeforeUpload` sends a JSON body with the file name, size and parent folder.
- **Updated**: The request body is removed directly in the aligned spec `docs/spec/aligned_ballerina_openapi.json`, so the operation sends the preflight request without a body.
- **Reason**: `bal openapi` emits no HTTP call for an `OPTIONS` operation that has a request body, so the generated client does not compile.

6. Keep the `#fragment` path keys (known limitation)

- **Original**: The shared-link operations on `/files/{fileId}`, `/folders/{folderId}`, `/web_links/{webLinkId}`, `/shared_items`, `/oauth2/token` and the classification schema paths use `#fragment` suffixes to distinguish operations that share a method and path. There are 19 such operations.
- **Updated**: The suffixes are kept in the path keys, so each operation stays separately addressable.
- **Reason**: They make the path keys unique. The generated client appends the query string after the fragment, and the HTTP client drops everything after `#`, so the request is sent to the base path without the operation's query parameters (for example `fields`). The request body and path parameters are unaffected. The mock service is generated without these paths because `bal openapi --mode service` rejects them.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --client-methods remote --license docs/license.txt -o ballerina
```

Note: The license year is hardcoded to 2026, change if necessary.
