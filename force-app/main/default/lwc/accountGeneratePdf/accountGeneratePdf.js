import { LightningElement, api, wire } from 'lwc';
import getAccountWithContacts from '@salesforce/apex/AccountPdfController.getAccountWithContacts';
import generateAccountPdf from '@salesforce/apex/AccountPdfController.generateAccountPdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountGeneratePdf extends LightningElement {
    @api recordId;
    account;
    contacts;

    @wire(getAccountWithContacts, { accountId: '$recordId' })
    wiredData({ data, error }) {
        if (data) {
            this.account = data.account;
            this.contacts = data.contacts;
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleGeneratePdf() {
        generateAccountPdf({ accountId: this.recordId })
            .then(() => {
                this.showToast('Success', 'PDF generated and attached to Account', 'success');
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}