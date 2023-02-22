//
//  AFDBaseSwizzleDemo.m
//  AFNetworkingDemo
//
//  Created by jipengfei on 2023/2/21.
//

#import "AFDBaseSwizzleDemo.h"

@implementation AFDBaseSwizzleDemo

- (void)suspend {
    NSLog(@"%@ - suspend", NSStringFromClass(self.class));
}

- (void)resume {
    NSLog(@"%@ - resume", NSStringFromClass(self.class));
}

@end
