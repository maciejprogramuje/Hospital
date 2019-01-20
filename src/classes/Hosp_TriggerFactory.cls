/**
 * Created by BRITENET on 19.01.2019.
 */

public with sharing class Hosp_TriggerFactory {
    public static void createHandler(Schema.sObjectType soType) {
        ITrigger handler = getHandler(soType);
        execute(handler);
    }

    private static void execute(ITrigger handler) {
        if (Trigger.isBefore) {
            if (Trigger.isDelete) {
                handler.beforeDelete(Trigger.old);
            } else if (Trigger.isInsert) {
                handler.beforeInsert(Trigger.new);
            } else if (Trigger.isUpdate) {
                handler.beforeUpdate(Trigger.new);
            }
        } else {
            if (Trigger.isDelete) {
                handler.afterDelete(Trigger.old);
            } else if (Trigger.isInsert) {
                handler.afterInsert(Trigger.new);
            } else if (Trigger.isUpdate) {
                handler.afterUpdate(Trigger.new);
            }
        }
    }

    private static ITrigger getHandler(Schema.sObjectType soType) {
        if (soType == Hospital__c.sObjectType) {
            return new Hosp_HospitalTriggerHandler();
        }
        return null;
    }
}