global class Hosp_HospitalSchedule implements Schedulable{


    public static String timeSchedule = '0 18 * ? * *';



    global static String scheduleMe() {
        Hosp_HospitalSchedule hospitalSchedule = new Hosp_HospitalSchedule();
        return System.schedule('Insert hospital Job', timeSchedule, hospitalSchedule);
    }

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Hosp_HospitalBatch(),200);
    }
}