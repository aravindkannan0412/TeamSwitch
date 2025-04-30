trigger PdfGeneratorEvent on PDF_Generator__e (after insert) {
    List<PDFGenQueueableQueue> queueables = new List<PDFGenQueueableQueue>();

    for (PDF_Generator__e event : Trigger.New) {
        if (String.isNotBlank(event.BookingId__c) && String.isNotBlank(event.PDFName__c)) {
            System.enqueueJob(new PDFGenQueueableQueue(event.BookingId__c, event.PDFName__c));
        }
    }
}