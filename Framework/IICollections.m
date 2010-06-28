//
//  IICollections.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-27.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IICollections.h"


@implementation IICollections

+ (void) addToNSMutableArray: (NSMutableArray *) theArray varargs: firstObject, ... {
    if (firstObject != nil) {
        va_list ap;
        va_start(ap, firstObject);
        
        id object = nil;
        
        do {
            object = va_arg(ap, id);
            [theArray addObject:firstObject];
        } while (object != nil);
        
        va_end(ap);
    }
}

@end
