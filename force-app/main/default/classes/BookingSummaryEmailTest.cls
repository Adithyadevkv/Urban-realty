@isTest
public class BookingSummaryEmailTest {

    @isTest
    static void testSummaryEmail() {

        Test.startTest();

        BookingSummaryEmail.sendSummaryEmail();

        Test.stopTest();

    }

}