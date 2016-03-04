---
layout: post
title: "Цікаві можливості Objective-C"
date: 2014-02-06 17:19
comments: true
categories: iOS 
---
###1. Безіменні методи
>(for fun)

Ім'я методу задавати не обов'язково, якщо у нього є аргументи. Нерідко зустрічаються методи типу `- (void) setSize: (CGFloat) x: (CGFloat) y`, але це можна довести і до абсолюту:

{% codeblock lang:objc %}
@interface TestObject : NSObject
	
+ (id):(int)value;
- (void):(int)a;
- (void):(int)a :(int)b;
	
@end
	
// ...
	
TestObject *obj = [TestObject :2];
[obj :4];
[obj :5 :7];
{% endcodeblock %}

Тоді селектори для таких методів виглядатимуть так: `@selector(:)` і `@selector(::)`.


<!-- more --> 

###2. Літерали
Можна замінити наступні конструкції на коротші:

{% codeblock lang:objc %}
[NSArray arrayWithObjects:@"1", @"2", @"3", nil] => @[@"1", @"2", @"3"];
[NSDictionary dictionaryWithObjects:@"1", @"2", @"3", nil forKeys:@"one", @"two", @"three", nil] => @{@"one" : @"1", @"two" : @"2", @"three" : @"3"}
{% endcodeblock %}
Ще приклади:

{% codeblock lang:objc %}
[NSNumber numberWithChar:'A'] => NSNumber *theA = @'A';          

//Цілі
[NSNumber numberWithInt:42] =>  NSNumber *fortyTwo = @42;
[NSNumber numberWithUnsignedInt:42U] => NSNumber *fortyTwoUnsigned = @42U; 
[NSNumber numberWithLong:42L] => NSNumber *fortyTwoLong = @42L;
[NSNumber numberWithLongLong:42LL] => NSNumber *fortyTwoLongLong = @42LL;
	
//З плаваючою комою
[NSNumber numberWithFloat:3.141592654F] => NSNumber *piFloat = @3.141592654F;
[NSNumber numberWithDouble:3.1415926535] => NSNumber *piDouble = @3.1415926535;

//Булеві
[NSNumber numberWithBool:YES] => NSNumber *yesNumber = @YES;
[NSNumber numberWithBool:NO] => NSNumber *noNumber = @NO;
{% endcodeblock %}
Квадратні дужки для доступу до елементів масиву або словника можна використовувати і зі своїми об'єктами. Для цього потрібно оголосити такі методи. 

Для доступу за індексом:
 
{% codeblock lang:objc %}
- (id) objectAtIndexedSubscript:(NSUInteger)index; 
- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)index; 
{% endcodeblock %}

Для доступу по ключу: 

{% codeblock lang:objc %}
- (id) objectForKeyedSubscript:(id)key; 
- (void) setObject:(id)obj forKeyedSubscript:(id)key; 
{% endcodeblock %}

використовуємо: 

{% codeblock lang:objc %}
id a = obj[1]; 
obj[@"key"] = a;
{% endcodeblock %}	

###3. Неявні @property 

Оголошення @property в хедері насправді оголошує лише геттер і сеттер для деякого поля. Можна їх оголосити безпосередньо, якщо потрібна якась дія при виклику/модифікації змінної: 

{% codeblock lang:objc %}
- (int) value; 
- (void) setValue: (int) newValue; 

obj.value = 2; 
int i = obj.value; 
{% endcodeblock %}

А ще - функції, ім'я яких починається на «set», нічого не повертають, але що приймають один аргумент: 

{% codeblock lang:objc %}
@ interface TestObject: NSObject 
- (Void) setTitle: (NSString *) title; 
@ end; 
	
// ... 

TestObject * obj = [TestObject new]; 
obj.title = @ "simple object";
{% endcodeblock %}

###4. NSFastEnumeration

Ще одна цікава фіча ObjC : цикли for .. in . Їх підтримують всі дефолтні колекції , але можемо підтримати і ми . Для цього треба підтримати протокол NSFastEnumeration , а точніше - визначити метод `countByEnumeratingWithState:objects:count:` , але не все так просто! Ось сигнатура цього методу :

