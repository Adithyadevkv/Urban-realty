public with sharing class PropertyController {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties() {

        return [
            SELECT Id,
                   Name,
                   Total_Units__c,
                   Available_Units__c
            FROM Property__c
        ];
    }
}