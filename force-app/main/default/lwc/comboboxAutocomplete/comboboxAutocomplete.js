import { LightningElement, api, track } from 'lwc';

export default class ComboboxAutocomplete extends LightningElement {
    // holds the value of classes for the whole container
    @api classes;
    // lable of the input
    @api label;
    // placeholder of the input
    @api placeholder;
    // value of the input
    @api value;
    // options for the picklist
    @api options;
    // Boolean indicating if input is focused
    @track isFocussed = false;
    // Boolean indicating if picklist is open
    @track isOpen = false;
    // dom
    domElement;
    // value of handleOutsideClick method binded
    _handleOutsideClick;

    // binds the method
    constructor() {
        super();
        this._handleOutsideClick = this.handleOutsideClick.bind(this);
    }

    /*
     * Adds method to the event listener for the whole container
     */
    connectedCallback() {
        document.addEventListener('click', this._handleOutsideClick);
    }

    /*
     * Removes the method from event listener
     */
    disconnectedCallback() {
        document.removeEventListener('click', this._handleOutsideClick);
    }

    /*
     * Implements debounce for search and sends event to the parent container which retrieves searched books from database
     * @param event - event of input field
     */
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

    /*
     * When anything is selected from picklist propagates event with selected value to parent container
     * @event - Value of data from div
     */
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
    
    /*
     * Returns true if there are no options to display
     */
    get noOptions() {
        return this.options.length === 0;
    }

    /*
     * Returns classes depending if picklis is open or not
     */
    get dropdownClasses() {
        let dropdownClasses = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        // Show dropdown list on focus
        if (this.isOpen) {
            dropdownClasses += ' slds-is-open';
        }
        return dropdownClasses;
    }

    /*
     * When clicked outside of input or picklist will close the picklist and unfocs input
     */
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
    
    /*
     * When input is focused sends event to parent container to filter based on what is in input field
     */
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

    /*
     * Handles onblur property by unfocusing
     */
    handleBlur() {
        this.isFocussed = false;
    }
}
