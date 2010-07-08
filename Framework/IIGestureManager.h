//
//  IIGestureManager.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-06-27.
//  Copyright 2010 Eye Eye. All rights reserved.
//

/**
 * This header file contains the definition of the gesture framework for the iiCaptain project. The gestures framework
 * facilitates the job of listening for gesture events. Gestures are identified by a name and any object can register
 * themselves as listeners for those events by providing the gesture name. Filters can also be applied to the events,
 * allowing the framework to decide if the event should be forwarded to the target listener or not.
 */
#import <Foundation/Foundation.h>

/**
 * The protocol to be implemented by classes wishing to act as filters to gesture events. Implementing classes must
 * implement the single method in this protocol to return YES or NO if the gesture event should be forwarded or not
 * to the targetAction.
 */
@protocol IIGestureFilter <NSObject>
    /**
     * Decides if the gesture event will be forwarded to the target action. The recognizer argument is the gesture
     * that has been detected.
     */
    - (BOOL) acceptsEvent: (UIGestureRecognizer *) recognizer;
@end

/**
 * A wrapper around a gesture recognizer which can be identified by a name. Target actions are not assigned directly to
 * the gesture recognizer. Instead, they are held on IITargetAction objects so they can have filters applied to them
 * before dispatching the event.
 */
@interface IITaggedGestureRecognizer : NSObject
{
    NSString *name;
    UIGestureRecognizer *gestureRecognizer;
    NSMutableArray *targetActions;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIGestureRecognizer *gestureRecognizer;

- (IITaggedGestureRecognizer *) initWithName: (NSString *) theName andGestureRecognizer: (UIGestureRecognizer *) theGestureRecognizer;

@end

/**
 * The central piece of the gesture manager framework. The gesture manager ataches itself to a UIView object, catches
 * the gesture events and forwards them to the appropriate target actions.
 * <p/>
 * Gesture recognizers are added though the addGesture: method. The method receives a IITaggedGestureRecognizer as a
 * parameter. Objects wishing to receive notification of a registered gesture must add themselves through the
 * addTarget:action:toRecognizer: method, which receives the object reference, the selector and the name under which
 * the recognizer was registered.
 */
@interface IIGestureManager : NSObject {
    UIView *targetView;
    NSMutableDictionary *gesturesDictionary;
}

@property (nonatomic, readonly) UIView *targetView;

+ (IIGestureManager *) gestureManagerWithTargetView: (UIView *) targetView;

- (void) addTarget: (id) theTarget action: (SEL) theAction toRecognizer: (NSString *) recognizerName;
- (void) addTarget: (id) theTarget action: (SEL) theAction toRecognizer: (NSString *) recognizerName withFilter: (id<IIGestureFilter>) filter;
- (void) addGesture: (IITaggedGestureRecognizer *) gesture;
- (void) removeGesture: (IITaggedGestureRecognizer *) gesture;

@end
