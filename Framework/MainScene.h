//
//  IIMainScene.h
//  iiCaptain
//
//  Created by Richardson Oliveira on 10-07-25.
//  Copyright 2010 Eye Eye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"



@interface MainScene : CCLayer {

}

+(id) scene;

-(void)newGame: (id)sender;
-(void)options: (id)sender;
-(void)help: (id)sender;
-(void)credits: (id)sender;


@end
