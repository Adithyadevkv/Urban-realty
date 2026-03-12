global class BookingAutoCancelScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        BookingAutoCancelBatch batch = new BookingAutoCancelBatch();

        Database.executeBatch(batch, 200);

    }

}