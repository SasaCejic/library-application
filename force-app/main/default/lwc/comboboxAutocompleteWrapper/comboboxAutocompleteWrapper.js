import { LightningElement, api, track } from 'lwc';
import searchObject from '@salesforce/apex/ObjectSearchController.searchObject';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ComboboxAutocompleteWrapper extends LightningElement {
    @track options = [];
    @api label;
    @api placeholder;
    @api objectName;
    @api recordTypeId;
    isLoading = false;

    /**
     * @param event - event propagated from comboboxautocomplete component holding search value
     */
    handleSearch(event) {
        window.clearTimeout(this.delay)
        this.searchTerm = event.detail.searchTerm;

        this.delay = setTimeout(() => {

            if (this.searchTerm === '') {
                const custEvent = new CustomEvent(
                    'selectoption', {
                        detail: {
                            value: null,
                            label: null
                        },
                        composed: true,
                        bubbles: true
                    }
                );
                this.dispatchEvent(custEvent);
                return;
            }
            this.search(this.objectName, this.recordTypeId, this.searchTerm);
        }, 300);
    }

    /**
     * @param objectName - name of the object being searched provided by parent component
     * @param recordTypeId - record type Id of parent object propagated by parent component
     * @param searchTerm - value of the search in the input propagated by comboboxAutocomplete component
     */
    search(objectName, recordTypeId, searchTerm) {
        this.isLoading = true;
        // Apex call
        searchObject({ objectName: objectName, recordTypeId: recordTypeId, searchTerm: searchTerm }).then((result) => {
            this.options = [];
            result.forEach(book => {
                this.options.push({
                    label: book.Name,
                    value: book.Id
                })
            });
        }).catch(() => {
            this.showToast('Error', 'Error while performing search', 'error');
        }).finally(() => {
            this.isLoading = false;
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