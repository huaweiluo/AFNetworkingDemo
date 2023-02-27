//
//  ViewController.m
//  AFNetworkingDemo
//
//  Created by jipengfei on 2023/2/20.
//

#import "ViewController.h"
#import <AFNetworking/AFURLSessionManager.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFSecurityPolicy.h>
#import "AFDSubSwizzleDemo.h"

@interface ViewController ()
@property (nonatomic, strong) AFDSubSwizzleDemo *subSwizzleDemo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightTextColor];
    
    [self test];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self mimicGetRequest];
}

#pragma mark -
#pragma mark test method
- (void)test {
//    [self runtimeAddMethodTest];
//    [self normalGetRequestDemo];
//    [self normalPostRequestDemo];
    [self AFNetworkingRequest];
}

#pragma mark -
#pragma mark internal method
- (void)mimicGetRequest {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com/GET"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {

            NSLog(@"Error: %@", error);

        } else {

            NSLog(@"%@ %@", response, responseObject);

        }
    }];
    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//
//        if (error) {
//
//            NSLog(@"Error: %@", error);
//
//        } else {
//
//            NSLog(@"%@ %@", response, responseObject);
//
//        }
//
//    }];

    [dataTask resume];
}

#pragma mark -
#pragma mark runtime - add method test
- (void)runtimeAddMethodTest {
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    SEL selResume = @selector(afd_resume);
#pragma clang diagnostic pop

    if ([self.subSwizzleDemo respondsToSelector:selResume]) {

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
        [self.subSwizzleDemo performSelector:selResume];
#pragma clang diagnostic pop

    }
}

#pragma mark -
#pragma mark 普通GET请求
- (void)normalGetRequestDemo {
    NSURL *getUrl = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLSession *getSession = [NSURLSession sharedSession];
    
    /// 方式一
    NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] initWithURL:getUrl];
    getRequest.HTTPMethod = @"GET";
    NSURLSessionDataTask *getDataTaskRequest = [getSession dataTaskWithRequest:getRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"%@.", error);
        } else {
            
            NSLog(@"%@.", data);
            NSLog(@"%@.", response);
        }
    }];
    [getDataTaskRequest resume];
    
    /// 方式二
    NSURLSessionDataTask *getDataTastUrl = [getSession dataTaskWithURL:getUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"%@.", error);
        } else {
            
            NSLog(@"%@.", data);
            NSLog(@"%@.", response);
        }
    }];
    [getDataTastUrl resume];
}

#pragma mark -
#pragma mark 普通POST请求
- (void)normalPostRequestDemo {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *dicBody = [[NSMutableDictionary alloc] init];
    [dicBody setValue:@"value1" forKey:@"key1"];
    [dicBody setValue:@"value2" forKey:@"key2"];
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dicBody options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = bodyData;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"%@.", error);
        } else {
            
            NSLog(@"%@.", data);
            NSLog(@"%@.", response);
        }
    }];
    
    [dataTask resume];
}

#pragma mark -
#pragma mark AFNetworking GET 请求
- (void)AFNetworkingRequest {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    NSMutableDictionary *dicBody = [[NSMutableDictionary alloc] init];
//    [dicBody setValue:@"value1" forKey:@"key1"];
//    [dicBody setValue:@"value2" forKey:@"key2"];
    
    //** 设置安全策略 */
    [sessionManager setSecurityPolicy:securityPolicy];
    
    //* 默认使用的AFJSONResponseSerializer, 这里修改为AFHTTPResponseSerializer 序列化对象 */
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //** 增加text/html数据格式支持 */
    NSMutableSet *newSet = [[NSMutableSet alloc] initWithSet:sessionManager.responseSerializer.acceptableContentTypes];
    [newSet addObject:@"text/html"];
    sessionManager.responseSerializer.acceptableContentTypes = [newSet copy];
    
    [sessionManager GET:@"https://www.baidu.com" parameters:dicBody headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"completedUnitCount:%lld, totalUnitCount:%lld.", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject:%@.", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@.", error);
        
    }];
}

#pragma mark -
#pragma mark property method
- (AFDSubSwizzleDemo *)subSwizzleDemo {
    if (!_subSwizzleDemo) {
        _subSwizzleDemo = [[AFDSubSwizzleDemo alloc] init];
    }
    return _subSwizzleDemo;
}

@end
