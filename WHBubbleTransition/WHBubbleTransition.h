//
//  WHBubbleTransition.h
//
//  Created by whbalzac on 17/8/19.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WHBubbleTransitionMode) {
    WHBubbleTransitionModePresent,
    WHBubbleTransitionModeDismiss,
};

@interface WHBubbleTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) WHBubbleTransitionMode transitionMode;
@property (nonatomic, strong) UIColor *bubbleColor;

@end

