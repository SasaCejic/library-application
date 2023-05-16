import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Book__c.Name';
import ISBN_FIELD from '@salesforce/schema/Book__c.ISBN__c';
import AUTHOR_FIELD from '@salesforce/schema/Book__c.Author__c';
import PUBLISH_DATE_FIELD from '@salesforce/schema/Book__c.Publish_Date__c';
//import BOOKSTORE_FIELD from '@salesforce/schema/Book__c.Bookstore__c';
import CATEGORIES_FIELD from '@salesforce/schema/Book__c.Categories__c';
import LANGUAGE_FIELD from '@salesforce/schema/Book__c.Language__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Book__c.Description__c';
//import PRICE_FIELD from '@salesforce/schema/Book__c.Price__c';
import AUTHOR_OBJECT from '@salesforce/schema/Author__c';
import BOOKSTORE_OBJECT from '@salesforce/schema/Bookstore__c';
import PUBLISHER_OBJECT from '@salesforce/schema/Publisher__c';

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
/*        {
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
    // List that holds objects with labels and values for the author combobox
    authorOptions = [];
    // List that holds objects with labels and values for the bookstore combobox
    bookstoreOptions = [];
    // List that holds objects with labels and values for the publisher combobox
    publisherOptions = [];
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

    handleLoadMore(){

    }

    handleBookSearch(){

    }

}