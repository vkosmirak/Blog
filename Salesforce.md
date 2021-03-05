- [Salesforce](#salesforce)
- [Workbench](#workbench)
- [iOS](#ios)

# Salesforce

#### Get packege version

Setup - Installed packages - OCE CRM

#### How to see all changes by admin in the org:
Setup -> Search -> View Setup Audit Trail
    
#### How to get old metadata and Submitted DB from AWS S3
[Confluence link](https://jiraims.rm.imshealth.com/wiki/pages/viewpage.action?pageId=386041515)

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
[Confluence link](https://jiraims.rm.imshealth.com/wiki/pages/viewpage.action?pageId=389285190)

# iOS 

### Load specific Metadata version
Set `TARGET_METADATA_VERSION` in Xcode / Target / Edit scheme (Command+Alt+R - ⌘⌥R)  

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
### Instal older version of Cocoapods
```
sudo gem uninstall cocoapods
sudo gem install cocoapods -v 1.7.5
pod --version
```

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

### Install Submitted DB
[Confluence link](https://jiraims.rm.imshealth.com/wiki/pages/viewpage.action?pageId=384525805)
