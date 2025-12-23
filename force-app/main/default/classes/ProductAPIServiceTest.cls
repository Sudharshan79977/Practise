@IsTest
global class ProductAPIServiceTest {

    global class ProductAPIMockResponse implements HttpCalloutMock {
        String responseBody;
        
        public ProductAPIMockResponse(String body) {
            this.responseBody = body;
        }
        
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseBody);
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest
    static void testFetchAndSyncProducts() {
        String mockResponse = '[{"id":"1","name":"Test Product","data":{"price":499,"color":"Blue","capacity":"64GB"}},'+
                              '{"id":"2","name":"Another Product","data":{"price":999,"color":"Red","capacity":"128GB"}}]';

        Test.setMock(HttpCalloutMock.class, new ProductAPIMockResponse(mockResponse));

        // Execute the @future method
        Test.startTest();
        ProductAPIService.fetchAndSyncProducts();
        Test.stopTest();

        // Verify that records are created/updated
        List<External_Product__c> products = [SELECT External_Id__c, Name, Price__c, Colour__c, Capacity__c 
                                              FROM External_Product__c 
                                              WHERE External_Id__c IN ('1','2')];

        System.assertEquals(2, products.size(), 'Two products should be inserted');

        // Find first record manually
        External_Product__c p1;
        External_Product__c p2;
        for (External_Product__c p : products) {
            if (p.External_Id__c == '1') p1 = p;
            if (p.External_Id__c == '2') p2 = p;
        }

        // Verify first record
        System.assertNotEquals(null, p1);
        System.assertEquals('Test Product', p1.Name);
        System.assertEquals(499, p1.Price__c);
        System.assertEquals('Blue', p1.Colour__c);
        System.assertEquals('64GB', p1.Capacity__c);

        // Verify second record
        System.assertNotEquals(null, p2);
        System.assertEquals('Another Product', p2.Name);
        System.assertEquals(999, p2.Price__c);
        System.assertEquals('Red', p2.Colour__c);
        System.assertEquals('128GB', p2.Capacity__c);
    }

    @IsTest
    static void testProductDataHandlerUpsert() {
        // Prepare records
        List<External_Product__c> products = new List<External_Product__c>{
            new External_Product__c(External_Id__c='10', Name='Handler Test', Price__c=100),
            new External_Product__c(External_Id__c='11', Name='Handler Test2', Price__c=200)
        };

        Test.startTest();
        ProductDataHandler.upsertProducts(products);
        Test.stopTest();

        // Verify records inserted
        List<External_Product__c> insertedProducts = [SELECT External_Id__c, Name, Price__c 
                                                      FROM External_Product__c 
                                                      WHERE External_Id__c IN ('10','11')];

        System.assertEquals(2, insertedProducts.size());
        Map<String, External_Product__c> mapProducts = new Map<String, External_Product__c>();
        for (External_Product__c p : insertedProducts) {
            mapProducts.put(p.External_Id__c, p);
        }

        System.assertEquals('Handler Test', mapProducts.get('10').Name);
        System.assertEquals(100, mapProducts.get('10').Price__c);
        System.assertEquals('Handler Test2', mapProducts.get('11').Name);
        System.assertEquals(200, mapProducts.get('11').Price__c);
    }
}