{% codeblock lang:objc %}
- ( NSUInteger ) countByEnumeratingWithState : ( NSFastEnumerationState * ) state objects : ( id __ unsafe_unretained []) buffer count : ( NSUInteger ) len
{% endcodeblock %}
Цей метод буде викликаний кожен раз , коли runtime захоче отримати від нас нову порцію об'єктів. Їх ми повинні записати або в наданий буфер (розмір його `len` ), або виділити свій . Покажчик на цей буфер треба помістити в поле `state - > itemsPtr` , а кількість об'єктів в ньому повернути з функції. Так само не забуваємо , що ( в документації цього немає ) поле `state - > mutationsPtr` не повинно бути порожнім. Якщо цього не зробити , то ми отримаємо несподіваний `SEGFAULT` . А от у поле `state - > state` можна записати що завгодно , але найкраще - записати кількість вже відданих елементів . Якщо віддавати більше нічого, треба повернути нуль.

Ось мій приклад реалізації цієї функції:

{% codeblock lang:objc %}
- ( NSUInteger ) countByEnumeratingWithState : ( NSFastEnumerationState * ) state objects : ( id __ unsafe_unretained []) buffer count : ( NSUInteger ) len
{
    if ( state - > state > = _value )
    {
        return 0 ;
    }
    NSUInteger itemsToGive = MIN ( len , _value - state - > state ) ;
    for ( NSUInteger i = 0 ; i < itemsToGive ; + + i )
    {
        buffer [ i ] = @ ( _values ​​[ i + state - > state ] ) ;
    }
    state - > itemsPtr = buffer ;
    state - > mutationsPtr = & state - > extra [0];
    state - > state + = itemsToGive ;
    return itemsToGive ;
}
{% endcodeblock %}

Тепер можна використовувати:

{% codeblock lang:objc %}
for (NSNumber * n in obj)
{
    NSLog (@"n = %@",n) ;
}
{% endcodeblock %}

###5. SWITCH CASE для NSString
{% codeblock lang:objc %}
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT
{% endcodeblock %}	

###6. Back в UINavigationBar 
Замінити кнопку на картинку

{% codeblock lang:objc %}
[[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_nav_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 21.f, 0.f, 5.f)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];	
{% endcodeblock %}                                                    
або забрати текст

{% codeblock lang:objc %}
[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment: 	UIOffsetMake(0.f, -44.f) forBarMetrics:UIBarMetricsDefault];
{% endcodeblock %}

###6. Об'явлення сінглтона	 
{% codeblock lang:objc %}	
+ (id)sharedManager {
   	static MyManager *sharedMyManager = nil;
   	static dispatch_once_t onceToken;
   	dispatch_once(&onceToken, ^{
   	    sharedMyManager = [[self alloc] init];
   	});
   	return sharedMyManager;
}
{% endcodeblock %}

