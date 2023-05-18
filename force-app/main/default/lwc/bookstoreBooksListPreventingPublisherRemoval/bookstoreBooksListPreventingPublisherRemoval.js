import { LightningElement, wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

export default class BookstoreBooksListPreventingPublisherRemoval extends LightningElement {
    connectedCallback() {
        console.log('O dadadadada');
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if(currentPageReference) {
            console.log(currentPageReference)
            console.log(currentPageReference.state.c__recordId);
        }
    }
}