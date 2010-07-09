//
//  IIMovable.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

// Forward reference to the needed protocol to break circularity.
@protocol IIBehaviorProtocol;

@class CCAction;

/**
 * Protocol for classes which accepts behaviors. Basically it exposes properties through getters and setters (much of
 * which are already provided by cocos2d CCNode).
 */
// TODO Instead of exposing objects properties, use general purpose methods like moveBy, rotateBy or getRotationInRadians
// to avoid hardcoding behavior logic to ccnode.
@protocol IIBehavioralProtocol <NSObject>

/**
 * Gets the current speed of the object. The unit depends on the algorithms used by the bahavior or object.
 */
- (CGFloat) speed;

/**
 * Gets the current position of the object. The unit depends on the algorithms used by the bahavior or object.
 */
- (CGPoint) position;

/**
 * Gets the current rotation, in radians, of the object from the X axis (i.e. the rotation within the
 * trigonometric circle). Must normalize the result to 0 <= result < 2pi.
 */
- (CGFloat) rotation;

/**
 * Adds an action to be executed by the object. Respects the cocos2d CCAction API.
 */
- (CCAction*) runAction: (CCAction *) action;

/**
 * Adds a new behavior to an object.
 */
- (void) addBehavior: (id <IIBehaviorProtocol>) behaviorToAdd;

/**
 * Moves the object the specified number of pixels over the X and Y coordinates.
 */
- (void) moveByX: (CGFloat) dX andY: (CGFloat) dY;

/**
 * Rotates the object by the specified angle, in rads.
 */
- (void) rotateBy: (CGFloat) angle;

/**
 * Gets the distance, in pixels, from the object to the destination point.
 */
- (CGFloat) distanceToPoint: (CGPoint) destinationPoint;

/**
 * Gets the shortest distance, in radians, from the destination angle.
 */
- (CGFloat) distanceFromAngle: (CGFloat) destinationAngle;

@end
