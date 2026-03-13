public class BookingTriggerHandler {

    public static void createInvoices(List<Booking__c> newBookings, Map<Id, Booking__c> oldMap) {

        List<Invoice__c> invoicesToInsert = new List<Invoice__c>();
        Set<Id> propertyIds = new Set<Id>();

        for (Booking__c b : newBookings) {
            if (b.Property__c != null) {
                propertyIds.add(b.Property__c);
            }
        }

        Map<Id, Property__c> propertyMap = new Map<Id, Property__c>(
            [SELECT Id, Price_Per_Unit__c FROM Property__c WHERE Id IN :propertyIds]
        );

        for (Booking__c b : newBookings) {

            Boolean shouldCreateInvoice = false;

            if (oldMap == null) {
                if (b.Status__c == 'Confirmed') {
                    shouldCreateInvoice = true;
                }
            } 
            else {
                if (b.Status__c == 'Confirmed' &&
                    oldMap.get(b.Id).Status__c != 'Confirmed') {
                    shouldCreateInvoice = true;
                }
            }

            if (shouldCreateInvoice && propertyMap.containsKey(b.Property__c)) {

                Property__c prop = propertyMap.get(b.Property__c);

               Invoice__c inv = new Invoice__c();
inv.Name = 'INV-' + b.Id;
inv.Booking__c = b.Id;
inv.Invoice_Amount__c = prop.Price_Per_Unit__c;
inv.Due_Date__c = b.Booking_Date__c.addDays(7);
inv.Status__c = 'Pending';

                invoicesToInsert.add(inv);
            }
        }

        if (!invoicesToInsert.isEmpty()) {
            insert invoicesToInsert;
        }
    }
}