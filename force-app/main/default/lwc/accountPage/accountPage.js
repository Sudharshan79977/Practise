import { LightningElement, wire } from 'lwc';
import getAccount from '@salesforce/apex/AccountController.getAccount';

export default class AccountPage extends LightningElement {
    @wire(getAccount)
    account;
    columns = [
        { label: 'Account Name', fieldName: 'Name' },
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'Industry', fieldName: 'Industry' },
    ];

}