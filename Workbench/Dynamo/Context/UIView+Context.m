#import "UIView+Context.h"
#import <objc/runtime.h>

static const char *contextKey = "ContextKey";

#define DICT_KEY (contextKey+1)

static NSMutableDictionary *globalContextDictionary = nil;

@implementation UIView (Context)

+ (id)contextValueForKey:(NSString*)key
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!globalContextDictionary) {
            globalContextDictionary = [NSMutableDictionary dictionary];
        }
    });
    return globalContextDictionary[key];
}

+ (void)setContextValue:(id)value forKey:(NSString*)key
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!globalContextDictionary) {
            globalContextDictionary = [NSMutableDictionary dictionary];
        }
    });
    if (value) {
        globalContextDictionary[key] = value;
    } else {
        [globalContextDictionary removeObjectForKey:key];
    }
}

+ (void)setFullContext:(NSDictionary*)context
{
    globalContextDictionary = [context mutableCopy];
}

+ (void)mergeContext:(NSDictionary*)context
{
    for (NSString *key in context.allKeys) {
        [UIView setContextValue:context[key] forKey:key];
    }
}

+ (NSMutableDictionary*)fullContext
{
    return globalContextDictionary;
}

- (id)contextValueForKey:(NSString*)key
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, DICT_KEY);
    if ([dict isKindOfClass:[NSMutableDictionary class]]) {
        id obj = dict[key];
        if (obj) {
            return obj;
        }
    }
    if (self.superview) {
        return [self.superview contextValueForKey:key];
    } else {
        return [UIView contextValueForKey:key];
    }
}

- (void)setContextValue:(id)value forKey:(NSString*)key
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, DICT_KEY);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, DICT_KEY, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (value) {
        dict[key] = value;
    } else {
        [dict removeObjectForKey:key];
    }
}

- (void)setFullContext:(NSDictionary*)context
{
    objc_setAssociatedObject(self, DICT_KEY, [context mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mergeContext:(NSDictionary*)context
{
    for (NSString *key in context.allKeys) {
        [self setContextValue:context[key] forKey:key];
    }
}

- (NSMutableDictionary*)fullContext
{
    return objc_getAssociatedObject(self, DICT_KEY);;
}

@end
