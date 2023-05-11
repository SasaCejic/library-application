import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDigitalBooks from '@salesforce/apex/BookController.getDigitalBooks';
import confirmDigitalBookPurchase from '@salesforce/apex/BookController.confirmDigitalBookPurchase';


export default class AdvancedBookSearch extends LightningElement {}