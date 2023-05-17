import { LightningElement, api, track } from 'lwc';

export default class ComboboxAutocomplete extends LightningElement {

    @api label;
    @api placeholder;
    @api value;
    @api options;
    @api isLoading;
    
    @track isFocussed = false;
    @track isOpen = false;

    domElement;
    
    _handleOutsideClick;

    constructor() {
        super();
        this._handleOutsideClick = this.handleOutsideClick.bind(this);
    }

    connectedCallback() {
        document.addEventListener('click', this._handleOutsideClick);
    }

    disconnectedCallback() {
        document.removeEventListener('click', this._handleOutsideClick);
    }

    filterOptions(event) {
        const filterText = event.detail.value;
        if (filterText === '') {
            this.options = [];
        } 
        const custEvent = new CustomEvent(
            'search', {
                detail: {
                    searchTerm: filterText
                }
            }
        )
        this.dispatchEvent(custEvent);
    }

    handleSelectOption(event) {
        this.value = event.currentTarget.dataset.label;
        const custEvent = new CustomEvent(
            'selectoption', {
                detail: {
                    value: event.currentTarget.dataset.value,
                    label: event.currentTarget.dataset.label
                },
                composed: true,
                bubbles: true
            }
        );
        this.dispatchEvent(custEvent);

        // Set options to selected value
        this.options = [{
            value: event.currentTarget.dataset.value,
            label: event.currentTarget.dataset.label
        }]
        
        // Close the picklist options
        this.isFocussed = false;
        this.isOpen = false;
    }

    get noOptions() {
        return this.options.length === 0;
    }

    get dropdownClasses() {
        
        let dropdownClasses = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        
        // Show dropdown list on focus
        if (this.isOpen) {
            dropdownClasses += ' slds-is-open';
        }

        return dropdownClasses;
    }

    handleOutsideClick(event) {

        if ((!this.isFocussed) && (this.isOpen)) { 

            //Fetch the dropdown DOM node
            let domElement = this.template.querySelector('div[data-id="resultBox"]');

            //Is the clicked element within the dropdown 
            if (domElement && !domElement.contains(event.target)) {
                this.isOpen = false;
            }
        }
    }

    handleFocus() {
        this.isFocussed = true;
        this.isOpen = true;
    }

    handleBlur() {
        this.isFocussed = false;
    }
}
