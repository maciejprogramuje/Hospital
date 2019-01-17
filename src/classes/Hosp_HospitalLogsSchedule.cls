global class Hosp_HospitalLogsSchedule implements Schedulable {

    public static String timeSchedule = Hosp_Utils.getDeleteHospitalLogsScheduleTime();


    global static String scheduleMe() {
        Hosp_HospitalSchedule hospitalSchedule = new Hosp_HospitalSchedule();
        return System.schedule('Insert Hospital Job', timeSchedule, hospitalSchedule);
    }

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Hosp_HospitalLogsBatch(),200);
    }
}