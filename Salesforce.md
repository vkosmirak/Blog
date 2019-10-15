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

#### Field permission to profile
Setup -> Profile -> Sales Representative -> Find 'Field-level permission' -> Call -> Edit

#### Field permission in DB Schema
Setup -> Custom Metadata Types -> DB Schema -> Manage Records -> Call -> Find field
> How to add field:  
> Call -> Edit -> Deselect 'Active' -> Save -> Clone -> Add field at the end -> Select 'Active' -> Save

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
(SELECT id, OCE__EntityType__c, OCE__Operation__c, OCE__Data__c, OCE__ProcessedRecordId__c, OCE__Order__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE id = 'a331r000003wbBtAAI'
```
<details><summary>more</summary>
<p>
    
### Get user's sync stransactions

```
SELECT CreatedById, CreatedDate, Id, Name, OCE__DependentOfflineIds__c, OCE__Status__c , OCE__LastRunLog__c, OCE__LastRunLog__r.OCE__Log__c, isDeleted,
(SELECT id, OCE__EntityType__c, OCE__Operation__c, OCE__Data__c, OCE__ProcessedRecordId__c, OCE__Order__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE 
CreatedById = '0051r000009Kob0AAC' AND
CreatedDate > 2019-05-16T06:45:00.000Z
ORDER BY CreatedDate ASC NULLS FIRST
```


### Get all sync stransactions modified the object
```
SELECT CreatedById, CreatedDate, Id, Name, OCE__DependentOfflineIds__c, OCE__Status__c, 
OCE__LastRunLog__c, isDeleted,
(SELECT id, OCE__Log__c from OCE__SyncTransactionLogs__r),
(SELECT id, OCE__EntityType__c, OCE__Operation__c, OCE__Data__c, OCE__ProcessedRecordId__c, OCE__Order__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE  Id IN (
   SELECT OCE__SyncTransaction__c 
   FROM OCE__SyncTransactionItem__c
   WHERE OCE__ProcessedRecordId__c = 'a1B6E000000fpDNUAY'
)
ORDER BY CreatedDate
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

### Skip Sync errors
DownloadManager.swift 510
```
throw  result.error ?? SyncError.Unknown(message: " Cannot get SOQL response ")
->
OCELogError("\(result.error)")
return
```
Consiqence: instead of failing sync, it will be finished without table saved

Example of error:
```
{
   errorCode = "INVALID_FIELD";
   message = "\nCreatedById,OCE__ActualCap__c,TPI_Product__c,Name,OCE__JobId__c\n                              ^\n
   ERROR at Row:1:Column:114\nNo such column 'TPI_Product__c' on entity 'OCE__ActivityPlan__c'. If you are attempting to use a custom field, be sure to append the '__c' after the custom field name. Please reference your WSDL or the describe call for the appropriate names.";
}
```


### Skip Attachment & ContentDocumentLink tables (speed-up sync)
TODO

### OCE frash project instalation

1. Install only once (OCE-25412)
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" argv --force-curl
brew install node yarn watchman
npm install -g react-native-cli
```
2. `cd crm/ios`
3. `sh OCE.xctemplate/install-react-tools.sh`
4. `pod install`
> If build fails:   
> 1) copy content of `jetfire` in pod  
> 2) `OS/log.h -> os/log.h`  
> 3) Check if cocoapods version `pod --version` same as in `Pod.lock`
> 4) Remove node_modules/pods folder and reinstall


### Skip visibility loading (speed up background sync)
Comment LoadDataOperation.swift 173  
Consiqence: records will not be deleted if deleted in Salesforce

### Force English localization
Add next line in `UserSevice.swift` 28 48, `SharedUserSettings.swift` 58 68
```
return UserService.defaultLanguage
```

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

### Show all AST requests
ValidationService.swift 61
```
debugPrint(rule.fullName)
```
ASTNode.swift.swift 43
```
let result: Any?
if let operation = operation as? ASTValue, fieldPrefix.isEmpty == false {
    result = operation.result(params: params, dataSource: dataSource, fieldPrefix: fieldPrefix, treatNull: treatNull)
} else {
    result = operation?.result(params: params, dataSource: dataSource, treatNull: treatNull)
}
debugPrint(operation ?? "", params.map { $0.value ?? ""}, "=", result ?? "")
return result
```
ASTOperations.swift 1085
```
public class ASTNodeResult
```

### Run on device
1. Change bundle id to `com.vkosmirak.oce.dev`
2. Enable automatic signing, select personal team
3. Build settings / Remove `PROVISIONING_PROFILE` key
4. `OCE Dev.entitlements` - remove `siri` key
5. Insert `SiriService / isSiriShortcutsEnabled()` - `return false`
6. `OCE / Targets / SyncKit` - enable Automatic signing
7. Run  

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
