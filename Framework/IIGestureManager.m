//
//  IIGestureManager.m
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-27.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIGestureManager.h"

/**
 * Encapsulates information about the target action where gesture events will be forwarded to. Besides the target and
 * action elements, this object also has a IIGestureFilter which, if present, will be used to check if the event
 * should be forwarded to the target action.
 */
@interface IITargetAction : NSObject
{
    id target;
    SEL action;
    NSMutableArray *filters;
}

@property (nonatomic, readonly) id target;
@property (nonatomic, readonly) SEL action;
@property (nonatomic, readonly) NSArray *filters;

@end

/*
 * IITargetAction implementation.
 * =====================================================================================================================
 */
@implementation IITargetAction

@synthesize target;
@synthesize action;
@synthesize filters;

- (IITargetAction *) initWithTarget: (id) theTarget andAction: (SEL) theAction withFilter: (id<IIGestureFilter>) aFilter {
    if ((self = [super init])) {
        target = theTarget;
        [target retain];
        
        action = theAction;
        
        filters = [[NSMutableArray alloc] init];
        [filters retain];
        
        if (aFilter) {
            [filters addObject:aFilter];
        }
    }
    
    return self;
}

- (IITargetAction *) initWithTarget: (id) theTarget andAction: (SEL) theAction {
    return [self initWithTarget:theTarget andAction:theAction withFilter: nil];
}

- (void) addFilter: (id<IIGestureFilter>) filter {
    if (filter) {
        [filters addObject:filter];
    }
}

- (void) dealloc {
    [filters release];
    [target release];
    
    [super dealloc];
}

@end;

/*
 * IIGesture implementation.
 * =====================================================================================================================
 */
@implementation IITaggedGestureRecognizer

@synthesize name;
@synthesize gestureRecognizer;

- (void) handleGesture: (UIGestureRecognizer *) sender {
    
    for(IITargetAction *targetAction in targetActions) {
        for (id<IIGestureFilter> filter in targetAction.filters) {
            if (![filter acceptsEvent: sender]) {
                return;
            }
        }
        

        [targetAction.target performSelector: targetAction.action withObject: sender];
    }
}

- (IITaggedGestureRecognizer *) initWithName: (NSString *) theName andGestureRecognizer: (UIGestureRecognizer *) theGestureRecognizer {
    if ((self = [super init])) {
        name = theName;
        [name retain];
        
        gestureRecognizer = theGestureRecognizer;
        [gestureRecognizer addTarget:self action:@selector(handleGesture:)];
        [gestureRecognizer retain];
        
        targetActions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addTargetAction: (IITargetAction *) targetAction {
    [targetActions addObject: targetAction];
}

- (void) dealloc {
    [targetActions release];
    [gestureRecognizer release];
    [name release];
    
    [super dealloc];
}

@end

/*
 * IIGestureManager implementation.
 * =====================================================================================================================
 */
@implementation IIGestureManager

@synthesize targetView;

- (id) initWithView: (UIView *) view {
    if ((self = [super init])) {
        gesturesDictionary = [[NSMutableDictionary alloc] init];
        targetView = view;
        [targetView retain];
    }
    
    return self;
}

- (void) addGesture: (UIGestureRecognizer *) gestureRecognizer withTag: (NSString *) tagName {
    IITaggedGestureRecognizer *taggedGesture = [[IITaggedGestureRecognizer alloc] initWithName: tagName
                                                                    andGestureRecognizer: gestureRecognizer];
    [taggedGesture autorelease];

    [gesturesDictionary setObject: taggedGesture forKey: tagName];
    [targetView addGestureRecognizer: gestureRecognizer];
}

- (void) removeGesture: (NSString *) tagName {
    IITaggedGestureRecognizer *taggedGesture = [gesturesDictionary objectForKey: tagName];
    [targetView removeGestureRecognizer: taggedGesture.gestureRecognizer];
    [gesturesDictionary removeObjectForKey: tagName];
}

- (void) addTarget: (id) theTarget action: (SEL) theAction toRecognizer: (NSString *) recognizerName {
    [self addTarget: theTarget action: theAction toRecognizer: recognizerName withFilter: nil];
}

- (void) addTarget: (id) theTarget action: (SEL) theAction toRecognizer: (NSString *) recognizerName withFilter: (id<IIGestureFilter>) filter {
    IITaggedGestureRecognizer *theGesture = [gesturesDictionary objectForKey: recognizerName];
    
    IITargetAction *targetAction = [[IITargetAction alloc] initWithTarget: theTarget andAction: theAction withFilter: filter];
    [theGesture addTargetAction: targetAction];
    
    [targetAction release];
}

- (void) addTarget: (id) theTarget action: (SEL) theAction
      toRecognizer: (NSString *) recognizerName
       withFilters: (id<IIGestureFilter>) firstFilter, ... {
    
    id eachObject;
    va_list argumentList;
    
    // The first argument isn't part of the varargs list,                                  
    if (firstFilter) {
    
        // So we handle it separately.
        IITaggedGestureRecognizer *theGesture = [gesturesDictionary objectForKey: recognizerName];
        IITargetAction *targetAction = [[IITargetAction alloc] initWithTarget: theTarget andAction: theAction withFilter: firstFilter];
        
        // Start scanning for arguments after firstObject.
        va_start(argumentList, firstFilter);          
        
        while ((eachObject = va_arg(argumentList, id))) {
            // As many times as we can get an argument of type "id" that isn't nil, add it to the list.
            [targetAction addFilter: eachObject];
        } 
               
        va_end(argumentList);
        
        [theGesture addTargetAction: targetAction];
        [targetAction release];
    }
}

- (void) dealloc {
    [targetView release];
    [gesturesDictionary release];
    
    [super dealloc];
}

+ (IIGestureManager *) gestureManagerWithTargetView: (UIView *) targetView {
    IIGestureManager *me = [[IIGestureManager alloc] initWithView: targetView];
    return [me autorelease];
}

@end
