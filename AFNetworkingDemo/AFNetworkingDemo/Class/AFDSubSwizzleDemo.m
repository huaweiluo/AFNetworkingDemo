//
//  AFDSubSwizzleDemo.m
//  AFNetworkingDemo
//
//  Created by jipengfei on 2023/2/21.
//

#import "AFDSubSwizzleDemo.h"

@implementation AFDSubSwizzleDemo

- (void)suspend {
    NSLog(@"%@ - suspend", NSStringFromClass(self.class));
}

- (void)resume {
    NSLog(@"%@ - resume", NSStringFromClass(self.class));
}

@end
