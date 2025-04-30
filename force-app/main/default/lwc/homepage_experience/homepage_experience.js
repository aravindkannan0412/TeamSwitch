import { LightningElement, api, wire } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { getRecord } from 'lightning/uiRecordApi';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import getRelatedRecords from '@salesforce/apex/ContactRelatedRecordsController.getRelatedRecords';
import getRelatedRecordsImperative from '@salesforce/apex/ContactRelatedRecordsController.getRelatedRecordsImperative';
import getRelatedContentRecords from '@salesforce/apex/ContactRelatedRecordsController.getRelatedContentRecords';
import getRelatedContentRecordsImperative from '@salesforce/apex/ContactRelatedRecordsController.getRelatedContentRecordsImperative';
import userId from '@salesforce/user/Id';
import { refreshApex } from '@salesforce/apex';
import getContactIdForCurrentUser from '@salesforce/apex/ContactRelatedRecordsController.getContactIdForCurrentUser';



export default class Homepage_experience extends LightningElement {

    relatedData = [];
    errors = [];
    @api objectApiNames;
    bookingdetail;
    porterservice;
    gasservice;
    internetservice;
    tempservice;
    contactId;
    wiredResult;
    contentLink;

   
    @wire(getContactIdForCurrentUser)
    wiredContactId({ error, data }) {
        if (data) {
            this.contactId = data;
            console.log('this.contactId');
            console.log(this.contactId);
        } else if (error) {
            // handle error
        }
    }
    @wire(getRelatedRecords, { contactId: '$contactId' })
    wiredRelatedRecords({ error, data }) {
        if (data) {
            this.wiredResult = data;
            this.bookingdetail = data.bookingdetail?.length > 0 ? data.bookingdetail : undefined;
            console.log(this.bookingdetail);
            this.porterservice = data.porterservice?.length > 0 ? data.porterservice : undefined;
            console.log(this.porterservice);
            this.gasservice = data.gasservice?.length > 0 ? data.gasservice : undefined;
            console.log(this.gasservice);
            this.internetservice = data.internetservice?.length > 0 ? data.internetservice : undefined;
            console.log(this.internetservice);
            this.tempservice = data.tempservice?.length > 0 ? data.tempservice : undefined;
            console.log(this.tempservice);
          
           
        } else if (error) {
            this.error =[ error];
            this.bookingdetail = [];
           
        }
    }


    @wire(getRelatedContentRecords, { contactId: '$contactId' })
    wiredRelatedconRecords({ error, data }) {
        if (data) {
            this.contentLink = data.rentalAgreement;        
           
        } else if (error) {
            this.error =[ error];
            this.bookingdetail = [];
           
        }
    }

    connectedCallback() {
        this.objectApiNames='Gas_Service_Request__ChangeEvent,Booking_Details__ChangeEvent,Internet_Service_Request__ChangeEvent,Temporary_Accommodation_Service__ChangeEvent,Porter_Service_Request__ChangeEvent'
        this.objects = this.objectApiNames?.split(',') || [];
       
        this.subscribeToCDC();
    }
    subscribeToCDC() {
        const channels = this.objects.map(obj => `/data/${obj}`);
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));
            refreshApex(this.wiredResult);
            this.getRecords(); // Now `this` correctly refers to the LWC class
            this.getContentLink();
        };
        channels.forEach(channel => {
            subscribe(channel, -1, messageCallback).then(subscription => {
                this.subscription = subscription;
            });
        });

        onError(error => {
            console.error('CDC Error:', error);
        });
    }

    getContentLink() {
        getRelatedContentRecordsImperative({ contactId: this.contactId })
            .then(result => {
               this.contentLink = result.rentalAgreement;
            })
            .catch(error => {
                this.error = [ error];
                this.contentLink;
            });
    }


    getRecords() {
        getRelatedRecordsImperative({ contactId: this.contactId })
                .then(result => {
                   this.wiredResult = result;
                    this.bookingdetail = result.bookingdetail?.length > 0 ? result.bookingdetail : undefined;
                    console.log(this.bookingdetail);
                    this.porterservice = result.porterservice?.length > 0 ? result.porterservice : undefined;
                    console.log(this.porterservice);
                    this.gasservice = result.gasservice?.length > 0 ? result.gasservice : undefined;
                    console.log(this.gasservice);
                    this.internetservice = result.internetservice?.length > 0 ? result.internetservice : undefined;
                    console.log(this.internetservice);
                    this.tempservice = result.tempservice?.length > 0 ? result.tempservice : undefined;
                    console.log(this.tempservice);
                })
                .catch(error => {
                     this.error =[ error];
                    this.bookingdetail = [];
                });
        }

    disconnectedCallback() {
        unsubscribe(this.subscription);
    }
}