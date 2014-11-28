//
//  LLARingSpinnerView.m
//  LLARingSpinnerView
//
//  Created by Lukas Lipka on 05/04/14.
//  Copyright (c) 2014 Lukas Lipka. All rights reserved.
//

#import "LLARingSpinnerView.h"

static NSString *kLLARingSpinnerAnimationKey = @"llaringspinnerview.rotation";

@interface LLARingSpinnerView ()

@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readwrite) BOOL isAnimating;

@end

@implementation LLARingSpinnerView

@synthesize progressLayer = _progressLayer;
@synthesize isAnimating = _isAnimating;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

//New method to instance the spinner already with a parent view
-(id)initWithView:(UIView*)parent {
    CGRect frame = CGRectMake(parent.bounds.size.width * 0.415, parent.bounds.size.height * 0.25, parent.bounds.size.height * 0.3, parent.bounds.size.width * 0.3);

        if(self  =  [super initWithFrame:frame]) {
        [self initialize];
    }
    self.lineWidth = 1.5f;
    self.alpha = 0;
    self.tintColor = [UIColor whiteColor];
    [parent addSubview:self];
    //self.center = [self convertPoint:self.center fromView:self.superview];

    return self;
}

- (void)initialize {
    _hidesWhenStopped = YES;
    [self.layer addSublayer:self.progressLayer];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    self.progressLayer.strokeColor = self.tintColor.CGColor;
    
}

- (void)startAnimating {
    if (self.isAnimating)
        return;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 1.0f;
    animation.fromValue = @(0.0f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [self.progressLayer addAnimation:animation forKey:kLLARingSpinnerAnimationKey];
    self.isAnimating = true;
    
    //New fade in animation
    if (self.hidesWhenStopped) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:2
                         animations:^(void) {
                             self.alpha = 0.5;
                         }
                         completion:NULL];
    }
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;

    [self.progressLayer removeAnimationForKey:kLLARingSpinnerAnimationKey];
    self.isAnimating = false;
    
    //New fade out animation, removing the spinner view after completion
    if (self.hidesWhenStopped) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:2
                         animations:^(void) {
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if(finished)
                                 [self removeFromSuperview];
                         }
         ];
    }
}

//New method to stop animations of all spinners in one view (just in case)
+(void)stopAllSpinnersFromView:(UIView*)parent{
    for (LLARingSpinnerView *spinner in parent.subviews) {
        if ([spinner isKindOfClass: [LLARingSpinnerView class]]) {
                [spinner stopAnimating];
        }
    }
}

#pragma mark - Private

- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) + self.progressLayer.lineWidth * 2;
    CGFloat startAngle = (CGFloat)(-M_PI_4);
    CGFloat endAngle = (CGFloat)(3 * M_PI_2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
}

#pragma mark - Properties

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = [UIColor blackColor].CGColor;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    [self updatePath];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = YES;
    self.hidden = !self.isAnimating && hidesWhenStopped;
}

@end
