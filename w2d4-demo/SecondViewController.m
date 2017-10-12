//
//  SecondViewController.m
//  NSNotificationCenter-Example
//
//  Created by Roland Tecson on 2017-10-10.
//  Copyright © 2017 Roland Tecson. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property CGRect originalFrame;
@end

@implementation SecondViewController

#pragma mark - PanGestureRecognizer

- (IBAction)viewPanned:(UIPanGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.originalFrame = self.blueBox.frame;
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint delta = [gestureRecognizer translationInView:self.blueBox];
            self.blueBox.frame = CGRectMake(self.originalFrame.origin.x + delta.x,
                                            self.originalFrame.origin.y + delta.y,
                                            self.originalFrame.size.width,
                                            self.originalFrame.size.height);
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.blueBox.frame = self.originalFrame;
            break;
        }
        default:
            break;
    }
}

@end
