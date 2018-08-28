// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Zahi Ajami.

#import "CardView.h"

@implementation CardView

- (void)awakeFromNib { // since alloc init will not be called here
  [super awakeFromNib];
  [self setup];
}

- (void)setup {
  self.backgroundColor = nil; // don't draw background for me
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw; // if bounds changes - drawRect will be called
}

- (void)setFaceUp:(BOOL)faceUp {
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

- (void)handleMatchedCard {
}

- (BOOL)shouldAllocateCellInGridForMatchedCard{
  return NO;
}

@end
