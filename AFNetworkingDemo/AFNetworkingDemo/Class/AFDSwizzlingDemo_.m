//
//  AFDSwizzlingDemo_.m
//  AFNetworkingDemo
//
//  Created by jipengfei on 2023/2/21.
//

#import "AFDSwizzlingDemo_.h"
#import "AFDSubSwizzleDemo.h"
#import <objc/runtime.h>

#pragma mark -
#pragma mark c method
//static inline void afd_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
//    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}

static inline BOOL afd_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}

@implementation AFDSwizzlingDemo_

+ (void)load {
    
    Method afdResumeMethod = class_getInstanceMethod(self, @selector(afd_resume));
    afd_addMethod(AFDSubSwizzleDemo.class, @selector(afd_resume), afdResumeMethod);
    
    Method afdSuspendMethod = class_getInstanceMethod(self, @selector(afd_suspend));
    afd_addMethod(AFDSubSwizzleDemo.class, @selector(afd_suspend), afdSuspendMethod);
}

- (void)afd_resume {
    NSLog(@"%@ - afd_resume.", NSStringFromClass(self.class));
//    [self af_resume];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:AFNSURLSessionTaskDidResumeNotification object:self];
}

- (void)afd_suspend {
    NSLog(@"%@ - afd_suspend.", NSStringFromClass(self.class));
//    [self af_suspend];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:AFNSURLSessionTaskDidSuspendNotification object:self];
}


@end
