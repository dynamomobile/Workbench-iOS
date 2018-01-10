#import <UIKit/UIKit.h>

@interface UIView (Context)

+ (id)contextValueForKey:(NSString*)key;
+ (void)setContextValue:(id)value forKey:(NSString*)key;
+ (void)setFullContext:(NSDictionary*)context;
+ (void)mergeContext:(NSDictionary*)context;
+ (NSMutableDictionary*)fullContext;

- (id)contextValueForKey:(NSString*)key;
- (void)setContextValue:(id)value forKey:(NSString*)key;
- (void)setFullContext:(NSDictionary*)context;
- (void)mergeContext:(NSDictionary*)context;
- (NSMutableDictionary*)fullContext;

@end
