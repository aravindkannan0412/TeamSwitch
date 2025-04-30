public with sharing class ContactRelatedRecordsController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<SObject>> getRelatedRecords(Id contactId) {
        Map<String, List<SObject>> result = new Map<String, List<SObject>>();
        
        // Query booking details
        List<Booking_Details__c> Booking_Details = [
            select Id,  Name, Rental_End_Date__c, House_Number__c, Rental_Start_Date__c, Payment_Frequency__c, createddate,House_Address__c, Tenant_Person__c, Istemporaryallocationneeded__c, Idle_Days__c from Booking_Details__c 
            WHERE Tenant_Person__c = :contactId order by createddate desc limit 1       
        ];
        result.put('bookingdetail', Booking_Details);
        

           // Query booking details
         List<Porter_Service_Request__c> Porter_Service = [
            select Id,  CreatedDate ,Move_Type__c, Notes__c, Scheduled_Date__c, Service_Status__c, Moving_Date__c, From_Address__c, Requested_Date__c, To_Address__c, Vehicle_Type__c, Contact__c, Porter_Detail__c from Porter_Service_Request__c
            WHERE Contact__c = :contactId order by createddate desc limit 1
        ];
        result.put('porterservice', Porter_Service);

                 // Query booking details
         List<Gas_Service_Request__c> Gas_Service = [
            select Id,  Name, Requested_Date__c, Connection_Type__c, Scheduled_Date__c, Service_Status__c, Notes__c, Installation_Required__c, Contact__c, Gas_Detail__c from Gas_Service_Request__c
            WHERE Contact__c = :contactId order by createddate desc limit 1
            
        ];
        result.put('gasservice', Gas_Service);

          // Query booking details
          List<Internet_Service_Request__c> Internet_Service = [
            select Id,  Name,Speed_Requirement__c, Scheduled_Date__c, Usage_Type__c, Installation_Required__c, Service_Status__c, Notes__c, Connection_Type__c, Requested_Date__c, Preferred_ISP__c, Contact__c, Internet_Detail__c from Internet_Service_Request__c
            WHERE Contact__c = :contactId order by createddate desc limit 1
        ];
        result.put('internetservice', Internet_Service);

             // Query booking details
             List<Temporary_Accommodation_Service__c> Temporary_Accommodation_Service = [
                select Id,  Name,  Accommodation_Address__c, Check_In__c, Check_out__c, Duration_of_Stay__c, Number_of_Guests__c, Contact__c, Temporary_Accommodation_Detail__c,Temporary_Accommodation_Detail__r.Accommodation_Name__c,Temporary_Accommodation_Detail__r.Type__c, Status__c  from Temporary_Accommodation_Service__c 
                WHERE Contact__c = :contactId order by createddate desc limit 1            
            ];
            result.put('tempservice', Temporary_Accommodation_Service);


        

        
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static Id getContactIdForCurrentUser() {
        // Query the User record for the current user and return the ContactId
        return [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].ContactId;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getRelatedContentRecords(Id contactId) {
        Map<String, String> result = new Map<String, String>();
        
        // Query booking details
        List<Booking_Details__c> Booking_Details = [
            select Id,  Name, Rental_End_Date__c, House_Number__c, Rental_Start_Date__c, Payment_Frequency__c, createddate,House_Address__c, Tenant_Person__c, Istemporaryallocationneeded__c, Idle_Days__c from Booking_Details__c 
            WHERE Tenant_Person__c = :contactId order by createddate desc limit 1
               
        ];
        
        if(Booking_Details.size() > 0){
            Id contentId = [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: Booking_Details[0].Id].ContentDocumentId;
            string link = '\"'+URL.getOrgDomainURL().toExternalForm() + '/sfc/servlet.shepherd/document/download/' + contentId+'\"';
            result.put('rentalAgreement', link);
        }
        return result;
    }
    
     @AuraEnabled
    public static Map<String, List<SObject>> getRelatedRecordsImperative(Id contactId) {
        Map<String, List<SObject>> result = new Map<String, List<SObject>>();
        
        // Query booking details
        List<Booking_Details__c> Booking_Details = [
            select Id,  Name, Rental_End_Date__c, House_Number__c, Rental_Start_Date__c, Payment_Frequency__c, createddate,House_Address__c, Tenant_Person__c, Istemporaryallocationneeded__c, Idle_Days__c from Booking_Details__c 
            WHERE Tenant_Person__c = :contactId order by createddate desc limit 1
              
        ];
        result.put('bookingdetail', Booking_Details);
        

           // Query booking details
         List<Porter_Service_Request__c> Porter_Service = [
            select Id,  CreatedDate ,Move_Type__c, Notes__c, Scheduled_Date__c, Service_Status__c, Moving_Date__c, From_Address__c, Requested_Date__c, To_Address__c, Vehicle_Type__c, Contact__c, Porter_Detail__c from Porter_Service_Request__c
            WHERE Contact__c = :contactId order by createddate desc limit 1
           
        ];
        result.put('porterservice', Porter_Service);

                 // Query booking details
         List<Gas_Service_Request__c> Gas_Service = [
            select Id,  Name, Requested_Date__c, Connection_Type__c, Scheduled_Date__c, Service_Status__c, Notes__c, Installation_Required__c, Contact__c, Gas_Detail__c from Gas_Service_Request__c
            WHERE Contact__c = :contactId order by createddate desc limit 1
            
        ];
        result.put('gasservice', Gas_Service);

          // Query booking details
          List<Internet_Service_Request__c> Internet_Service = [
            select Id,  Name,Speed_Requirement__c, Scheduled_Date__c, Usage_Type__c, Installation_Required__c, Service_Status__c, Notes__c, Connection_Type__c, Requested_Date__c, Preferred_ISP__c, Contact__c, Internet_Detail__c from Internet_Service_Request__c
            WHERE Contact__c = :contactId order by createddate desc limit 1
             
        ];
        result.put('internetservice', Internet_Service);

             // Query booking details
             List<Temporary_Accommodation_Service__c> Temporary_Accommodation_Service = [
                select Id,  Name,  Accommodation_Address__c, Check_In__c, Check_out__c, Duration_of_Stay__c, Number_of_Guests__c, Contact__c, Temporary_Accommodation_Detail__c,Temporary_Accommodation_Detail__r.Accommodation_Name__c,Temporary_Accommodation_Detail__r.Type__c, Status__c  from Temporary_Accommodation_Service__c 
                WHERE Contact__c = :contactId order by createddate desc limit 1
                
            ];
            result.put('tempservice', Temporary_Accommodation_Service);


        

        
        return result;
    }

    @AuraEnabled
    public static Map<String, String> getRelatedContentRecordsImperative(Id contactId) {
        Map<String, String> result = new Map<String, String>();
        
        // Query booking details
        List<Booking_Details__c> Booking_Details = [
            select Id,  Name, Rental_End_Date__c, House_Number__c, Rental_Start_Date__c, Payment_Frequency__c, createddate,House_Address__c, Tenant_Person__c, Istemporaryallocationneeded__c, Idle_Days__c from Booking_Details__c 
            WHERE Tenant_Person__c = :contactId order by createddate desc limit 1
              
        ];
        
        if(Booking_Details.size() > 0){
            Id contentId = [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: Booking_Details[0].Id].ContentDocumentId;
            string link = '\"'+URL.getOrgDomainURL().toExternalForm() + '/sfc/servlet.shepherd/document/download/' + contentId+'\"';
            result.put('rentalAgreement', link);
        }
        return result;
    }
}