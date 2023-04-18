// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// string tempvar = 'Enter_your_name_here';
// System.debug('Hello World!');
// System.debug('My name is ' + tempvar);


// Author id : a028B000001xOcTQAU
// Book id: a047d000009wIEiAAM
// Bookstore_Book id: a057d00000EE3B6AAL
//Bookstore id: a077d000008o8fsAAA

// Id authorsBookId = [select Id from Book__c where Author__c = 'a027d00000GnnytAAB' limit 1].Id;

// Id bookStoreBookId = [select Id from Bookstore_Book__c where Book__c = 'a047d000009wIEiAAM' limit 1].Id;

// String storeName = [select Id, Bookstore__r.Name from Bookstore_Book__c where Book__c in (select Id from Book__c where Author__c = 'a027d00000GnnytAAB') limit 1].Bookstore__r.Name;

// List<Bookstore_Book__c> bookstoreBooks = [SELECT Bookstore__c FROM Bookstore_Book__c WHERE Book__c IN (SELECT Id FROM Book__c WHERE Author__c = 'a027d00000GnnytAAB')];

Id authorId = 'a028B000001xOcTQAU';
// List <Bookstore_Book__c> bsb = [
//             SELECT
//                 Bookstore__r.Name
//             FROM
//                 Bookstore_Book__c
//             WHERE
//                 Book__c
//             IN (
//                 SELECT
//                     Id
//                 FROM
//                     Book__c
//                 WHERE
//                     Author__c = :authorId
//                 )
//         ];

        // for(Bookstore_Book__c b : bsb){
        //     system.debug(b.Bookstore__r.Name);

        // }


        AggregateResult[] bsb = [
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
            GROUP BY
            Bookstore__c
        ];

        // for(AggregateResult ar : bsb){
        //     system.debug(ar.get('Bookstore__c'));
        // }

        List<Id> bookstoreIds= new List<Id>();

        for(AggregateResult ar : bsb){
            bookstoreIds.add((Id)ar.get('Bookstore__c'));
        }

        List<Bookstore__c> bookstores = [
            SELECT
                Id,
                Name
            FROM
                Bookstore__c
            WHERE
                Id IN :bookstoreIds
        ];

        for(Bookstore__c bs : bookstores){
            system.debug(bs.Name);
        }

