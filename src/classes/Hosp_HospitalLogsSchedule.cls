global class Hosp_HospitalLogsSchedule implements Schedulable {

    public static String timeSchedule = Hosp_Utils.getDeleteHospitalLogsScheduleTime();


    global static String scheduleMe() {
        Hosp_HospitalLogsSchedule hospitalSchedule = new Hosp_HospitalLogsSchedule();
        return System.schedule('Delete Hospital Logs Job', timeSchedule, hospitalSchedule);
    }

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Hosp_HospitalLogsBatch(),200);
    }
}