public class BookingTriggerHandler {

    public static void createInvoices(List<Booking__c> newBookings) {

        List<Invoice__c> invoicesToInsert = new List<Invoice__c>();

        Set<Id> propertyIds = new Set<Id>();

        for (Booking__c booking : newBookings) {
            if (booking.Status__c == 'Confirmed' && booking.Property__c != null) {
                propertyIds.add(booking.Property__c);
            }
        }

        Map<Id, Property__c> propertyMap = new Map<Id, Property__c>(
            [SELECT Id, Price_Per_Unit__c FROM Property__c WHERE Id IN :propertyIds]
        );

        for (Booking__c booking : newBookings) {

            if (booking.Status__c == 'Confirmed' && propertyMap.containsKey(booking.Property__c)) {

                Property__c property = propertyMap.get(booking.Property__c);

                Invoice__c invoice = new Invoice__c();

                invoice.Booking__c = booking.Id;
                invoice.Invoice_Amount__c = property.Price_Per_Unit__c;
                invoice.Due_Date__c = booking.Booking_Date__c.addDays(7);
                invoice.Status__c = 'Pending';

                invoicesToInsert.add(invoice);
            }
        }

        if (!invoicesToInsert.isEmpty()) {
            insert invoicesToInsert;
        }
    }
}