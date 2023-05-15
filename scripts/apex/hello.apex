// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// string tempvar = 'Enter_your_name_here';
// System.debug('Hello World!');
// System.debug('My name is ' + tempvar);
// System.debug('My name is ' + tempvar);

//================================
Id paperBookId = [SELECT Id FROM RecordType WHERE SObjectType = 'Book__c' AND Name = 'Paper Book'][0].Id;
system.debug(paperBookId);

String name = [select Name from RecordType where SObjectType = 'Book__c' and Id = '0127g000002R0SkAAK'][0].Name;
system.debug(name);