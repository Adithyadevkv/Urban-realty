public class BookingSummaryEmail {

    public static void sendSummaryEmail() {

        Integer totalBookings = [SELECT COUNT() FROM Booking__c];

        Integer confirmedBookings = [
            SELECT COUNT()
            FROM Booking__c
            WHERE Status__c = 'Confirmed'
        ];

        Integer cancelledBookings = [
            SELECT COUNT()
            FROM Booking__c
            WHERE Status__c = 'Cancelled'
        ];

        Integer pendingBookings = [
            SELECT COUNT()
            FROM Booking__c
            WHERE Status__c = 'Pending'
        ];

        String body = 'Daily Booking Summary\n\n';

        body += 'Total Bookings: ' + totalBookings + '\n';
        body += 'Confirmed Bookings: ' + confirmedBookings + '\n';
        body += 'Cancelled Bookings: ' + cancelledBookings + '\n';
        body += 'Pending Bookings: ' + pendingBookings + '\n';

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new String[] {'your-email@gmail.com'});
        mail.setSubject('Daily Booking Summary Report');
        mail.setPlainTextBody(body);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});

    }

}