//
//  IIMovable.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

// Forward reference to the needed protocol to break circularity.
@protocol IIBehaviorProtocol;

/**
 * Protocol for classes which accept behaviors. Exposes common properties like sped rotation and position to be
 * controled by the behaviors. The protocol provides both direct access to the properties as well as behavior methods so
 * direct manipulation of the properties can be performed if needed, specially in resource constrained devices.
 * <p/>
 * This basic class does not use Vector math.
 */
@protocol IIBehavioralProtocol <NSObject>

/**
 * Gets the current speed of the object. The unit depends on the algorithms used by the bahavior or object
 * (i.e. pixels/second, pixels/frame, meters/second).
 */
- (CGFloat) speed;

/**
 * Sets the current speed of the object. The unit depends on the algorithms used by the bahavior or object
 * (i.e. pixels/second, pixels/frame, meters/second).
 */
- (void) setSpeed: (CGFloat) theSpeed;

/**
 * Gets the current position of the object. The unit depends on the algorithms used by the bahavior or object.
 */
- (CGPoint) position;

/**
 * Sets the current position of the object. The unit depends on the algorithms used by the bahavior or object.
 */
- (void) setPosition: (CGPoint) newPosition;

/**
 * Moves the object the specified number of units over the X and Y coordinates.
 */
- (void) moveByX: (CGFloat) dX andY: (CGFloat) dY;

/**
 * Gets the current rotation of the object. The actual values depend on the type of object being used. For example,
 * cocos2d nodes increases angle clock wise and are measured in degrees. Math functions increase angle counter-clockwise
 * and are usually measured in radians.
 * <p/>
 * Again is a trade-off of a well defined interface versus resource constrainment.
 */
- (CGFloat) rotation;

/**
 * Gets the current rotation of the object. See documentation on rotation to check what values are accepted.
 */
- (void) setRotation: (CGFloat) newRotation;

/**
 * Rotates the object by the specified angle. See documentation on rotation to check what values are accepted.
 */
- (void) rotateBy: (CGFloat) angle;

/**
 * Gets the distance from the object to the destination point.
 */
- (CGFloat) distanceToPoint: (CGPoint) destinationPoint;

/**
 * Gets the shortest distance from the destination angle.
 */
- (CGFloat) distanceFromAngle: (CGFloat) destinationAngle;

/**
 * Adds a new behavior to the object.
 */
- (void) addBehavior: (id <IIBehaviorProtocol>) behaviorToAdd;

@end
