# Salesforce

#### Get packege version

Setup - Installed packages - OCE CRM

#### How to see all changes by admin in the org:
Setup -> Search -> View Setup Audit Trail

#### Get metadata archive  
Send next info to @mpetriv or @vlitovka
```
Organization: 00D1r000001m3itEAA
Metadata: MD-000048
Profile: THX Rep
```

## Workbench

### Get all users
```
SELECT Email,Id,Name FROM User
```

### Get sync transaction details
```
SELECT CreatedDate, CreatedById, id, Name, OCE__DependentOfflineIds__c, OCE__Status__c , 
OCE__LastRunLog__c, isDeleted,
(SELECT id, OCE__Log__c from OCE__SyncTransactionLogs__r),
(SELECT id, OCE__EntityType__c, OCE__Data__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE id = 'a331r000003wbBtAAI'
```

### Get user's error logs
```
SELECT CreatedById,CreatedDate,Id,Name,OCE__Level__c,OCE__Message__c,OCE__Where__c, 
OCE__DeviceID__c,OCE__DeviceType__c,OCE__Origin__c, OCE__OSNameVersion__c, isDeleted
FROM OCE__Log__c 
WHERE 
CreatedById = '0051r0000095GtFAAU' AND 
CreatedDate > 2019-01-24T05:02:31.000Z
ORDER BY CreatedDate ASC NULLS FIRST
```

### Get user's sync statistic
```
SELECT CreatedById,CreatedDate,Id,Name,OCE__AppVersion__c,OCE__DeviceId__c,OCE__iosVersion__c,
OCE__MetadataVersion__c, OCE__NetworkType__c,OCE__SyncTrigger__c, OCE__DownloadComplete__c,
OCE__DownloadStart__c, OCE__DownloadEnd__c, OCE__DownloadRecords__c, OCE__DownloadUpdatedRecords__c,
OCE__UploadComplete__c, OCE__UploadStart__c, OCE__UploadEnd__c, OCE__UploadDuration__c, 
OCE__UploadRecords__c, IsDeleted
FROM OCE__SyncStatistics__c 
WHERE 
CreatedById = '0051r000009KobHAAS' AND 
CreatedDate > 2019-05-08T05:00:09.000Z 
ORDER BY CreatedDate ASC NULLS FIRST
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

### Skip Attachment & ContentDocumentLink tables (speed-up sync)
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
LACEngine.swift 160
```
debugPrint(#file, #function, requestName, params, json)
```
