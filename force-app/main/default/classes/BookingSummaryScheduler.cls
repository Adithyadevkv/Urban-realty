global class BookingSummaryScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        BookingSummaryEmail.sendSummaryEmail();

    }

}