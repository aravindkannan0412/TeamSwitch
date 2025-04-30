public with sharing class PDFGenQueueableQueue implements Queueable, Database.AllowsCallouts{
    
    private String bookingId;
    private String pdfName;

    public PDFGenQueueableQueue(String bookingId, String pdfName) {
        this.bookingId = bookingId;
        this.pdfName = pdfName;
    }

    public void execute(QueueableContext context) {
        try {
            // Assuming createAndAttachPdf is a static method in a utility class
            PDFGeneratorService.createAndAttachPdf(bookingId, pdfName);
        } catch (Exception e) {
            // Handle error, maybe log it or send a notification
            System.debug('Error generating PDF: ' + e.getMessage());
        }
    }
}