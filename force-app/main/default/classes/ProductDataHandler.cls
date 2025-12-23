public class ProductDataHandler {

    public static void upsertProducts(List<External_Product__c> products) {
        try {
            upsert products External_Id__c;
            System.debug('updated ' + products.size() + ' product records.');
        } catch (DmlException dmlEx) {
            System.debug('DML Exception: ' + dmlEx.getMessage());
        }
    }
}