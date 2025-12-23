import { LightningElement ,track,wire} from 'lwc';
import getAccount from '@salesforce/apex/AccountController.getAccount';
import getContacts from '@salesforce/apex/AccountController.getContacts';
import getAccountRealtedContacts  from '@salesforce/apex/AccountController.getAccountRealtedContacts';
export default class ComponentA extends LightningElement {
    account;
 @track AccountRelatedContacts;
     @track accName;

    columns = [
        { label: 'Account Name', fieldName: 'Name' },
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'Industry', fieldName: 'Industry' },
    ];
    contactsColumn = [
        {label : 'Name', fieldName : 'Name'},
        {label : 'Phone', fieldName : 'Phone'},
        {label : 'Email', fieldName : 'Email'},
        {label : 'Title', fieldName : 'Title'},
        {label : 'Department', fieldName : 'Department'}
        ];

    AccountRelatedContactsColumns = [
        { label: 'Contact Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email' },
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'Account Name', fieldName: 'Account.Name' }
    ];

     @wire(getAccount)
        wiredAccount({ error, data }) {
            if (data) {
                this.account = data;
            } else if (error) {
                console.error(error);
            }
        }

    @wire(getContacts)
    wiredContacts({error, data} ){
        if(data){
            this.contacts = data;
        }else if(error){
            console.error(error);
        }
    }   

    handleNameChange(event){
        this.accName = event.target.value;
    }

    searchContacts(){
        getAccountRealtedContacts({AccountName:this.accName})
        .then(result =>{
            this.AccountRelatedContacts = result;
            console.log(result);    
        })
        .catch(error =>{
            console.error(error);
        })
    }      
}