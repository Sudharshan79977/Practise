@RestResource(urlMapping='/AccountService/*')
global with sharing class AccountService {
    
    private static void sendResponse(Integer code, Map<String, Object> body) {
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = code;
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(body));
    }
    
    @HttpPost
    global static void createAccount() {
        try {
            RestRequest req = RestContext.request;
            Map<String, Object> reqBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            String name = (String) reqBody.get('name');
            String phone = (String) reqBody.get('phone');
            String industry = (String) reqBody.get('industry');
            
            if (String.isBlank(name)) {
                sendResponse(400, new Map<String, Object>{ 'status' => 'error', 'message' => 'Account Name is required' });
                return;
            }
            
            List<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :name AND Phone = :phone LIMIT 1];
            if (!existingAccounts.isEmpty()) {
                sendResponse(200, new Map<String, Object>{ 'status' => 'duplicate', 'message' => 'Account already exists', 'accountId' => existingAccounts[0].Id });
                return;
            }
            
            Account acc = new Account(Name = name, Phone = phone, Industry = industry);
            insert acc;
            
            sendResponse(201, new Map<String, Object>{ 'status' => 'success', 'message' => 'Account created successfully', 'accountId' => acc.Id });
        } catch (Exception e) {
            sendResponse(400, new Map<String, Object>{ 'status' => 'error', 'message' => e.getMessage() });
        }
    }
    
    @HttpGet
    global static void getAccount() {
        try {
            String accId = RestContext.request.requestURI.substringAfterLast('/');
            Account acc = [SELECT Id, Name, Phone, Industry FROM Account WHERE Id = :accId LIMIT 1];
            
            Map<String, Object> responseMap = new Map<String, Object>{
                'status' => 'success',
                    'Id' => acc.Id,
                    'Name' => acc.Name,
                    'Phone' => acc.Phone,
                    'Industry' => acc.Industry
                    };
                        
                        sendResponse(200, responseMap);
            
        } catch (Exception e) {
            sendResponse(404, new Map<String, Object>{
                'status' => 'error',
                    'message' => 'Account not found'
                    });
        }
    }
    
    @HttpPut
    global static void updateAccount() {
        try {
            RestRequest req = RestContext.request;
            String accId = req.requestURI.substringAfterLast('/');
            Map<String, Object> reqBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            Account acc = [SELECT Id, Name, Phone, Industry FROM Account WHERE Id = :accId LIMIT 1];
            
            if (reqBody.containsKey('name')) acc.Name = (String) reqBody.get('name');
            if (reqBody.containsKey('phone')) acc.Phone = (String) reqBody.get('phone');
            if (reqBody.containsKey('industry')) acc.Industry = (String) reqBody.get('industry');
            
            update acc;
            sendResponse(200, new Map<String, Object>{ 'status' => 'success', 'message' => 'Account updated successfully' });
        } catch (Exception e) {
            sendResponse(400, new Map<String, Object>{ 'status' => 'error', 'message' => e.getMessage() });
        }
    }
    
    @HttpDelete
    global static void deleteAccount() {
        try {
            String accId = RestContext.request.requestURI.substringAfterLast('/');
            Account acc = [SELECT Id FROM Account WHERE Id = :accId LIMIT 1];
            delete acc;
            sendResponse(200, new Map<String, Object>{ 'status' => 'success', 'message' => 'Account deleted successfully' });
        } catch (Exception e) {
            sendResponse(404, new Map<String, Object>{ 'status' => 'error', 'message' => 'Account not found' });
        }
    }
}