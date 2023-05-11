import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDigitalBooks from '@salesforce/apex/BookController.getDigitalBooks';
import confirmDigitalBookPurchase from '@salesforce/apex/BookController.confirmDigitalBookPurchase';


export default class AdvancedBookSearch extends LightningElement {
    // List that holds objects with labels and values for the author combobox
    authorOptions = [];
    // List that holds objects with labels and values for the bookstore combobox
    bookstoreOptions = [];
    // List that holds objects with labels and values for the publisher combobox
    publisherOptions = [];
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
    // Value of minimum price input
    minPrice=null;
    // Value of maximum price input
    maxPrice=null;
    // Value of review score input
    reviewScore=null;
    // Value of term input
    term

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
        
    }



    handleAuthorSearch(){
        
    }

    handlePublisherSearch(){

    }

    handleBookstoreSearch(){

    }

}