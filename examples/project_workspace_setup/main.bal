// Creates a project workspace folder, adds a reference web link to it, optionally invites a
// collaborator and lists the folder contents.

import ballerina/io;
import ballerinax/box;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string parentFolderId = ?;
configurable string workspaceName = ?;
configurable string referenceUrl = ?;
configurable string collaboratorLogin = "";
configurable boolean inviteCollaborator = false;

public function main() returns error? {
    if inviteCollaborator && collaboratorLogin == "" {
        return error("collaboratorLogin must be set when inviteCollaborator is true");
    }

    box:Client boxClient = check new ({
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            refreshUrl
        }
    });

    // Step 1: Create the workspace folder.
    box:FolderFull workspace = check boxClient->createFolder({
        name: workspaceName,
        parent: {id: parentFolderId}
    });
    io:println("Created folder ", workspace.name, " with ID ", workspace.id);

    // Step 2: Add a reference link to the workspace.
    box:WebLink link = check boxClient->createWebLink({
        url: referenceUrl,
        parent: {id: workspace.id},
        name: "Project reference"
    });
    io:println("Added web link ", link.id);

    // Step 3: Invite a collaborator. This sends an invitation, so it only runs when enabled.
    if inviteCollaborator {
        box:Collaboration collaboration = check boxClient->createCollaboration({
            item: {id: workspace.id, 'type: "folder"},
            accessibleBy: {login: collaboratorLogin, 'type: "user"},
            role: "editor"
        });
        io:println("Invited ", collaboratorLogin, " as editor, collaboration ID ", collaboration.id);
    }

    // Step 4: List the folder contents.
    box:Items items = check boxClient->listItemsInFolder(workspace.id);
    foreach box:Item item in items.entries ?: [] {
        io:println("Item: ", item.id);
    }
}
