public with sharing class PDFGeneratorService {
   
    public class PDFGenerationRequest {
        @InvocableVariable(required=true)
        public Id BookingId;

        @InvocableVariable(required=true)
        public String PDFName;
    }

    @InvocableMethod(label='Generate PDF Document' description='This Generates PDF and attach it to the record')
    public static void generatePDFAndAttachToRecord(List<PDFGenerationRequest> pdfRequest){

        String pdfName=pdfRequest[0].PDFName;
        // Create the PageReference
        String PgRef='/apex/PDFGenerator?pdfName='+pdfName;
        PageReference pdfPage = new PageReference(PgRef);
        // Generate PDF
        Blob pdfBlob = pdfPage.getContentAsPDF();
        
        // Create a ContentVersion record to store the PDF
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = pdfName;
        contentVersion.PathOnClient = pdfName+'.pdf'; // You can give it any name here
        contentVersion.VersionData = pdfBlob;
        contentVersion.IsMajorVersion = true;
        insert contentVersion;
        
        // Get the ContentDocument Id
        ContentVersion insertedVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
                
        // Now, you can associate the ContentDocument with a record (e.g., Account, Contact)
        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = insertedVersion.ContentDocumentId;
        contentDocLink.LinkedEntityId = pdfRequest[0].BookingId; // Replace with the desired record Id (e.g., Account Id)
        contentDocLink.ShareType = 'V'; // 'V' is for Viewer access
        contentDocLink.Visibility = 'AllUsers'; // This can be 'AllUsers', 'InternalUsers', etc.
        insert contentDocLink;
    }


    public static void createAndAttachPdf(String bookingId, String pdfName) {
        // Create the PageReference
        String PgRef='/apex/PDFGenerator?pdfName='+pdfName;
        PageReference pdfPage = new PageReference(PgRef);
        // Generate PDF
        Blob pdfBlob = pdfPage.getContentAsPDF();
        
        // Create a ContentVersion record to store the PDF
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = pdfName;
        contentVersion.PathOnClient = pdfName+'.pdf'; // You can give it any name here
        contentVersion.VersionData = pdfBlob;
        contentVersion.IsMajorVersion = true;
        insert contentVersion;
        
        // Get the ContentDocument Id
        ContentVersion insertedVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
                
        // Now, you can associate the ContentDocument with a record (e.g., Account, Contact)
        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = insertedVersion.ContentDocumentId;
        contentDocLink.LinkedEntityId = bookingId; // Replace with the desired record Id (e.g., Account Id)
        contentDocLink.ShareType = 'V'; // 'V' is for Viewer access
        contentDocLink.Visibility = 'AllUsers'; // This can be 'AllUsers', 'InternalUsers', etc.
        insert contentDocLink;
    }
}