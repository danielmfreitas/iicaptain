//
//  IIFollowPathBehavior.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIChainableBehavior.h"

@class IISmoothPath;
@class IIGestureManager;

/**
 * This behavior requires IIBehavioralNodeProtocol objects to work properly as it will invoke CCNode's runAction
 * CCRotateBy.
 * <p/>
 * Makes a behavioral node follow a path defined by a IISmoothPath. This behavior will "consume" the path (i.e.
 * will delete sections of the path until the end of the path is reached). If the path is empty or has been fully
 * consumed, the behavior is skipped.
 * <p/>
 * Changing the IISmoothPath object (i.e. by adding more lines in case it is empty) makes the behavior resume and start
 * moving the node again.
 * <p/>
 * This behavior moves and rotates the node through the path to follow.
 */
@interface IIFollowPathBehavior : IIChainableBehavior {
    IISmoothPath *pathToFollow;
    IIGestureManager *gestureManager;
}

- (id) initWithSmoothPath: (IISmoothPath *) thePathToFollow;

- (id) initWithUpdatablePath: (IISmoothPath *) thePathToFollow
                      onNode: (CCNode *) node
           andGestureManager: (IIGestureManager *) theManager;

@end
