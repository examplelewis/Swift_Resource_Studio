//
//  RSBaseBridging.m
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

#import <Foundation/Foundation.h>

NSString *RSCompileDate(void) {
    return [NSString stringWithUTF8String:__DATE__];
}
NSString *RSCompileTime(void) {
    return [NSString stringWithUTF8String:__TIME__];
}
