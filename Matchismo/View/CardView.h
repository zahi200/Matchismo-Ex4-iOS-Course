// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Zahi Ajami.

#import <UIKit/UIKit.h>

@interface CardView : UIView

- (void)setup;
- (void)setFaceUp:(BOOL)faceUp;
/// abstract
- (void)handleMatchedCard;

- (BOOL)shouldAllocateCellInGridForMatchedCard;

@property (nonatomic) BOOL faceUp;
@end
