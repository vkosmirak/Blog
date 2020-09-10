- [Salesforce](#salesforce)
- [Workbench](#workbench)
- [iOS](#ios)

# Salesforce

#### Get packege version

Setup - Installed packages - OCE CRM

#### How to see all changes by admin in the org:
Setup -> Search -> View Setup Audit Trail
    
#### How to get old metadata and Submitted DB from AWS S3

1. Workbench / Utilities / REST Explorer `/services/apexrest/OCE/SecuredConfig`
2. Copy next keys  `OCE__S3Bucket__c`, `OCE__S3ReadOnlyAccessKey__c`, `OCE__S3ReadOnlySecretKey__c`
3. Use them in any AWS S3 browser (e.g. Cyberduck)
4. Find folder with org id (`select id from organisation`)
> Sometimes `Cyberduck` cannot download files, for example from China regions. In this case you need to use AWS CLI in terminal

<details><summary>Use AWS CLI</summary>
<p>
    
1. Workbench / Utilities / REST Explorer `/services/apexrest/OCE/SecuredConfig`
    
```
{
  "attributes" : {
    "type" : "OCE__OCESecuredConfig__c"
  },
  "OCE__S3ReadOnlyAccessKey__c" : "ACCESS_KEY_1111111111111”,
  "OCE__S3ReadOnlySecretKey__c" : "SECRET_KEY_222222222222222222222222222222222”,
  "OCE__S3Bucket__c" : "BUCKET”,
  "OCE__S3BucketRegion__c" : "BUCKET_REGION”,
   …
}
```
2. Install AWS CLI ([documentation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
3. Do in terminal
```
aws configure
   AWS Access Key ID:  ACCESS_KEY_1111111111111
   AWS Secret Access Key:  SECRET_KEY_222222222222222222222222222222222
   Default region name: BUCKET_REGION
   Default output format: text
```
4. List folders:
```
aws s3 ls s3://BUCKET/
aws s3 ls s3://BUCKET/00D2v0000014FnO/
aws s3 ls s3://BUCKET/00D2v0000014FnO/MD-000082/
aws s3 ls s3://BUCKET/00D2v0000014FnO/MD-000082/'NNAAMEO Core Sales Rep.zip' 
```
> Note: 
>   1. `/` is required in the end
>   2. Get ORG id - `select id from organization`
>   3. Remove latest 3 characters: 00D6g000000FjXQ**EA0** -> 00D6g000000FjXQ


5. Download file:
```
aws s3api get-object --bucket BUCKET --key 00D2v0000014FnO/MD-000082/'NNAAMEO Core Sales Rep.zip'  Desktop/'NNAAMEO Core Sales Rep.zip'
or
aws s3api get-object --bucket BUCKET --key 00D2v0000014FnO/MD-000082/'NNAAMEO Core Sales Rep.zip'  /Users/vkosmirak/Desktop/test.zip
```
Last parameter: file path to save

---
</p>
</details>

#### Add trusted IP address
Setup -> Network access -> New -> Add [your IP address](https://www.myip.com)  
> It needs when you cannot login and see 'Verify you identity (email)' sceen

#### Field permission to profile
Setup -> Profile -> Sales Representative -> Find 'Field-level permission' -> Call -> Edit

#### Field permission in DB Schema
Setup -> Custom Metadata Types -> DB Schema -> Manage Records -> Call -> Find field
> How to add field:  
> Call -> Edit -> Deselect 'Active' -> Save -> Clone -> Add field at the end -> Select 'Active' -> Save

#### How to upload CLM presentation:
1. Admin console / CLM / Presentations / Bulk Presentation Upload
2. Add .zip presentation (If has, add all assets e.g. PDF) 
3. Upload / Next / Next / Add Presentation name / Finish
4. Open presentation / Edit / Allow unaligned selection / Select territory / Save / Activate


# Workbench

### Get all users
```
SELECT Id, Name, Username, Email FROM User
```

### Get sync transaction details
```
SELECT CreatedById, CreatedDate, Id, Name, OCE__OfflineUniqueId__c, OCE__DependentOfflineIds__c, 
OCE__Status__c , OCE__LastRunLog__c, isDeleted,
(SELECT id, OCE__Log__c, OCE__ErrorLocation__c from OCE__SyncTransactionLogs__r),
(SELECT id, Name, OCE__EntityType__c, OCE__Operation__c, OCE__Data__c, 
OCE__ProcessedRecordId__c, OCE__EntityId__c, OCE__Order__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE id = 'a331r000003wbBtAAI'
```
<details><summary>more</summary>
<p>
    
### Get user's all sync transactions

```
SELECT CreatedById, CreatedDate, Id, Name, OCE__OfflineUniqueId__c, OCE__DependentOfflineIds__c, 
OCE__Status__c , OCE__LastRunLog__c, OCE__LastRunLog__r.OCE__Log__c, isDeleted,
(SELECT id, Name, OCE__EntityType__c, OCE__Operation__c, OCE__Data__c, 
OCE__ProcessedRecordId__c, OCE__EntityId__c, OCE__Order__c from OCE__SyncTransactionItems__r)
FROM OCE__SyncTransaction__c
WHERE 
CreatedById = '0051r000009Kob0AAC' 
ORDER BY CreatedDate DESC
LIMIT 1000
```


### Get all sync stransactions modified the object
```
SELECT CreatedById, CreatedDate, Id, Name, OCE__OfflineUniqueId__c, OCE__DependentOfflineIds__c, 
OCE__Status__c, OCE__LastRunLog__c, isDeleted,
(SELECT id, OCE__Log__c, OCE__ErrorLocation__c from OCE__SyncTransactionLogs__r),
(SELECT id, Name, OCE__EntityType__c, OCE__Operation__c, OCE__Data__c, 
OCE__ProcessedRecordId__c, OCE__EntityId__c, OCE__Order__c from OCE__SyncTransactionItems__r)
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
CreatedById = '0051r0000095GtFAAU'
AND OCE__Where__c != 'TranslationServiceProtocol localizedString(key:defaultValue:) 53' 
ORDER BY CreatedDate DESC 
LIMIT 1000
```

### Get user's sync statistic
```
SELECT CreatedById,CreatedDate,Id,Name,OCE__AppVersion__c,OCE__DeviceId__c,OCE__iosVersion__c,
OCE__MetadataVersion__c, OCE__NetworkType__c,OCE__SyncTrigger__c, OCE__SyncStatisticsData__c, 
OCE__DownloadComplete__c, OCE__DownloadStart__c, OCE__DownloadEnd__c, OCE__DownloadRecords__c, 
OCE__DownloadUpdatedRecords__c, OCE__UploadComplete__c, OCE__UploadStart__c, OCE__UploadEnd__c, 
OCE__UploadDuration__c, OCE__UploadRecords__c, IsDeleted
FROM OCE__SyncStatistics__c 
WHERE 
CreatedById = '0051r000009KobHAAS' 
ORDER BY CreatedDate DESC 
LIMIT 1000
```
> Remove `OCE__SyncStatisticsData__c` if query is failing (for older orgs)

### Get user record access
```
SELECT 
RecordId, MaxAccessLevel, HasAllAccess, HasDeleteAccess,
HasEditAccess, HasReadAccess, HasTransferAccess 
FROM UserRecordAccess 
WHERE 
UserId = '0051t000003L8mdAAC' AND 
RecordId = '0012o00002eO93gAAC'
```

### Get large number of records as .CSV file 
1. Run Query / Select Bulk CSV / Download
1. It's recommended to use where and limit (e.g. `LIMIT 10000`)
1. Now you can Command+F through big `.CSV` text file in Sublime
1. To add it to SQLite DB:
   1) Open existing OCE.db in TablePlus / File / Import / from CSV / Select downloaded file
   2) Select 'Create new table' / Import / Reload data (Command R)

### Notes
1. `LIMIT` is needed sometimes, when queries are failing in workbanch due to large number of records
1. `AND CreatedDate < 2019-01-24T05:02:31.000Z` - append in `WHERE` to narrow search
1. For search by not searchable fields, use Bulk CSV    
(e.g. `OCE__Log__c.OCE__Message__c` or `OCE__SyncTransactionLog__c.OCE__Data__c`)
1. To search for similar errror logs or sync transaction failes, use Bulk CSV    

# iOS 

### Load specific Metadata version
SelectTerritoryBaseOperation.swift  
Replace if with:  
`addNextOperationToQueue(syncStep: SyncStep.determineIfNewMetadataAvaliable)`

DetermineIfNewMetadataAvailableOperation.swift
```
var request = "SELECT "
request += "Id, Name," + "Status__c".ns() + "," + "Version__c".ns() + "," + "BaseURL__c".ns() + "," + "MandatoryUpdateDate__c".ns()
request += " FROM "
request += "Metadata__c".ns()
request += " WHERE "
request += " name = 'MD-000123' "
```

> Please note, if metadata is too old, sync error may occure, so you need to also Skip Sync error

### Skip Sync errors
1. Skip salesforce loading errors:  
`DownloadManager.swift` `getAllNextRequests(for`
```
throw  result.error ?? SyncError.Unknown(message: " Cannot get SOQL response ")
->
OCELogError("\(result.error)")
return
```
Consiqence: instead of failing sync, it will be finished without failed table saved

Example of error:
```
{
   errorCode = "INVALID_FIELD";
   message = "\nCreatedById,OCE__ActualCap__c,TPI_Product__c,Name,OCE__JobId__c\n                              ^\n
   ERROR at Row:1:Column:114\nNo such column 'TPI_Product__c' on entity 'OCE__ActivityPlan__c'. If you are attempting to use a custom field, be sure to append the '__c' after the custom field name. Please reference your WSDL or the describe call for the appropriate names.";
}
```
2. Skip network/time out errors:    
`DownloadManager.swift` `scheduleDownload(for`  
Comment catch block
```
            } catch {
                  OCELogError("\(error)")
//                self.syncError = error
//                self._networkRequestQueue.cancelAllOperations()
//                self._processRecordsOperationQueue.cancelAllOperations()
            }
 ```

### Skip heavy tables (speed up sync)
DownloadManager.swift 83
```
if table.name.contains("DataChange__c") ||
    table.name.contains("OptDetail__c") ||
    table.name.contains("Opt__c") ||
    table.name.contains("DrugDistributionData__c") ||
    table.name.contains("XponentSalesData__c") ||
    table.name.contains("Notification__c") ||
    table.name.contains("NotificationContext__c") ||
    table.name.contains("NextBestMessage__c") ||
    table.name.contains("Order") ||
    table.name.contains("Email") ||
    table.name.hasSuffix("__History") {
    OCELogDebug("Skipped \(table.name)")
    continue
}
```

### OCE fresh project instalation

1. Install only once (OCE-25412)
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" argv --force-curl
brew install node yarn watchman
npm install -g react-native-cli
```
2. `cd crm/ios`
3. `sh OCE.xctemplate/install-react-tools.sh`
4. `pod install`
5. For 6.1 version you also need in `react/package.json` 
   1) remove line with `apollorndesignsystem`
   2) insert line `"react-native-linear-gradient": "2.5.6",`
> If build fails:   
> 1) copy content of `jetfire` in pod  
> 2) `OS/log.h -> os/log.h`  
> 3) Check if cocoapods version `pod --version` same as in `Pod.lock`
> 4) Remove node_modules/pods folder and reinstall


### Skip visibility loading (speed up background sync)
Comment LoadDataOperation.swift 173  
Consiqence: records will not be deleted if deleted in Salesforce

### Force English localization
Add next line in `UserService.swift` 28 48, `SharedUserSettings.swift` 58 68
```
return UserService.defaultLanguage
```

### Force Metadata reload from source
Hardcode to `true`  
`ApplicationCoordinator`.`metadataFailedToLoad`

### Xcode debug tricks
Xcode / Target / Edit scheme (Command+Alt+R - ⌘⌥R)  
Select one or more variables:
 - `SIMULATE_OFFLINE` - skip background sync and sending transactions  
 - `LOG_DASHBOARD_RESPONSE` - print dashboard/report json responce  
 - `LOG_SYNC_TRANSACTIONS` - print created and sended sync transactions   
 - `SKIP_PIN_SCREEN`, `SKIP_APP_UPDATE_ALERT`, `SKIP_NEW_METADATA_ALERT`  

### Show all LAC iOS-Javascript requests
LACEngine.swift 162
```
debugPrint(#file, #function, requestName, params, json)
```

### Show all Salesforce API Apex requests/responses
SalesforceApi.swift 225
```
//Before if let params = queryParams {
debugPrint("\(method) \(method.rawValue) \(path)")

//Inside if let params = queryParams {
debugPrint(NSString(data: try! JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted]), encoding: String.Encoding.utf8.rawValue)!) //swiftlint:disable:this force_unwrapping

// Inside if let err = err {
debugPrint(err)

//Indide onSuccess: { data, _ in
debugPrint(data ?? Data())
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

### Debug FTS (SQL full text search)
1. Use next query example
   <details><summary>Code</summary>
    <p>
    
    ```
        SELECT
        account.name,
    --     account.firstname,
    --     account.lastname,
    --     account.oce__accountfullname__c,
    --     account.az_id__c,
        account.az_parent1__c,
        account.oce__specialty__c,
        
        oce__accountterritoryfields__c.az_target__c,
    --     oce__accountterritoryfields__c.az_sales_direction__c,
        
    --     oce__address__c.id,
        oce__address__c.name,
        oce__address__c.oce__city__c,
        oce__address__c.oce__statecode__c,
        oce__address__c.oce__zipcode__c,
        oce__address__c.oce__brick__c
    FROM
        Account
        LEFT JOIN recordtype ON recordtype.uid == Account.recordtypeid
        LEFT JOIN oce__accountterritoryfields__c ON oce__accountterritoryfields__c.oce__account__c = Account.uid
        LEFT JOIN OCE__accountaddress__c ON OCE__accountaddress__c.OCE__account__c = Account.uid
        LEFT JOIN OCE__address__c ON OCE__address__c.id = OCE__accountaddress__c.oce__address__c
    WHERE
        recordtype.ispersontype == 1
        AND(([account].rowid IN(
                SELECT
                    docid FROM fts_account
                WHERE
                    fts_account MATCH 'no*')
                OR account.rowid IN(
                    SELECT
                        account.rowid FROM [account]
                    WHERE
                        [account].uid in(
                            SELECT
                                OCE__accountaddress__c.OCE__account__c FROM OCE__accountaddress__c
                            WHERE
                                oce__address__c IN(
                                    SELECT
                                        oce__address__c.uid FROM [oce__address__c]
                                    WHERE
                                        oce__address__c.rowid IN(
                                            SELECT
                                                docid FROM fts_oce__address__c
                                            WHERE
                                                fts_oce__address__c MATCH 'no*'))))
                                OR [account].uid IN(
                                    SELECT
                                        OCE__Account__c FROM [oce__accountterritoryfields__c]
                                    WHERE
                                        oce__accountterritoryfields__c.rowid IN(
                                            SELECT
                                                docid FROM fts_oce__accountterritoryfields__c
                                            WHERE
                                                fts_oce__accountterritoryfields__c MATCH 'no*'))))
    GROUP BY
        Account.uid
    ORDER BY
        Account.OCE__AccountFullName__c IS NULL, Account.OCE__AccountFullName__c ASC, Account.Name IS NULL, Account.Name ASC
    LIMIT 10
    ```

    </p>
    </details>
    
2. Add correct fields to `SELECT` from `fts` tables
3. Note - state code is an abreviatura. e.g. `MN -> Minnesota`. Find it in `sobjects.json`
4. Note - user may have few addresses. I received another when only take `fts_oce__address__c` in `where`. Not sure why, as both were not primary
5. Why it may be needed? See OCE-46257

### Instal older version of Cocoapods
```
sudo gem uninstall cocoapods
sudo gem install cocoapods -v 1.7.5
pod --version
```

### Run on device
1. Change bundle id to `com.vkosmirak.oce.dev`
2. Enable automatic signing, select personal team
3. Build settings / Remove `PROVISIONING_PROFILE` key
4. Xcode 10: `OCE Dev.entitlements` - remove `siri` key  
   Xcode 11.1: `OCE / OCE Dev / Signing & Capabilities` - remove `siri` 
5. Insert `SiriService / isSiriShortcutsEnabled()` - `return false`
6. `OCE / Targets / SyncKit` - enable Automatic signing
7. Run  

> Possible issues:
> 1. Device not trusted. Solution - `iPad / Settings / General / Profiles & Device Management / Trust`
> 2. Xcode Missing Support Files - [solution](https://stackoverflow.com/questions/55575782/xcode-missing-support-files-ios-12-2-16e227) 
> 3. Signing problem in Xcode 11.2 - use Xcode 11.1


### Performance tip (how to parallelly use few simulators)

1. Working on task A in simulator A
2. -- Need to log in in another Org in simulator B --
3. Xcode / target / select another simulator
4. Run without build (`Command + Control + R`) - it is fast
5. Xcode / Debug / Detach from OCE Dev
6. Return to your Simulator 1,  Run without build 
7. Now you have two simulators, one active for current task A, another background for task B
8. You spent less then a minute for this
9. To quickly switch, just change simulator and use `Command + Control + R`

### Run backward compatibility on device
1. Run on device v5 code
2. Run on device v6 code 
3. Signing with the same creds (you were signed out)
4. Create passcode and close the app to not proceed init sync
5. Run again

### Install Submitted DB
1. Sign in as admin in iPad
2. Enable `SIMULATE_OFFLINE`
3. Add next code in OCE and Core targets
```
extension String {
    init?(optional: String) {
        self.init(optional)
    }
}
```
4. Hardcode all user id, profile id and org id    
```
UserAccountManager.shared.currentUserAccount?.idData?.userId -> String(optional: "0051r000009ZCAjAAO")
UserAccountManager.shared.currentUserAccount?.idData?.orgId -> String(optional: "00D1r000000pnJMEAY")
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
6. If needs to show all calls in planner, remove terriroty check in next files: `CalendarEventsMirrorQueryComposer`, `CalendarEventsDefaultQueryComposer`, `CalendarEventsCombinedQueryComposer`
6. Set breakpoint in `application(didFinishLaunchingWithOptions)`
7. Run
8. Stop on breakpoint
9. Open simulator folder. Replace `.Data` with `Submitted DB` Folder
10. Turn off breakpoint and go

### Install Submitted DB in device

1. Do 'Install Submitted DB' and 'Run on device'
2. Drag & drop folder in project / Selecte 'Create folder references'
3. Insert next code in `AppDelegate` `application(didFinishLaunchingWithOptions)`
    <details><summary>Code</summary>
    <p>

    `replaceSubmittedDB(folderName: "HILDE VERHEYDEN-D10E0A2D-2D33-4E5B-982F-CB4D2DE1EDAD")`

    ```
    func replaceSubmittedDB(folderName: String) {
        
        guard let folderUrl = Bundle.core.resourceURL?.appendingPathComponent(folderName) else { return }
        
        let fileManager = FileManager.default
        
        guard fileManager.fileExists(atPath: folderUrl.path) else {
            debugPrint(#function, "Error: Folder does not exist in bundle", folderName)
            return
        }
        
        let storageURL = Utility.getProtectedDirectory()
        
        if fileManager.fileExists(atPath: storageURL.path) {
            do {
                try fileManager.removeItem(at: storageURL)
            } catch {
                debugPrint(#function, "Error: Cannot backup folder", folderName, error)
                return
            }
        }
        
        do {
            try fileManager.copyItem(at: folderUrl, to: storageURL)
        } catch {
            debugPrint(#function, "Error: Cannot move folder", folderName, error)
            return
        }
        
        debugPrint("Successfully replaced Submitted DB!", storageURL)
    }
    ```
    </p>
    </details>
4. Done
