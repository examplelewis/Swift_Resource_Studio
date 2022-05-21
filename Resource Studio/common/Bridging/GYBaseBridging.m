//
//  GYBaseBridging.m
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

#import <Foundation/Foundation.h>

NSString *GYCompileDate(void) {
    return [NSString stringWithUTF8String:__DATE__];
}
NSString *GYCompileTime(void) {
    return [NSString stringWithUTF8String:__TIME__];
}
