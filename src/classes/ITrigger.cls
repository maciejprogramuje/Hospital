public interface ITrigger {
    void beforeInsert(List<SObject> so);

    void beforeUpdate(List<SObject> oldSo);

    void beforeDelete(List<SObject> hospitalMap);

    void afterInsert(List<SObject> so);

    void afterUpdate(List<SObject> oldSo);

    void afterDelete(List<SObject> so);
}