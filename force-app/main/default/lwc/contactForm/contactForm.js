import { LightningElement, track, wire } from 'lwc';
import getActiveAccounts from '@salesforce/apex/ContactFormController.getActiveAccounts';
import saveContact from '@salesforce/apex/ContactFormController.saveContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactForm extends LightningElement {
    firstName = '';
    lastName = '';
    email = '';
    selectedAccount = '';
    accountOptions = [];

    @wire(getActiveAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accountOptions = data.map(acc => ({
                label: acc.Name,
                value: acc.Id
            }));
        } else if (error) {
            console.error('Error fetching accounts:', JSON.stringify(error));
            this.showToast('Error', this.getErrorMessage(error), 'error');
        }
    }

     handleInputChange(event) {
        const field = event.target.dataset.id;
        switch (field) {
            case 'firstName':
                this.firstName = event.target.value;
                break;
            case 'lastName':
                this.lastName = event.target.value;
                break;
            case 'email':
                this.email = event.target.value;
                break;
            default:
                break;
        }
    }

    handleAccountChange(event) {
        this.selectedAccount = event.detail.value;
    }

    handleSave() {
        if (!this.firstName || !this.lastName || !this.email || !this.selectedAccount) {
            this.showToast('Error', 'Please fill all fields before saving', 'error');
            return;
        }

        const newContact = {
            FirstName: this.firstName,
            LastName: this.lastName,
            Email: this.email,
            AccountId: this.selectedAccount
        };

        saveContact({ con: newContact })
            .then(result => {
                this.showToast('Success', result, 'success');
                this.clearForm();
            })
            .catch(error => {
                console.error('Error saving contact:', JSON.stringify(error));
                this.showToast('Error', this.getErrorMessage(error), 'error');
            });
    }

    getErrorMessage(error) {
        if (!error) return 'Unknown error';
        if (Array.isArray(error.body)) {
            return error.body.map(e => e.message).join(', ');
        } else if (error.body && typeof error.body.message === 'string') {
            return error.body.message;
        } else if (error.message) {
            return error.message;
        }
        return JSON.stringify(error);
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    clearForm() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.selectedAccount = '';
    }
}