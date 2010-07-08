//
//  IIMovable.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCAction;

// Forward reference to the needed protocol to break circularity.
@protocol IIBehaviorProtocol;

/**
 * Protocol for classes which accepts behaviors. Basically it exposes properties through getters and setters (much of
 * which are already provided by cocos2d CCNode).
 */
@protocol IIBehavioralProtocol <NSObject>

/**
 * Gets the current speed of the object. The unit depends on the algorithms used by the bahavior or object.
 */
- (CGFloat) speed;

/**
 * Gets the current rotation of the object. The unit depends on the algorithms used by the bahavior or object. If the
 * object extends CCNode, most likely it will be given in degrees, with 0 (zero) being pointing up (instead of right)
 * like the trigonometric circle.
 */
- (CGFloat) rotation;

/**
 * Gets the position of the object. The position is relative to another entity and depends on the algorithm used by the
 * behavior or the object, but usually it is the coordinate in a cocos2d layer or the device screen.
 */
- (CGPoint) position;

/**
 * Sets the position of the object. The position is relative to another entity and depends on the algorithm used by the
 * behavior or the object, but usually it is the coordinate in a cocos2d layer or the device screen.
 */
- (void) setPosition: (CGPoint) newPosition;

/**
 * Gets the rotation (in degrees) of the object. Like cocos2d nodes, 0 (zero) is pointing upwards to the top of the
 * screen, while rotating by 90 degrees will put the node in the "horizontal".
 */
- (CGFloat) rotation;

/**
 * Sets the rotation (in degrees) of the object. Like cocos2d nodes, 0 (zero) is pointing upwards to the top of the
 * screen, while rotating by 90 degrees will put the node in the "horizontal".
 */
- (void) setRotation: (CGFloat) newRotation;

/**
 * Adds an action to be executed by the object. Respects the cocos2d CCAction API.
 */
- (CCAction*) runAction: (CCAction *) action;

/**
 * Adds a new behavior to an object.
 */
- (void) addBehavior: (id <IIBehaviorProtocol>) behaviorToAdd; 

@end
