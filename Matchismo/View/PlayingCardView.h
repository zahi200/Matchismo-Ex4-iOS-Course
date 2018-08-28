// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Zahi Ajami.

#import "CardView.h"
#import "PlayingCardDeck.h"

@interface PlayingCardView : CardView

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

- (void)setPlayingCardPropertiesWithSuit:(NSString *)suit rank:(NSUInteger)rank faceUp:(BOOL)faceUp;

@end
