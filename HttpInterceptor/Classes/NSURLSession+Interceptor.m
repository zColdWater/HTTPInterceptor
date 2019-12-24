#import "NSURLSession+Interceptor.h"
#import <objc/runtime.h>
#import <HttpInterceptor/HttpInterceptor-Swift.h>


@implementation NSURLSession (Interceptor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getClassMethod([NSURLSession class], @selector(sessionWithConfiguration:));
        Method swizzleMethod = class_getClassMethod([self class], @selector(swizzle_sessionWithConfiguration:));
        if (originMethod && swizzleMethod) {
            method_exchangeImplementations(originMethod, swizzleMethod);
        }
        originMethod = class_getClassMethod([NSURLSession class], @selector(sessionWithConfiguration:delegate:delegateQueue:));
        swizzleMethod = class_getClassMethod([self class], @selector(swizzle_sessionWithConfiguration:delegate:delegateQueue:));
        if (originMethod && swizzleMethod) {
            method_exchangeImplementations(originMethod, swizzleMethod);
        }
        
        Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
        if ([(id)cls respondsToSelector:sel]) {
            [(id)cls performSelector:sel withObject:@"http"];
            [(id)cls performSelector:sel withObject:@"https"];
        }
    });
}

+ (NSURLSession *)swizzle_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration {
    NSURLSessionConfiguration *newConfiguration = configuration;
    if (!newConfiguration) {
        return nil;
    }
    newConfiguration.protocolClasses = @[[HTTPInterceptorProtocol class]];
    return [self swizzle_sessionWithConfiguration:configuration];
}

+ (NSURLSession *)swizzle_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue {
    NSURLSessionConfiguration *newConfiguration = configuration;
    if (!newConfiguration) {
        return nil;
    }
    newConfiguration.protocolClasses = @[[HTTPInterceptorProtocol class]];
    return [self swizzle_sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
}

@end
