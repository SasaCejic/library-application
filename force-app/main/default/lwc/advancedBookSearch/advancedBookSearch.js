import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Book__c.Name';
import ISBN_FIELD from '@salesforce/schema/Book__c.ISBN__c';
import PUBLISH_DATE_FIELD from '@salesforce/schema/Book__c.Publish_Date__c';
import CATEGORIES_FIELD from '@salesforce/schema/Book__c.Categories__c';
import LANGUAGE_FIELD from '@salesforce/schema/Book__c.Language__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Book__c.Description__c';
import PRICE_FIELD from '@salesforce/schema/Book__c.Price__c';
import AUTHOR_OBJECT from '@salesforce/schema/Author__c';
import BOOKSTORE_OBJECT from '@salesforce/schema/Bookstore__c';
import PUBLISHER_OBJECT from '@salesforce/schema/Publisher__c';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import BOOK_OBJECT from '@salesforce/schema/Book__c';
import CATEGORIES_PICKLIST from '@salesforce/schema/Book__c.Categories__c';
import LANGUAGE_PICKLIST from '@salesforce/schema/Book__c.Language__c'
import getBooksFromSearchDTO from '@salesforce/apex/BookController.getBooksFromSearchDTO';
import CURRENCY from "@salesforce/i18n/currency";
import { NavigationMixin } from 'lightning/navigation';



export default class AdvancedBookSearch extends NavigationMixin(LightningElement) {
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
            fieldName: 'Author',
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
        {
            label: 'Bookstores',
            fieldName: 'Bookstores',
            type: 'linkList',
        },
     {
            label: 'Price',
            fieldName: PRICE_FIELD.fieldApiName,
            type: 'currency',
            sortable: true
        }
    ];
    // Column to sort book record table by
    sortBy;
    // Direction to sort book record table in
    sortDirection;
    // Key of the book object corresponding to the sortBy column
    sortFieldName;
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
    reviewScore=0;
    // Value of term input
    term='';
    // All books currently searched
    _books=undefined;
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
    //label with currency for price slider
    priceLabel=`Maximum price (${CURRENCY}):`

    // setter
    set books(value) {
        this._books = value;
    }
    
    // getter
    get books() {
        if (this._books && this.sortFieldName && this.sortDirection) {
            let isReverse = this.sortDirection === 'asc' ? 1: -1;
            let sortedBooks=[...this._books];

            sortedBooks.sort((x, y) => {
                x = this.nullToEmpty(x[this.sortFieldName]);
                y = this.nullToEmpty(y[this.sortFieldName]);
                return isReverse * ((x > y) - (y > x));
            });
            this._books=sortedBooks;
        }
        return this._books
    }

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

    /*
     * Returns empty string if passed parameter is null, otherwise returns unchanged parameter
     * Used for sorting
     */
    nullToEmpty(val){
        return val ? val : '';
    }

    /*
     * Sets relevant sorting data when datatable column header is clicked and sort is initiated
     */
    handleSorting(event){
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortFieldName=this.sortBy=='NameUrl'?NAME_FIELD.fieldApiName:this.sortBy;
    }

    /*
     * Sets tableOffset value to number of currently queried books
     * Check if there is more data to be queried through lazy loading
     * If more data is found, calls  makeSearchRequest() function
     */
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
        if (this.template.querySelector('c-datatable-with-link-list')) {
                this.template.querySelector('c-datatable-with-link-list').isLoading=true
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
        this._books=[];

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
                mappedBook.Author=recievedBook.Author__r.Name;

                if (recievedBook.Bookstore_Books__r){
                    mappedBook.Bookstores=[];

                    for (let bookstore_book of recievedBook.Bookstore_Books__r){
                        mappedBook.Bookstores.push({
                            value:'/'+bookstore_book.Bookstore__c,
                            label:bookstore_book.Bookstore__r.Name
                        });
                    }
                }
                return mappedBook;
            });
            this._books=[...this._books,...mappedBooks];

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

            if (this.template.querySelector('c-datatable-with-link-list')) {
                this.template.querySelector('c-datatable-with-link-list').isLoading=false
            };
        })

    }

    /*
     * Navigates to Buy Digital Book custom component
     */
    handleBuyBook(){
        this[NavigationMixin.Navigate]({
            "type": "standard__component",
            "attributes": {
                "componentName": "c__buyDigitalBookWrapper"
            }
        });
    }

    /**
     * @param title - title of toast message
     * @param message - message of toast message
     * @param variant - varian of toast message
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