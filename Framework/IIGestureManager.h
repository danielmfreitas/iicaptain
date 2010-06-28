//
//  IIGestureManager.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-27.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IICollections.h"


/*
 * IIGestureFilter protocol.
 * =====================================================================================================================
 */
@protocol IIGestureFilter <NSObject>
    -(BOOL) acceptsEvent: (UIGestureRecognizer *) recognizer;
@end

/*
 * IITargetAction interface.
 * =====================================================================================================================
 */
@interface IITargetAction : NSObject
{
    id target;
    SEL action;
    id<IIGestureFilter> filter;
}

@property (nonatomic, readonly) id target;
@property (nonatomic, readonly) SEL action;
@property (nonatomic, readonly) id<IIGestureFilter> filter;

@end

/*
 * IIGesture interface.
 * =====================================================================================================================
 */
@interface IIGesture : NSObject
{
    NSString *name;
    UIGestureRecognizer *gestureRecognizer;
    NSMutableArray *targetActions;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIGestureRecognizer *gestureRecognizer;

- (IIGesture *) initWithName: (NSString *) theName andGestureRecognizer: (UIGestureRecognizer *) theGestureRecognizer;

@end

/*
 * IIGestureManager interface.
 * =====================================================================================================================
 */
@interface IIGestureManager : NSObject {
    UIView *targetView;
    NSMutableDictionary *gesturesDictionary;
}

+ (IIGestureManager *) gestureManagerWithTargetView: (UIView *) targetView;

- (void) addTarget: (id) theTarget action: (SEL) theAction toRecognizer: (NSString *) recognizerName;
- (void) addTarget: (id) theTarget action: (SEL) theAction toRecognizer: (NSString *) recognizerName withFilter: (id<IIGestureFilter>) filter;
- (void) addGesture: (IIGesture *) gesture;
- (void) removeGesture: (IIGesture *) gesture;

@end
