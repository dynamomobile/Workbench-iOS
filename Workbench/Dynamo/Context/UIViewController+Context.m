#import <UIKit/UIKit.h>

@implementation UIViewController (Context)

+ (UIViewController*)loadControllerClassByName:(NSString*)name
{
    NSArray *parts = [name componentsSeparatedByString:@"."];
    if (parts.count == 1) {
        return [(UIViewController*)[NSClassFromString(name) alloc] initWithNibName:name bundle:NULL];
    }
    return [(UIViewController*)[NSClassFromString(name) alloc] initWithNibName:parts[1] bundle:NULL];
}

@end
