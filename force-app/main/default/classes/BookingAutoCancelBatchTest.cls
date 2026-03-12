@isTest
public class BookingAutoCancelBatchTest {

    @isTest
    static void testBatchExecution(){

        Property__c property = new Property__c(
            Name = 'Test Property',
            Total_Units__c = 10,
            Available_Units__c = 5
        );

        insert property;

        Booking__c booking = new Booking__c(
    Status__c = 'Pending',
    Booking_Date__c = System.today().addDays(-10),
    Property__c = property.Id
);

        insert booking;

        Test.startTest();

        BookingAutoCancelBatch batch = new BookingAutoCancelBatch();

        Database.executeBatch(batch);

        Test.stopTest();

        Booking__c updatedBooking = [
            SELECT Status__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];

        System.assertEquals('Cancelled', updatedBooking.Status__c);

    }

}