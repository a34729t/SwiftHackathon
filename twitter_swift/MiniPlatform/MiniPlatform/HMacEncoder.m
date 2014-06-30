//
//  HMacEncoder.m
//  MiniPlatform
//
//  Created by Robert Diamond on 6/8/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

#import "HMacEncoder.h"
#import <CommonCrypto/CommonHMAC.h>

@interface HMacEncoder()

@property (nonatomic) CCHmacContext context;

@end

@implementation HMacEncoder

- (instancetype)initWithKeyString:(NSString *)keyString
{
    if ((self = [self init])) {
        CCHmacInit(&_context, kCCHmacAlgSHA1, [keyString UTF8String], [keyString length]);
    }
    return self;
}

- (NSData *)performEncoding:(NSString *)stringData
{
    CCHmacUpdate(&_context, [stringData UTF8String], [stringData length]);
    NSMutableData *returnData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmacFinal(&_context, returnData.mutableBytes);
    return returnData;
}

@end
