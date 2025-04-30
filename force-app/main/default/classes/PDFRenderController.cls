public with sharing class PDFRenderController {
    public String pdfName { get; set; }
    public String BodyText { get; set; }
    
    public PDFRenderController() {
        pdfName = ApexPages.currentPage().getParameters().get('pdfName');
        BodyText =[select Rental_Agreement__c from RentalAggrementDetail__c where Name=:pdfName limit 1].Rental_Agreement__c ;
    }
}