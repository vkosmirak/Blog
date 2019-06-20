# Salesforce

#### Get packege version

Setup - Installed packages - OCE CRM

#### How to see all changes by admin in the org:
Setup -> Search -> View Setup Audit Trail



## Workbench

Get all users
```
SELECT Email,Id,Name FROM User
```

Get all sync transactions by user
```
SELECT CreatedById,CreatedDate,Id,Name,OCE__AllItemsCount__c,OCE__AppVersion__c,OCE__DependentOfflineIds__c,OCE__LastRunDebug__c,OCE__LastRunLog__c,OCE__Status__c, 
(select id, OCE__EntityType__c, OCE__Data__c from OCE__SyncTransactionItems__r) 
FROM OCE__SyncTransaction__c WHERE
CreatedById = '0051U000004U7w6QAC'
```


### Examples of nestes select:
```
select OCE__Status__c
,(select id, OCE__Log__c from OCE__SyncTransactionLogs__r)
,(select id, OCE__EntityType__c, OCE__Data__c from OCE__SyncTransactionItems__r)
from
OCE__SyncTransaction__c
where OCE__Status__c = 'failed'
```
```
SELECT RelatedId FROM Group WHERE relatedId IN (SELECT id from Territory)
```


## iOS 

### Skip heavy tables (speed up sync)
DownloadManager.swift 83
```
if table.name.contains("OCE__DataChange__c") ||
    table.name.contains("OCE__OptDetail__c") ||
    table.name.contains("OCE__Opt__c") ||
    table.name.contains("OCE__DrugDistributionData__c") ||
    table.name.contains("OCE__XponentSalesData__c") ||
    table.name.contains("OCE__NextBestMessage__c") ||
    table.name.hasPrefix("OCE__Order") ||
    table.name.hasPrefix("OCE__MC") ||
    table.name.hasPrefix("OCE__Email") ||
    table.name.hasSuffix("__History") {
    OCELogDebug("Skipped \(table.name)")
    continue
}
```

### Skip Attachment ContentDocumentLink tables (speed-up sync)
TODO


### Skip visibility loading (speed up background sync)
Comment LoadDataOperation.swift 173  
Consiqence: records will not be deleted if deleted in Salesforce

### Xcode debug tricks
Xcode / Target / Edit scheme (Command+Alt+R - ⌘⌥R)  
Select one or more variables:
 - `SIMULATE_OFFLINE` - skip background sync and sending transactions  
 - `LOG_DASHBOARD_RESPONSE` - print dashboard/report json responce  
 - `LOG_SYNC_TRANSACTIONS` - print created and sended sync transactions   
 - `SKIP_PIN_SCREEN`, `SKIP_APP_UPDATE_ALERT`, `SKIP_NEW_METADATA_ALERT`  

### Show all LAC iOS-Javascript requests
LACEngine 160
```
debugPrint(#file, #function, requestName, params, json)
```
