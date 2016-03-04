---
layout: post
title: "Гарний код Objective-C"
date: 2014-04-03 09:59
comments: true
categories: iOS

---

За основу я використав [NYTimes Objective-C Style Guide](https://github.com/NYTimes/objective-c-style-guide), якось найбільше сподобалося :)

### Введення
Ось документація від Apple, в якій все детальніше описано:

* [The Objective-C Programming Language](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html)
* [Cocoa Fundamentals Guide](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/Introduction/Introduction.html)
* [Coding Guidelines for Cocoa](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html)
* [iOS App Programming Guide](http://developer.apple.com/library/ios/#documentation/iphone/conceptual/iphoneosprogrammingguide/Introduction/Introduction.html)

<!-- more --> 

###1. Dot-Notation Синтакс
Викликай і задавай поля класу через `.`(крапочку), крім тих випадків, коли поле є immutable.

Отак:

{% codeblock lang:objc %}
self.name = @"Name";
view.backgroundColor = [UIColor orangeColor];
[UIApplication sharedApplication].delegate;
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}
_name = @"Name";
[view setBackgroundColor:[UIColor orangeColor]];
UIApplication.sharedApplication.delegate;	
{% endcodeblock %}

###2. Пробіли

Отак:

{% codeblock lang:objc %}
#import <UIKit/UIKit.h>

@class UnderlinedButton;
	
@interface LoginViewController : UIViewController <UITextFieldDelegate>
	
@property (strong, nonatomic) NSString *heshName;
@property (weak, nonatomic) IBOutlet UnderlinedButton *aboutButton;
	
- (void)setExampleText:(NSString *)text image:(UIImage *)image;
	
@end
	
	
#import "LoginViewController.h"
#import "UnderlinedButton.h"
	
#define MAX_PHOTOS 10
	
@interface LoginViewController ()
	
@property (nonatomic, retain) NSArray *rowAssets;
	
@end

@implementation LoginViewController
	
@synthesize heshName = _heshName;
	
- (instancetype)init {
   	self = [super init]; 
   	if (self) {
 	   // Custom initialization
   	}
   return self;
}
	
#pragma mark -
	
if (user.isHappy) {
	//Do something
}
else {
	//Do something else
}
{% endcodeblock %}

###3. Conditionals

Отак:
{% codeblock lang:objc %}
if (!error) {
   	return success;
}
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}
if (!error)
   	return success;
   	
if (!error) return success;
{% endcodeblock %}
###3. Тринарний оператор

Отак:
{% codeblock lang:objc %}
result = a > b ? x : y;
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}
result = a > b ? x = c > d ? c : d : y;
//use `if`
{% endcodeblock %}
###4. Error handling

Отак:
{% codeblock lang:objc %}
NSError *error;
if (![self trySomethingWithError:&error]) {
    // Handle Error
}
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}
NSError *error;
[self trySomethingWithError:&error];
if (error) {
    // Handle Error
}	
{% endcodeblock %}
###5. Коментарі

Коментар повинен відповідати тільки на питання `чому так?`. Код повинен бути максимально самодокументованим.

###6. Назви

Отак:
{% codeblock lang:objc %}
UIButton *settingsButton;

static const NSTimeInterval NYTArticleViewControllerNavigationFadeAnimationDuration = 0.3;
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}
UIButton *setBut;

static const NSTimeInterval fadetime = 1.7;
{% endcodeblock %}	

Якщо в проекті використовується префікс, то його слід використовувати в назвах класів, протоколів, функцій, констант і typedef
###7. Літерали

Отак:
{% codeblock lang:objc %}
NSArray *names = @[	@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul"];
NSDictionary *productManagers = @{@"iPhone" : @"Kate", @"iPad" : @"Kamal", @"Mobile Web" : @"Bill"};
NSNumber *shouldUseLiterals = @YES;
NSNumber *buildingZIPCode = @10018;
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}
NSArray *names = [NSArray arrayWithObjects:@"Brian", @"Matt", @"Chris", 	@"Alex", @"Steve", @"Paul", nil];
NSDictionary *productManagers = [NSDictionary dictionaryWithObjectsAndKeys: @"Kate", @"iPhone", @"Kamal", @"iPad", @"Bill", @"Mobile Web", nil];
 *shouldUseLiterals = [NSNumber numberWithBool:YES];
