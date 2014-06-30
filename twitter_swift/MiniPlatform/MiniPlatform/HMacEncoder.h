//
//  HMacEncoder.h
//  MiniPlatform
//
//  Created by Robert Diamond on 6/8/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMacEncoder : NSObject

- (instancetype)initWithKeyString:(NSString *)keyString;
- (NSData *)performEncoding:(NSString *)stringData;

@end
