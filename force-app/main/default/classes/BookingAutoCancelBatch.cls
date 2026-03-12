global class BookingAutoCancelBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT Id, Status__c, Booking_Date__c, Property__c
            FROM Booking__c
            WHERE Status__c = 'Pending'
            AND Booking_Date__c <= :System.today().addDays(-7)
        ]);

    }

    global void execute(Database.BatchableContext bc, List<Booking__c> scope) {

        List<Property__c> propertiesToUpdate = new List<Property__c>();
        Map<Id, Property__c> propertyMap = new Map<Id, Property__c>();

        Set<Id> propertyIds = new Set<Id>();

        for(Booking__c b : scope){
            if(b.Property__c != null){
                propertyIds.add(b.Property__c);
            }
        }

        if(!propertyIds.isEmpty()){

            for(Property__c p : [
                SELECT Id, Available_Units__c
                FROM Property__c
                WHERE Id IN :propertyIds
            ]){
                propertyMap.put(p.Id, p);
            }

        }

        for(Booking__c booking : scope){

            booking.Status__c = 'Cancelled';

            if(propertyMap.containsKey(booking.Property__c)){

                Property__c prop = propertyMap.get(booking.Property__c);

                prop.Available_Units__c = prop.Available_Units__c + 1;

                propertiesToUpdate.add(prop);

            }

        }

        try{

            update scope;

            if(!propertiesToUpdate.isEmpty()){
                update propertiesToUpdate;
            }

        }catch(Exception e){

            System.debug('Batch Error: ' + e.getMessage());

        }

    }

    global void finish(Database.BatchableContext bc){

        System.debug('Auto cancellation batch completed.');

    }

}