NSNumber *buildingZIPCode = [NSNumber numberWithInteger:10018];
{% endcodeblock %}	
###8. CGRect функції

When accessing the `x`, `y`, `width`, or `height`of a `CGRect`, always use the CGGeometry functions instead of direct struct member access. From Apple's CGGeometry reference:

>All functions described in this reference that take CGRect data structures as inputs implicitly standardize those rectangles before calculating their results. For this reason, your applications should avoid directly reading and writing the data stored in the CGRect data structure. Instead, use the functions described here to manipulate rectangles and to retrieve their characteristics.

Отак:
{% codeblock lang:objc %}
CGRect frame = self.view.frame;

CGFloat x = CGRectGetMinX(frame);
CGFloat y = CGRectGetMinY(frame);
CGFloat width = CGRectGetWidth(frame);
CGFloat height = CGRectGetHeight(frame);
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}		
CGRect frame = self.view.frame;

CGFloat x = frame.origin.x;		
CGFloat y = frame.origin.y;
CGFloat width = frame.size.width;
CGFloat height = frame.size.height;
{% endcodeblock %}	
	
###9. Константи

Отак:
{% codeblock lang:objc %}
//.h глобальна константа
extern NSString *const NYTAboutViewControllerCompanyName;

//.m
NSString *const NYTAboutViewControllerCompanyName = @"The New York Times Company";
static const CGFloat NYTImageThumbnailHeight = 50.0;
{% endcodeblock %}
Не так:
{% codeblock lang:objc %}
#define CompanyName @"The New York Times Company"

#define thumbnailHeight 2
{% endcodeblock %}	
###10. Enumerated Types

Отак:
{% codeblock lang:objc %}
typedef NS_ENUM(NSInteger, NYTAdRequestState) {
   	NYTAdRequestStateInactive,
   	NYTAdRequestStateLoading
};

//одночасні значення, через |, перевірка через &
typedef NS_OPTIONS(NSInteger, EOCPermittedDirectory) {
   	EOCPermittedDirectoryUp    =  1 << 0,
   	EOCPermittedDirectoryDown  =  1 << 1,
   	EOCPermittedDirectoryLeft  =  1 << 2,
   	EOCPermittedDirectoryRight =  1 << 3
};
{% endcodeblock %}
###11. Приватні поля
Приватні поля варто визначати в implementation файлі в `@interface`;
Отак:
{% codeblock lang:objc %}
@interface NYTAdvertisement ()

@property (nonatomic, strong) GADBannerView *googleAdView;
@property (nonatomic, strong) ADBannerView *iAdView;
@property (nonatomic, strong) UIWebView *adXWebView;
	
@end
{% endcodeblock %}
###12. Буліан

Отак:
{% codeblock lang:objc %}
@property (assign, getter=isEditable) BOOL editable;

if (!someObject)

if (isAwesome)
if (![someObject boolValue])
{% endcodeblock %}	
Не так:
{% codeblock lang:objc %}
if (someObject == nil) 

if ([someObject boolValue] == NO)
if (isAwesome == YES) 
{% endcodeblock %}	
###13. Сінглтон

Отак:

{% codeblock lang:objc %}
+ (instancetype)sharedInstance {
   static id sharedInstance = nil;

   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
   });

   return sharedInstance;
}
{% endcodeblock %}

###14. Xcode project

The physical files should be kept in sync with the Xcode project files in order to avoid file sprawl. Any Xcode groups created should be reflected by folders in the filesystem. Code should be grouped not only by type, but also by feature for greater clarity.

When possible, always turn on "Treat Warnings as Errors" in the target's Build Settings and enable as many [additional warnings](http://boredzo.org/blog/archives/2009-11-07/warnings) as possible. If you need to ignore a specific warning, use [Clang's pragma feature](http://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas).

###15. Інші Objective-C стилі

* [Google](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml)
* [GitHub](https://github.com/github/objective-c-conventions)
* [Adium](https://trac.adium.im/wiki/CodingStyle)
* [Sam Soffes](https://gist.github.com/soffes/812796)
* [CocoaDevCentral](http://cocoadevcentral.com/articles/000082.php)
* [Luke Redpath](http://lukeredpath.co.uk/blog/my-objective-c-style-guide.html)
* [Marcus Zarra](http://www.cimgf.com/zds-code-style-guide/)
