# Mocker
## About
A class used for mocking and stubbing dependencies during Unit Testing

## Setup

Since this repo is used as a git submodule the structure had to be altered and most of the default files had to be
cleaned up. This means that if you need to checkout this repo to contribute or just to play around, there are some steps
that you need to take in order to make it work, as you won't be able to simply deploy because in this state it is
neither Metadata Project nor SFDX Project.

1. Checkout the repo in your file system
2. Open WebStorm -> File -> New -> Project
3. Choose "Illuminated Cloud SFDX" as the project type
4. For location provide the folder of the checked out repo
5. Optional: Uncheck "Generate offline symbol table"
6. Click "Create" and confirm that this is a repository from an existing project
7. Illuminated Cloud -> Configure Module -> Mark "main" and "test" as source folders
8. Open "sfdx-project.json" and replace the "packageDirectories" with the
   following `"packageDirectories": [ { "path": "force-app", "default": true }, { "path": "main" }, { "path": "test" } ]`
9. Push the source code

Note that you will still have "force-app" folder which will be git ignored. This means that if you are making changes
in the org, once you pull, all changes will automatically end up in your "force-app" folder. However, if you make
changes to an already existing metadata that is in "main" or "test" folder, it will be automatically updated on pull.
In case you need to add a fresh metadata to the repo, you should do as follows:

1. For this example, let's assume you will be adding a new field in the Log__c sObject
2. Pull the changes
3. Locate the metadata for the field in the "force-app" folder, cut it and paste it in the respective directory in "
   main"
4. Run `sfdx:force:source:tracking:reset` or `sfdx:force:source:tracking:clear`. See IMPORTANT note below for more info.
5. Now you can commit your changes and safely push or pull metadata

IMPORTANT: If you try to pull or push before running reset or clear you will get an error. This is because you messed up
the internal tracking of SFDX by manually moving the metadata. One way to fix this is to reset or clear the tracking of
your code against the org or/and vice versa. Be cautious with these commands because if you still have changes in the org
that you haven't pulled yet, YOU MIGHT LOSE THEM. Depending on the command you use, SFDX might lose all track of the 
differences between the org and your code which will leave it to you to cherry-pick them. Another unfortunate scenario
is if decide to force push before pulling all changes which can result in overriding metadata that you haven't synced yet.
Make sure you familiarize yourself with [sfdx:force:source:reset](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_source.htm#cli_reference_force_source_tracking_reset) 
and [sfdx:force:source:clear](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_source.htm#cli_reference_force_source_tracking_clear) 
before using them. These command can be extremely useful in your day-to-day job, so the sooner you know how to properly
use them, the better.

## Usage
```
// Creating a mock
AccountService httpServiceMock = (AccountService) new Mocker(AccountService.class).setBehavior('getAccountType', 'Account').getMock();

// Creating a mock that would thrown an exception
AccountService httpServiceMock = (AccountService) new Mocker(AccountService.class).setBehavior('getAccountType', new MyCustomException('Fail').getMock();
```

## Note
This is a simple service which utilizes the functionality of System.StubProvider. For more info see the links 
- https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_interface_System_StubProvider.htm
- https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_stub_api.htm