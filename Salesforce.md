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

#### Get Submitted DB
Send next info to @mpetriv or @vlitovka
```
Organization: 00D1r000001m3itEAA
Accunt name: CELINE GUILLAUME
Submission date: ~ 6/20/2019 
```
> Expected format `db/CELINE GUILLAUME-C8065E8A-3446-450A-9928-603D871B13F3-1561043793.2755141.zip`

#### Add trusted IP address
Setup -> Network access -> New -> Add [your IP address](https://www.myip.com)  
> It needs when you cannot login and see 'Verify you identity (email)' sceen

## Workbench

### Get all users
```
SELECT Email,Id,Name FROM User
```

### Get sync transaction details
```
SELECT CreatedById, CreatedDate, Id, Name, OCE__DependentOfflineIds__c, OCE__Status__c , 
OCE__LastRunLog__c, isDeleted,
(SELECT id, OCE__Log__c from OCE__SyncTransactionLogs__r),
(SELECT id, OCE__EntityType__c, OCE__Data__c, OCE__ProcessedRecordId__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE id = 'a331r000003wbBtAAI'
```
<details><summary>more</summary>
<p>
    
### Get user's sync stransactions

```
SELECT CreatedById, CreatedDate, Id, Name, OCE__DependentOfflineIds__c, OCE__Status__c , OCE__LastRunLog__c, OCE__LastRunLog__r.OCE__Log__c, isDeleted,
(SELECT id, OCE__EntityType__c, OCE__Data__c, OCE__ProcessedRecordId__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE 
CreatedById = '0051r000009Kob0AAC' AND
CreatedDate > 2019-05-16T06:45:00.000Z
ORDER BY CreatedDate ASC NULLS FIRST
```
---
</p>
</details>

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

### Hardcode English localization
TODO


### Xcode debug tricks
Xcode / Target / Edit scheme (Command+Alt+R - ⌘⌥R)  
Select one or more variables:
 - `SIMULATE_OFFLINE` - skip background sync and sending transactions  
 - `LOG_DASHBOARD_RESPONSE` - print dashboard/report json responce  
 - `LOG_SYNC_TRANSACTIONS` - print created and sended sync transactions   
 - `SKIP_PIN_SCREEN`, `SKIP_APP_UPDATE_ALERT`, `SKIP_NEW_METADATA_ALERT`  

### Show all LAC iOS-Javascript requests
LACEngine.swift 97
```
debugPrint(#file, #function, requestName, params, json)
```

### Run on device
1. Change bundle id to `com.vkosmirak.oce.dev`
2. Enable automatic signing, select personal team
3. `OCE Dev.entitlements` - remove `siri` key
4. Insert `SiriService / isSiriShortcutsEnabled()` - `return false`
5. `OCE / Targets / SyncKit` - enable Automatic signing
6. Run  

> Possible issues:
> 1. Device not trusted. Solution - `iPad / Settings / General / Profiles & Device Management / Trust`
> 2. Xcode Missing Support Files - [solution](https://stackoverflow.com/questions/55575782/xcode-missing-support-files-ios-12-2-16e227) 

### Use Submitted DB
1. Sign in as admin in iPad
2. Enable `SIMULATE_OFFLINE`
3. Add next code somewhere
```
extension String {
    init?(optional: String) {
        self.init(optional)
    }
}
```
4. Hardcode all user id, profile id and org id    
```
SFUserAccountManager.sharedInstance().currentUser?.idData?.userId -> String(optional: "0051r000009ZCAjAAO")
SFUserAccountManager.sharedInstance().currentUser?.idData?.orgId -> String(optional: "00D1r000000pnJMEAY")
```
5. Insert in `User.swift 76` (end of init)
```
// Replace territory id with selected from submitted database
if let selectedTerritory = self.territories.first {
    self.selectedTerritory = Territory(territory: selectedTerritory)
    if let selectedTerritoryID = self.selectedTerritoryID {
        self.selectedTerritory?.id = selectedTerritoryID
    }
}       
```
6. Set breakpoint in `application(didFinishLaunchingWithOptions)`
7. Run
8. Stop on breakpoint
9. Open simulator folder. Replace `.Data` with `Submitted DB` Folder
10. Turn off breakpoint and go
