import { LightningElement, wire, track } from 'lwc';
import getMyDeals from '@salesforce/apex/MyDealsController.getMyDeals';
import updateDeals from '@salesforce/apex/MyDealsController.updateDeals';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

    const columns=[
        {label : 'Name', fieldName : 'Name'},
        {label : 'Price', fieldName : 'Price__c', type : 'Currency', editable : true},
        {label : 'Status', fieldName : 'Status__c', type : 'Picklist', editable : true},
        {label : 'Is Promoted', fieldName : 'Is_Promoted__c', type: 'boolean',
            cellAttributes: {iconName: { fieldName: 'promotionIcon' },iconPosition: 'right'}},
        {label : 'Category', fieldName : 'Category__c', type : 'Picklist'}
    ];

export default class MyDeals extends LightningElement {
    columns = columns;
    @track deals = [];
    draftValues = []
    wiredDealResult;

    
    @wire(getMyDeals)
    wiredmyDeals({data,error}) {
        this.wiredDealResult = data;
        console.log('inside method- result :'+ JSON.stringify(data));
        if(data){
            this.deals = data.map(item => ({
                ...item,
                promotionIcon : item.Is_Promoted__c ? 'action:new_opportunity' : null // star icon
            }));
            console.log(JSON.stringify(this.deals));
        }
        else if(error){
            console.error(error.body.message);
        }
    }
    onSaveHandler(event){
        console.log('inside onsavehandler');
        console.log('event.detail.draftValues +',JSON.stringify(event.detail.draftValues));
        const updatedFields = event.detail.draftValues;
        console.log(updatedFields);
        updateDeals({listOfDealsToUpdate : updatedFields}) 
        .then(() => {
            console.log*('Update controller sucessful');
            this.draftValues = [];

            return refreshApex(this.wiredDealResult);
            //return getMyDeals();
        })
        // .then((refreshed) => {
        //     if(refreshed.data){
        //     this.deals = data.map(item => ({
        //         ...item,
        //         promotionIcon : item.Is_Promoted__c ? 'action:new_opportunity' : null // star icon
        //     }));
        // }
        // })

        // .then(data =>{
        //     this.deals = data.map(item => ({
        //         ...item,
        //         promotionIcon : item.Is_Promoted__c ? 'action:new_opportunity' : null // star icon
        //     }));
        // this.draftValues = [];
        // })
        .catch(error => {
            console.log('Error updating deals',JSON.stringify(error));
        })
    }
}