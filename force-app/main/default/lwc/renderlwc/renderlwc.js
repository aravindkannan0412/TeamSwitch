import { LightningElement, api } from 'lwc';

export default class Renderlwc extends LightningElement {

    @api recordId; // Pass this from parent or page

    get vfUrl() {
        // Construct the VF page URL with params
        // Replace 'mydomain' and 'MyPdfPage' with your actual domain and page name
        return '/apex/PDFGenerator?pdfName=${this.recordId}';
    }
}