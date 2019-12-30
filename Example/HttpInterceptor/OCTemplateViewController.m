#import "OCTemplateViewController.h"

@interface OCTemplateViewController ()

@property(nonatomic,strong) HttpInterceptor *interceptor;

@end

@implementation OCTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 这里只是做OC的调用，来检查 OC 是否可以编译通过。
    // 实际上，如果Interceptor 和 Mocker 同时拦截了一个Reuqest，只会回调给Mocker的代理。
    [self registerMocker];
    [self registerInterceptor];
}


- (void)dealloc
{
    [self.interceptor unregister];
}


// MARK: -- Interceptor
- (void)registerInterceptor {
    HttpIntercepCondition *condition = [[HttpIntercepCondition alloc] initWithSchemeType:InterceptSchemeTypeAll condition:^BOOL(NSURLRequest * request) {
        return YES;
    }];
    self.interceptor = [[HttpInterceptor alloc] initWithCondition:condition interceptorDelegate:self];
    [self.interceptor register];
}

- (NSURLRequest *)httpRequestWithRequest:(NSURLRequest *)request {
    NSLog(@"httpRequestWithRequest: request:");
    return request;
}

- (NSURLResponse *)httpRequestWithResponse:(NSURLResponse *)response {
    NSLog(@"httpRequestWithResponse: response:");
    return response;
}

- (NSData *)httpRequestWithRequest:(NSURLRequest *)request data:(NSData *)data {
    NSLog(@"httpRequestWithRequest: data:");
    return data;
}

- (void)httpRequestWithRequest:(NSURLRequest *)request didCompleteWithError:(NSError *)error {
    NSLog(@"httpRequestWithRequest: didCompleteWithError:");
}

- (void)httpRequestWithRequest:(NSURLRequest *)request didFinishCollecting:(NSURLSessionTaskMetrics *)metrics {
    NSLog(@"httpRequestWithRequest: didFinishCollecting:");
}

// MARK: -- Mocker
- (void)registerMocker {
    HttpIntercepCondition *condition = [[HttpIntercepCondition alloc] initWithSchemeType:InterceptSchemeTypeAll condition:^BOOL(NSURLRequest * request) {
        return YES;
    }];
    self.interceptor = [[HttpInterceptor alloc] initWithCondition:condition mockerDelegate:self];
    [self.interceptor register];
}

- (HttpMocker *)httpMockerWithRequest:(NSURLRequest *)request {
    return [[HttpMocker alloc] initWithDataType:HttpMockerDataTypeJson mockData:[NSData new] statusCode:200 httpVer:HttpMockerHttpTypeHttp1_1 headerFields:NULL];
}

@end
