import { LightningElement, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import getTotalContactsCount from '@salesforce/apex/ContactController.getTotalContactsCount';

const COLUMNS = [
    { label: 'First Name', fieldName: 'FirstName' },
    { label: 'Last Name', fieldName: 'LastName' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Title', fieldName: 'Title' }
];

export default class ContactDataTable extends LightningElement {
    @track contacts = [];
    @track columns = COLUMNS;
    @track totalRecords = 0;
    @track page = 1;
    @track pageSize = 10;
    @track totalPages = 0;

     get isPrevDisabled() {
        return this.page <= 1;
    }

    get isNextDisabled() {
        return this.page >= this.totalPages;
    }

    connectedCallback() {
        this.loadTotalContacts();
        this.loadContacts();
    }

    loadTotalContacts() {
        getTotalContactsCount()
            .then(result => {
                this.totalRecords = result;
                this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            })
            .catch(error => {
                console.error(error);
            });
    }

    loadContacts() {
        const offsetSize = (this.page - 1) * this.pageSize;

        getContacts({ limitSize: this.pageSize, offsetSize: offsetSize })
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleNext() {
        if (this.page < this.totalPages) {
            this.page++;
            this.loadContacts();
        }
    }

    handlePrev() {
        if (this.page > 1) {
            this.page--;
            this.loadContacts();
        }
    }
}