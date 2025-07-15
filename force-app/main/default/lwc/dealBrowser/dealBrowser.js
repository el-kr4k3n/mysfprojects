import { LightningElement, track } from 'lwc';
import getFilterdDeals from '@salesforce/apex/DealBrowserController.getFilterdDeals';
import showInterest from '@salesforce/apex/DealBrowserController.showInterest';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


const PAGE_SIZE = 6;

export default class DealBrowser extends LightningElement {
    category = 'All';
    minPrice;
    maxPrice;
    deals = [];
    dealresult = [];
    paginatedDeals = [];
    currentPage = 1;
    

    get catergoryOptions(){
        return [
            { label: 'All', value: 'All' },
            { label: 'Electronics', value: 'Electronics' },
            { label: 'Books', value: 'Books' },
            { label: 'Furniture', value: 'Furniture' },
            { label: 'Others', value: 'Others' } ];
    }

    handlecategoryChange(event){
        this.category = event.detail.value;
        //console.log(this.category);
    }

    handleminpriceChange(event){
        this.minPrice = event.detail.value;
        //console.log(this.minPrice);
    }

    handlemaxpriceChange(event){
        this.maxPrice = event.detail.value;
        //console.log(this.maxPrice);
    }

    applyFilters(event){
        console.log('button clicked',this.minPrice,this.maxPrice,this.category,'end');
        this.minPrice = this.minPrice == null || this.minPrice == ''? 0 : this.minPrice;
        this.maxPrice = this.maxPrice == null || this.maxPrice == '' ? 2147483647 : this.maxPrice;
        getFilterdDeals({category : this.category, minPrice: this.minPrice, maxPrice: this.maxPrice})
                .then(result => {
                // this is working 
                // this.deals = result;
                // console.log(this.deals);

                //adding new property check
                console.log('Result before adding property:',result);

                this.dealresult = result.map(item => {
                    return {...item, isAvailable : item.Status__c == 'Available' ? true : false};
                });

                console.log('Result after adding property:', JSON.stringify(this.dealresult));
                this.setPaginatedDeals();

            })
            .catch(error => {
                this.error = error.body.message;
                console.error('errror:',error)
            });
    }

    setPaginatedDeals(){
        const start = (this.currentPage -1 ) * PAGE_SIZE;
        const end   = (this.currentPage * PAGE_SIZE);
        this.paginatedDeals = this.dealresult.slice(start,end);
        //console.log('Paginated Deals no : ',JSON.stringify(this.paginatedDeals));
    }

    previousPage(event){
        if(!this.isFirstPage){
        this.currentPage -= 1;
        this.setPaginatedDeals();
        }
    }

    nextPage(event){
        if (!this.isLastPage){
            this.currentPage += 1;
            this.setPaginatedDeals();
        }
    }
    get trueValue(){
        return true;
    }
    
    get isFirstPage(){
        return this.currentPage == 1;
    }

    get isLastPage(){
        return this.currentPage * PAGE_SIZE >= this.dealresult.length;
    }

    // isAvailable(status){
    //     return status == 'Available';
    // }

   handleShowInterest(event){
    console.log('event.target:',event.target.dataset);
    const dealID = event.target.dataset.id;
    console.log('Deal ID:',dealID);
    showInterest({ dealId : dealID })
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Deal Interested',
                message: 'Deal with id '+ dealID + ' is Interested',
                variant: 'success'}));
            this.applyFilters();
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title : 'Error',
                message : error.body.message,
                variant : 'error'
            }));
        });
   }
}