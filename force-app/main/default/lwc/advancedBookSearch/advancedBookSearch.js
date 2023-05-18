import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Book__c.Name';
import ISBN_FIELD from '@salesforce/schema/Book__c.ISBN__c';
import AUTHOR_FIELD from '@salesforce/schema/Book__c.Author__c';
import PUBLISH_DATE_FIELD from '@salesforce/schema/Book__c.Publish_Date__c';
import CATEGORIES_FIELD from '@salesforce/schema/Book__c.Categories__c';
import LANGUAGE_FIELD from '@salesforce/schema/Book__c.Language__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Book__c.Description__c';
//import PRICE_FIELD from '@salesforce/schema/Book__c.Price__c';
import AUTHOR_OBJECT from '@salesforce/schema/Author__c';
import BOOKSTORE_OBJECT from '@salesforce/schema/Bookstore__c';
import PUBLISHER_OBJECT from '@salesforce/schema/Publisher__c';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import BOOK_OBJECT from '@salesforce/schema/Book__c';
import CATEGORIES_PICKLIST from '@salesforce/schema/Book__c.Categories__c';
import LANGUAGE_PICKLIST from '@salesforce/schema/Book__c.Language__c'
import getBooksFromSearchDTO from '@salesforce/apex/BookController.getBooksFromSearchDTO';


export default class AdvancedBookSearch extends LightningElement {
    //object api names for autocompleteComoboxWrappers
    authorApiName=AUTHOR_OBJECT.objectApiName
    bookstoreApiName=BOOKSTORE_OBJECT.objectApiName
    publisherApiName=PUBLISHER_OBJECT.objectApiName

