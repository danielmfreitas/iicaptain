//
//  IIFollowPathBehavior.h
//  iiCaptain
//
//  Created by Daniel Freitas on 10-07-05.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import "IIBehaviorProtocol.h"

@class IISmoothPath;
@class IILine2D;

/**
 * Makes a IIBehavioral object follow a path defined by a IISmoothPath. This behavior will "consume" the path (i.e.
 * will delete sections of the path until the end of the path is reached). If the path is empty or has been fully
 * consumed, the behavior is skipped.
 * <p/>
 * Changing the IISmoothPath object (i.e. by adding more lines in case it is empty) makes the behavior resume and start
 * moving the object again.
 * <p/>
 * This behavior moves and rotates the object through the general purpose setXXX and getXXX methods defined in the
 * IIBehavioralProtocol.
 */
@interface IIFollowPathBehavior : NSObject <IIBehaviorProtocol> {
    IISmoothPath *pathToFollow;
}

- (IIFollowPathBehavior *) init;
- (IIFollowPathBehavior *) initWithSmoothPath: (IISmoothPath *) thePathToFollow;
- (void) followNewPath: (IISmoothPath *) theNewPath;

@end
