import { LightningElement, api, track } from 'lwc';

export default class ComboboxAutocomplete extends LightningElement {

    @api classes;
    @api label;
    @api placeholder;
    @api value;
    @api options;
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
        window.clearTimeout(this.delayTimeout);
		const searchValue = event.target.value;
		this.delayTimeout = setTimeout(() => {
            const customEvent = new CustomEvent('search', {
                detail: {
                    searchTerm: searchValue
                }
            })
            this.dispatchEvent(customEvent)
		}, 300);
    }

    handleSelectOption(event) {
        this.value = event.currentTarget.dataset.label;
        const customEvent = new CustomEvent('selectoption', {
                detail: {
                    value: event.currentTarget.dataset.value,
                    label: event.currentTarget.dataset.label
                }
            }
        );
        this.dispatchEvent(customEvent);

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
        const customEvent = new CustomEvent('search', {
            detail: {
                searchTerm: this.value
            }
        })
        this.dispatchEvent(customEvent)
        this.isFocussed = true;
        this.isOpen = true;
    }

    handleBlur() {
        this.isFocussed = false;
    }
}