###7. Макроси
Корисна біблітечка на [Github](https://github.com/pilot34/P34Utils)

Приклад макроса:

{% codeblock lang:objc %}
#define SPRINTF(format, args...) [NSString stringWithFormat:(format), args]
{% endcodeblock %}
і виклик:

{% codeblock lang:objc %}
NSString *str = SPRINTF(@"%@ %.2f [%d]", @"string", 3.1415f , 2*3*7);
NSLog(@"%@", str);

	string 3.14 [42]
{% endcodeblock %}
Список зручних макросів. Запишіть їх у файлик, і підключіть в `<project_name>-Prefix.pch`

{% codeblock lang:objc %}
    #define ApplicationDelegate                 ((MyAppDelegate *)[[UIApplication sharedApplication] delegate])
    #define UserDefaults                        [NSUserDefaults standardUserDefaults]
    #define SharedApplication                   [UIApplication sharedApplication]
    #define Bundle                              [NSBundle mainBundle]
    #define MainScreen                          [UIScreen mainScreen]
    #define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
    #define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
    #define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
    #define NavBar                              self.navigationController.navigationBar
    #define TabBar                              self.tabBarController.tabBar
    #define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
    #define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
    #define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
    #define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
    #define TouchHeightDefault                  44
    #define TouchHeightSmall                    32
    #define ViewWidth(v)                        v.frame.size.width
    #define ViewHeight(v)                       v.frame.size.height
    #define ViewX(v)                            v.frame.origin.x
    #define ViewY(v)                            v.frame.origin.y
    #define SelfViewWidth                       self.view.bounds.size.width
    #define SelfViewHeight                      self.view.bounds.size.height
    #define RectX(f)                            f.origin.x
    #define RectY(f)                            f.origin.y
    #define RectWidth(f)                        f.size.width
    #define RectHeight(f)                       f.size.height
    #define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
    #define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
    #define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
    #define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
    #define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
    #define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
    #define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
    #define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
    #define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
    #define RGB(r, g, b)   [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
    #define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
{% endcodeblock %}    

###8. Дата в залежності від мови девайса

{% codeblock lang:objc %}
+ (NSString*) relativeFormatOfDate: (NSDate*) value
    {

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSLocale *frLocale = [NSLocale currentLocale];
        [dateFormatter setLocale:frLocale];
        
        [dateFormatter setDoesRelativeDateFormatting:YES];
        
        NSString *dateString = [dateFormatter stringFromDate:value];
        
        return dateString;
        
    }
{% endcodeblock %}    
    
    
###9. colorWithHexString
{% codeblock lang:objc %}
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
    {
        NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        // String should be 6 or 8 characters
        if ([cString length] < 6) return [UIColor blackColor];
        // strip 0X if it appears
        if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
        if ([cString length] != 6) return [UIColor blackColor];
        // Separate into r, g, b substrings
        // NSLog(@"Color str: %@",stringToConvert);
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
}

{% endcodeblock %}

###10. Валідація

{% codeblock lang:objc %}
 +(BOOL) validate: (NSString*) value
    {
    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"!~`@#$%^&*-+();:={}[],.<>?\\/\""];
        if ([value.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
            return NO;
        }else{
            return YES;
        }
    }




    + (BOOL) validateEmail: (NSString *) value
    {
        NSString *emailRegex =
        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        return [emailPredicate evaluateWithObject:value];
    }
{% endcodeblock %}    

###11. UIImage to NSString
Шифруємо картинку в текст:

{% codeblock lang:objc %}
NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"arrow_back"]);
NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
{% endcodeblock %}
    
і розшифровуємо:

{% codeblock lang:objc %}
UIImage* image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters]];
{% endcodeblock %}

###12.Список всіх методів класу (і приватних також)
Нащо? Щоб випадково їх не перевизначити при створенні категорій
{% codeblock lang:objc %}
Class elem = [UIViewController class];
    while (elem) {
        NSLog(@"%s", class_getName( elem ));
        unsigned int numMethods = 0;
        Method *mList = class_copyMethodList(elem, &numMethods);
        if (mList) {
            for (int j=0; j < numMethods; j++) {
                NSLog(@" %s",
                      sel_getName(method_getName(mList[j])));
            }
            free(mList);
        }
        if (elem == [NSObject class]) {
            break;
        }
        elem = class_getSuperclass(elem);
    }

{% endcodeblock %}

Кумедно, в класі UIViewController хлопці з Apple назвали якийсь метод:
{% codeblock lang:objc %}
attentionClassDumpUser:yesItsUsAgain:
althoughSwizzlingAndOverridingPrivateMethodsIsFun:
itWasntMuchFunWhenYourAppStoppedWorking:
pleaseRefrainFromDoingSoInTheFutureOkayThanksBye:
{% endcodeblock %}


###13. Переходи до наступного UITextView
`UITextFieldDelegate`  
{% codeblock lang:objc %}
#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)sender{
    //Set sequence of textfields in xib file
    int index = [self.view.subviews indexOfObject:sender];
    for (int i = index+1; i < self.view.subviews.count; i++) {
        UITextField *textView = (UITextField *)self.view.subviews[i];
        if([textView isKindOfClass:[UITextField class]]){
            [textView becomeFirstResponder];
            return YES;
        }
    }
    //touched last button
    [self dismissKeyboard];
    [self login:nil];
    
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

{% endcodeblock %}

###14. Shake UIView

{% codeblock lang:objc %}
CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    [ self.emblemPicture.layer addAnimation:anim forKey:nil ] ;
    
    
- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

{% endcodeblock %}