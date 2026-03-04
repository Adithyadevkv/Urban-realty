@isTest
public class BookingTriggerHandlerTest {

    @isTest
    static void testInvoiceCreation() {

        // Create Property
        Property__c property = new Property__c(
            Name = 'Test Property',
            Price_Per_Unit__c = 500000,
            Total_Units__c = 10,
            Available_Units__c = 10,
            Status__c = 'Available'
        );
        insert property;

        // Create Buyer
        Buyer__c buyer = new Buyer__c(
            Name = 'Test Buyer',
            Email__c = 'testbuyer@email.com'
        );
        insert buyer;

        // Create Booking
        Booking__c booking = new Booking__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Booking_Date__c = Date.today(),
            Status__c = 'Confirmed'
        );
        insert booking;

        // Check Invoice created
        List<Invoice__c> invoices = [
            SELECT Id, Status__c, Invoice_Amount__c
            FROM Invoice__c
            WHERE Booking__c = :booking.Id
        ];

        System.assertEquals(1, invoices.size());
        System.assertEquals('Pending', invoices[0].Status__c);
    }
}