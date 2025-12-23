public class ProductAPIService {
    
    @future(callout=true)
    public static void fetchAndSyncProducts() {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:ProductAPI/objects/6');  
            req.setMethod('DELETE');
            req.setTimeout(60000);
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                List<Object> objList = (List<Object>) JSON.deserializeUntyped(res.getBody());
                List<External_Product__c> updateList = new List<External_Product__c>();
                
                for (Object obj : objList) {
                    Map<String, Object> mapObj = (Map<String, Object>) obj;
                    Map<String, Object> data = (Map<String, Object>) mapObj.get('data');
                    
                    External_Product__c record = new External_Product__c();
                    record.External_Id__c = String.valueOf(mapObj.get('id'));
                    record.Name = String.valueOf(mapObj.get('name'));
                    
                    if (data != null) {
                        if (data.containsKey('price') && data.get('price') != null) {
                            record.Price__c = Decimal.valueOf(String.valueOf(data.get('price')));
                        }
                        if (data.containsKey('color')) record.Colour__c = String.valueOf(data.get('color'));
                        if (data.containsKey('capacity')) record.Capacity__c = String.valueOf(data.get('capacity'));
                    }
                    
                    updateList.add(record);
                }
                
                if (!updateList.isEmpty()) {
                    ProductDataHandler.upsertProducts(updateList);
                }
            } else {
                System.debug('HTTP Error: ' + res.getStatusCode() + ' - ' + res.getBody());
            }
            
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
}