    // Columns to be displayed in book record table
    columns=[
        {
            label: 'Name',
            fieldName: 'NameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: NAME_FIELD.fieldApiName },
            target: '_blank'},
            sortable: true
        },
        {
            label: 'ISBN',
            fieldName: ISBN_FIELD.fieldApiName,
            type: 'text',
            sortable: true
        },
        {
            label: 'Author',
            fieldName: AUTHOR_FIELD.fieldApiName,
            type: 'text',
            sortable: true
        },
        {
            label: 'Publish Date',
            fieldName: PUBLISH_DATE_FIELD.fieldApiName,
            type: 'date',
            sortable: true
        },
        {
            label: 'Categories',
            fieldName: CATEGORIES_FIELD.fieldApiName,
            type: 'text',
            sortable: true
        },
        {
            label: 'Language',
            fieldName: LANGUAGE_FIELD.fieldApiName,
            type: 'text',
            sortable: true
        },
        {
            label: 'Description',
            fieldName: DESCRIPTION_FIELD.fieldApiName,
            type: 'text',
            sortable: true
        },
/*      {
            label: 'Price',
            fieldName: PRICE_FIELD.fieldApiName,
            type: 'text',
            sortable: true
        } */
    ];
    // Column to sort book record table by
    sortBy;
    // Direction to sort book record table in
    sortDirection;
    // List that holds values for he languages listbox
    languagesOptions=[];
    // List that holds values for he categories listbox
    categoriesOptions=[];
    // Value of author search input
    searchAuthorValue = '';
    // Value of bookstore search input
    searchBookstoreValue = '';
    // Value of publisher search input
    searchPublisherValue = '';
    // Value of selected author record
    author=null;
    // Value of selected bookstore record
    bookstore=null;
    // Value of selected publisher record
    publisher=null;
    // List of selected values for the categories dual listbox"
    categories=[];
    // List of selected values for the languages dual listbox"
    languages=[];
    // Value of book name input
    name='';
    // Value of ISBN input
    ISBN='';
    // Value of publish date input
    publishDate=null;
    // Value of maximum price input
    price=0;
    // Value of review score input
    reviewScore=null;
    // Value of term input
    term='';
    // All books currently searched
    books=undefined;
    //Maximum of the price slider
    priceRangeMaximum=500;
    //book default record id
    bookDefaultRecordTypeId;
    //number of book records to retrieve in a single method call
    tableLoadStep=10;
    //offset when retrieving book records
    tableOffset=0;
    //value indicating if more book records can still be retrieved
    moreToLoad=true;
    //DTO used for passing parameters to controller
    bookSearchDTO={};
    //boolean determening if book search returned empty result
    resultsNotFound=false;


    /*
     * Gets book object info
     */
    @wire(getObjectInfo, { objectApiName: BOOK_OBJECT })
    bookObjectInfo;

    /*
     * Gets values for categories picklist options
     */
    @wire(getPicklistValues, { recordTypeId: '$bookObjectInfo.data.defaultRecordTypeId', fieldApiName: CATEGORIES_PICKLIST })
    wireCategoriesPicklist({data, error}) {
        if (data) {
            this.categoriesOptions = [...data.values];
        } else if (error) {
            this.showToast('Error', 'Error while retrieving categories', 'error');
        }
    }

    /*
     * Gets values for languages picklist options
     */
    @wire(getPicklistValues, { recordTypeId: '$bookObjectInfo.data.defaultRecordTypeId', fieldApiName: LANGUAGE_PICKLIST })
    wireLanguagesPicklist({data, error}) {
        if (data) {
            this.languagesOptions = [...data.values];
        } else if (error) {
            this.showToast('Error', 'Error while retrieving languages', 'error');
        }
    }

    /*
     * Methods setting the values of page inputs, comboboxes and listviews to corresponding variables
     */
    handleNameInput(event){
        this.name=event.target.value;
    }
    handleISBNInput(event){
        this.ISBN=event.target.value;
    }
    handleAuthorSelectOption(event){
        this.author=event.detail.value;
    }
    handlePublishDateInput(event){
        this.publishDate=event.target.value;
    }
    handlePublisherSelectOption(event){
        this.publisher=event.detail.value;
    }
    handleBookstoreSelectOption(event){
        this.bookstore=event.detail.value;
    }
    handleCategoriesChange(event){
        this.categories=event.detail.value;
    }
    handleLanguagesChange(event){
        this.languages=event.detail.value;
    }
    handlePriceChange(event){
        this.price=event.target.value;
    }
    handlereviewScoreInput(event){
        this.reviewScore=event.target.value;
    }
    handleTermInput(event){
        this.term=event.target.value;
    }

    handleSorting(){

    }

    handleLoadMore(event){
        this.tableOffset=this.books.length;

        if (this.moreToLoad){
            event.target.isLoading=true;
            this.makeSearchRequest()
        }
    }

    /*
     * Sets data parameters for search
     * Calls makeSearchRequest() function
     */
    handleBookSearch(){
        if (this.template.querySelector('lightning-datatable')) {
                this.template.querySelector('lightning-datatable').isLoading=true
        };
        //set DTO field values and reset data
        this.bookSearchDTO={
            name:this.name,
            ISBN:this.ISBN,
            author:this.author,
            publishDate:this.publishDate,
            bookstore:this.bookstore,
            publisher:this.publisher,
            categories:this.categories,
            languages:this.languages,
            price:this.price,
            reviewScore:this.reviewScore,
            term:this.term
        }
        this.tableOffset=0;
        this.books=[];

        // Apex call
        this.makeSearchRequest();
    }

    /*
     * Queries books from database matching all the parameters that were submited
     * Parameters are sent to controller in the form of a a BookSearchDTO object
     * Implements lazy loading
     */
    makeSearchRequest(){
        getBooksFromSearchDTO({ bookSearchDTO: this.bookSearchDTO, limitSize:this.tableLoadStep, offset:this.tableOffset }).then((data) => {

            let mappedBooks = data.map(recievedBook=>{
                let mappedBook={};

                for(const field in recievedBook){
                    mappedBook[field]=recievedBook[field];
                }
                mappedBook.NameUrl=`/`+recievedBook.Id;
                return mappedBook;
            });
            this.books=[...this.books,...mappedBooks];
            this.resultsNotFound=(this.books.length==0);
            console.log(this.books);

            //if (this.sortBy) this.sortData(this.sortFieldName, this.sortDirection, this.nullToEmpty);
            if (mappedBooks.length<this.tableLoadStep) {
                this.moreToLoad=false;
            }
            else {
                this.moreToLoad=true;
            }
        }).catch((err) => {
            // Handle different type of errors
            if (err.body.message) {
                this.showToast('Error', err.body.message, 'error');
            } else if (err.body.pageErrors) {
                this.showToast('Error', err.body.pageErrors[0].message, 'error');
            } else {
                this.showToast('Error', 'Error while searching books', 'error');
            }
        }).finally(() => {

            if (this.template.querySelector('lightning-datatable')) {
                this.template.querySelector('lightning-datatable').isLoading=false
            };
        })

    }

    /**
     * @param title - title of toast message
     * @param message - message of toast message
     * @param varian - varian of toast message
     */
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }


}