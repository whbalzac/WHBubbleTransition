//
//  WHBubbleTransition.m
//
//  Created by whbalzac on 17/8/19.
//
//

#import "WHBubbleTransition.h"

@interface WHBubbleTransition ()

@property (nonatomic, strong) UIView *bubble;

@end

@implementation WHBubbleTransition

-(instancetype)init
{
    if (self = [super init]) {
        self.startPoint = CGPointZero;
        self.duration = 0.5f;
        self.transitionMode = WHBubbleTransitionModePresent;
        self.bubbleColor = [UIColor redColor];
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    if (self.transitionMode == WHBubbleTransitionModePresent) {
        UIView *presentedControllerView = nil;
        if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
            presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
        }
        else {
            presentedControllerView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        }
        
        CGPoint originalCenter = presentedControllerView.center;
        CGSize originalSize = presentedControllerView.frame.size;
        CGFloat lengthX = fmax(self.startPoint.x, originalSize.width - self.startPoint.x);
        CGFloat lengthY = fmax(self.startPoint.y, originalSize.height - self.startPoint.y);
        CGFloat offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
        CGSize size = CGSizeMake(offset, offset);
        
        self.bubble = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.bubble.backgroundColor = [UIColor redColor];
        self.bubble.layer.cornerRadius = size.height/2.0f;
        self.bubble.center = self.startPoint;
        self.bubble.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        containerView.maskView = self.bubble;
        
        presentedControllerView.center = originalCenter;
        [containerView addSubview:presentedControllerView];
        
        [UIView animateWithDuration:self.duration animations:^{
            self.bubble.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];

    }
    else if (self.transitionMode == WHBubbleTransitionModeDismiss) {
        UIView *returningControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:self.duration animations:^{
            self.bubble.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        } completion:^(BOOL finished) {
            [returningControllerView removeFromSuperview];
            [self.bubble removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
    else {
        
    }
}



@end
