#import "UIView+Context.h"
#import <objc/runtime.h>

static const char *contextKey = "ContextKey";

#define DICT_KEY (contextKey+1)
#define BLOCK_KEY (contextKey+2)

static NSMutableDictionary *globalContextDictionary = nil;

@interface UIView ()
- (void)updateContext;
@end

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

- (UIView*)rootView
{
    UIView *view = self;
    while (view.superview) {
        view = view.superview;
    }
    return view;
}

- (void)queueUpdate
{
    UIView *rootView = [self rootView];
    NSNumber *flag = objc_getAssociatedObject(rootView, BLOCK_KEY);
    if (flag == nil) {
        objc_setAssociatedObject(rootView, BLOCK_KEY, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dispatch_async(dispatch_get_main_queue(), ^{
            objc_setAssociatedObject(rootView, BLOCK_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [rootView updateContext];
        });
    }
}

- (id)contextValueForKey:(NSString*)key
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, DICT_KEY);
    if ([dict isKindOfClass:[NSMutableDictionary class]]) {
        id obj = [dict valueForKeyPath:key];
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

- (void)_setContextValue:(id)value forKey:(NSString*)key
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
    [self queueUpdate];
}

- (void)setContextValue:(id)value forKey:(NSString*)key
{
    [self _setContextValue:value forKey:key];
    [self queueUpdate];
}

- (void)setFullContext:(NSDictionary*)context
{
    objc_setAssociatedObject(self, DICT_KEY, [context mutableCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self queueUpdate];
}

- (void)mergeContext:(NSDictionary*)context
{
    for (NSString *key in context.allKeys) {
        [self _setContextValue:context[key] forKey:key];
    }
    [self queueUpdate];
}

- (NSMutableDictionary*)fullContext
{
    return objc_getAssociatedObject(self, DICT_KEY);;
}

@end
