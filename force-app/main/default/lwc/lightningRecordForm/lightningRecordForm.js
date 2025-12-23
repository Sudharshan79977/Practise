import { LightningElement,api,wire } from 'lwc';
import Account_Object from '@salesforce/schema/Account';
import Account_Name from '@salesforce/schema/Account.Name';
import Account_Phone from '@salesforce/schema/Account.Phone';
import { getRecord } from "lightning/uiRecordApi";
export default class LightningRecordForm extends LightningElement {
    @api recordId;
    @api objectApiName = Account_Object;

    record;
    error;
    AccountName;
    AccountPhone;
    @wire(getRecord,
        {recordId:"$recordId",
        fields:[Account_Name,Account_Phone]
    })
    wireAccount({data,error}){
        if(data){
            this.record = data;
            this.error=undefined;
            this.AccountName = data.fields.Name.value;
            this.AccountPhone = data.fields.Phone.value;
            console.log('record is :',data);
        }else if(error){
            this.error = error;
            this.record = undefined;
        }
    }
}