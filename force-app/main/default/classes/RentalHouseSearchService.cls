public with sharing class RentalHouseSearchService {

    public class RentalHouseSearchRequest {
        @InvocableVariable(required=true)
        public Integer numberOfBedrooms;

        @InvocableVariable(required=true)
        public Integer numberOfBathrooms;

        @InvocableVariable(required=true)
        public String locality;

        @InvocableVariable
        public Integer areaInSqft;

        @InvocableVariable
        public String propertyType;
        
        @InvocableVariable
        public Double PredicterRentalPrice;

        @InvocableVariable(required=true)
        public String furnishStatus;
    }


    @InvocableMethod(label='Search Rental Houses' description='Finds and lists rental houses based on filters')
    public static List<String> searchRentalHouses(List<RentalHouseSearchRequest> requests) {
        
        if (requests == null || requests.isEmpty()) {
            return new List<String>();
        }

        RentalHouseSearchRequest req = requests[0];

        // Basic validation
        if (req.numberOfBedrooms == null || req.numberOfBathrooms == null || 
            String.isBlank(req.locality) || String.isBlank(req.furnishStatus)) {
            return new List<String>();
        }
        
       String query = 'SELECT AddressLine__c, Area__c, City__c, furnish_type__c, House_Id__c, NoOfbedroom__c, NoOfBathrooms__c, locality__c, rentalprice__c FROM Pune_Available_Rental_Houses__dlm WHERE ' +
                      'NoOfbedroom__c = ' + req.numberOfBedrooms +
                      ' AND NoOfBathrooms__c = ' + req.numberOfBathrooms +
                      ' AND locality__c = \'' + String.escapeSingleQuotes(req.locality) + '\'' +
                      ' AND furnish_type__c = \'' + String.escapeSingleQuotes(req.furnishStatus) + '\'';

    if (req.areaInSqft != null) {
        query += ' AND area__c = ' + req.areaInSqft;
    }
    if (String.isNotBlank(req.propertyType)) {
        query += ' AND property_type__c = \'' + String.escapeSingleQuotes(req.propertyType) + '\'';
    }
    if (req.PredicterRentalPrice!=null) {
        query += ' AND rentalprice__c <= ' + req.PredicterRentalPrice;
    }
    
    query += ' LIMIT 3';
            
        List<Pune_Available_Rental_Houses__dlm > rentalHouses = Database.query(query);



        // Build response list
        List<String> responses = new List<String>();
        
        String htmlOutput = '<div style="display: flex; gap: 16px; overflow-x: auto; padding: 16px;">';

        for (Pune_Available_Rental_Houses__dlm house : rentalHouses) {
            htmlOutput += '<div style="flex: 0 0 auto; border: 1px solid #ccc; border-radius: 8px; padding: 16px; width: 300px; box-shadow: 2px 2px 8px rgba(0,0,0,0.1);">';
            htmlOutput += '<h3>House ID: ' + house.House_Id__c + '</h3>';
            htmlOutput += '<p><strong>Address:</strong> ' + house.AddressLine__c + '</p>';
            htmlOutput += '<p><strong>Locality:</strong> ' + house.locality__c + '</p>';
            htmlOutput += '<p><strong>City:</strong> ' + house.City__c + '</p>';
            htmlOutput += '<p><strong>Area:</strong> ' + house.Area__c + ' sq ft</p>';
            htmlOutput += '<p><strong>Bedrooms:</strong> ' + house.NoOfbedroom__c + '</p>';
            htmlOutput += '<p><strong>Bathrooms:</strong> ' + house.NoOfBathrooms__c + '</p>';
            htmlOutput += '<p><strong>Furnish Status:</strong> ' + house.furnish_type__c + '</p>';
            htmlOutput += '<p><strong>Rental Price:</strong> ₹' + house.rentalprice__c + ' / month</p>';
            htmlOutput += '</div>';
        }

        htmlOutput += '</div>';
        
        responses.add(htmlOutput);
        
        return responses;
   
    }
}