import LightningDatatable from 'lightning/datatable';
import linkList from './linkList.html';

export default class DatatableWithLinkList extends LightningDatatable {
    static customTypes = {
        linkList: {
            template: linkList
        }
    };
}