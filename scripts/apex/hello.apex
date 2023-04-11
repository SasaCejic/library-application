// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// string tempvar = 'Enter_your_name_here';
// System.debug('Hello World!');
// System.debug('My name is ' + tempvar);


// Author id : a027d00000GnnytAAB
// Book id: a047d000009wIEiAAM
// Bookstore_Book id: a057d00000EE3B6AAL
//Bookstore id: a077d000008o8fsAAA

Id authorsBookId = [select Id from Book__c where Author__c = 'a027d00000GnnytAAB' limit 1].Id;

Id bookStoreBookId = [select Id from Bookstore_Book__c where Book__c = 'a047d000009wIEiAAM' limit 1].Id;

String storeName = [select Id, Bookstore__r.Name from Bookstore_Book__c where Book__c in (select Id from Book__c where Author__c = 'a027d00000GnnytAAB') limit 1].Bookstore__r.Name;

List<Bookstore_Book__c> bookstoreBooks = [SELECT Bookstore__c FROM Bookstore_Book__c WHERE Book__c IN (SELECT Id FROM Book__c WHERE Author__c = 'a027d00000GnnytAAB')];

Id authorId = 'a027d00000GnnytAAB';
List <Bookstore_Book__c> bsb = [
            SELECT
                Bookstore__c
            FROM
                Bookstore_Book__c
            WHERE
                Book__c
            IN (
                SELECT
                    Id
                FROM
                    Book__c
                WHERE
                    Author__c = :authorId
                )
        ];

        for(Bookstore_Book__c b : bsb){
            system.debug(b.Bookstore__c);

            Id bsId = b.Bookstore__c;

        }

        List<Bookstore> = 