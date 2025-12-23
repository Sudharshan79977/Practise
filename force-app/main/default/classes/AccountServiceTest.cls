@IsTest
private class AccountServiceTest {

    private static void setupRestContext(String method, String uri, Map<String, Object> body) {
        RestRequest req = new RestRequest();
        req.httpMethod = method;
        req.requestUri = uri;
        if (body != null) {
            req.requestBody = Blob.valueOf(JSON.serialize(body));
        }
        RestContext.request = req;
        RestContext.response = new RestResponse();
    }


    @IsTest
    static void testCreateAccount_Success() {
        setupRestContext(
            'POST',
            '/services/apexrest/AccountService/',
            new Map<String, Object>{
                'name' => 'TechCorp Pvt Ltd',
                'phone' => '9876543210',
                'industry' => 'Technology'
            }
        );

        AccountService.createAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('success', res.get('status'));
        System.assertNotEquals(null, res.get('accountId'));
    }

    @IsTest
    static void testCreateAccount_Duplicate() {
        Account acc = new Account(Name='ExistingCorp', Phone='1111111111', Industry='Finance');
        insert acc;

        setupRestContext(
            'POST',
            '/services/apexrest/AccountService/',
            new Map<String, Object>{
                'name' => 'ExistingCorp',
                'phone' => '1111111111',
                'industry' => 'Finance'
            }
        );

        AccountService.createAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('duplicate', res.get('status'));
        System.assertEquals(acc.Id, res.get('accountId'));
    }

    @IsTest
    static void testCreateAccount_MissingName() {
        setupRestContext(
            'POST',
            '/services/apexrest/AccountService/',
            new Map<String, Object>{
                'phone' => '1234567890'
            }
        );

        AccountService.createAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('error', res.get('status'));
    }


    @IsTest
    static void testGetAccount_Success() {
        Account acc = new Account(Name='GetCorp', Phone='2223334444', Industry='Retail');
        insert acc;

        setupRestContext('GET', '/services/apexrest/AccountService/' + acc.Id, null);
        AccountService.getAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('success', res.get('status'));
        System.assertEquals(acc.Name, res.get('Name'));
    }

    @IsTest
    static void testGetAccount_NotFound() {
        setupRestContext('GET', '/services/apexrest/AccountService/001XXXXXXX', null);
        AccountService.getAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('error', res.get('status'));
    }


    @IsTest
    static void testUpdateAccount_Success() {
        Account acc = new Account(Name='UpdateCorp', Phone='7778889999', Industry='Healthcare');
        insert acc;

        setupRestContext(
            'PUT',
            '/services/apexrest/AccountService/' + acc.Id,
            new Map<String, Object>{ 'phone' => '0001112222', 'industry' => 'Tech' }
        );

        AccountService.updateAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('success', res.get('status'));

        Account updatedAcc = [SELECT Phone, Industry FROM Account WHERE Id = :acc.Id];
        System.assertEquals('0001112222', updatedAcc.Phone);
        System.assertEquals('Tech', updatedAcc.Industry);
    }


    @IsTest
    static void testDeleteAccount_Success() {
        Account acc = new Account(Name='DeleteCorp', Phone='5556667777');
        insert acc;

        setupRestContext('DELETE', '/services/apexrest/AccountService/' + acc.Id, null);
        AccountService.deleteAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('success', res.get('status'));

        System.assertEquals(0, [SELECT count() FROM Account WHERE Id = :acc.Id]);
    }

    @IsTest
    static void testDeleteAccount_NotFound() {
        setupRestContext('DELETE', '/services/apexrest/AccountService/001XXXXXXX', null);
        AccountService.deleteAccount();

        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('error', res.get('status'));
    }
    
}