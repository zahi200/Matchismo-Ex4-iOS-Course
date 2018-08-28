// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Zahi Ajami.

// generic playing card view

#import "PlayingCardView.h"

@interface PlayingCardView ()
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView

- (void)handleMatchedCard {
  self.alpha = 0.1;
}

- (BOOL)shouldAllocateCellInGridForMatchedCard {
  return YES;
}

- (void)setPlayingCardPropertiesWithSuit:(NSString *)suit rank:(NSUInteger)rank faceUp:(BOOL)faceUp {
  self.suit = suit;
  self.rank = rank;
  self.faceUp = faceUp;
}

// FROM HERE ON - ONLY PAUL'S CODE FROM LECTURE 6

#pragma mark - Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)faceCardScaleFactor {
  if (!_faceCardScaleFactor) {
    _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
  }
  return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
  _suit = suit;
  [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)) {
    self.faceCardScaleFactor *= gesture.scale;
    gesture.scale = 1.0; // so it will not accumulate, but incremental
  }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0



- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
  return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

- (void)drawRect:(CGRect)rect {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  [roundedRect addClip]; // we don't want to draw outside this roundedRect
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
  
  if (self.faceUp){
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
    if (faceImage) {
      // to make it scale inside and not overlap the corners
      CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0 - self.faceCardScaleFactor), self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
      [faceImage drawInRect:imageRect];
    } else {
      [self drawPips];
    }
    [self drawCorners];
  } else {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
  }
}

#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips {
  if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
    [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
  }
  if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) ||
      (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(self.rank != 7)];
  }
  if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) ||
      (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET3_PERCENTAGE
                    mirroredVertically:YES];
  }
  if ((self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];
  }
}


#define PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset
                  upsideDown:(BOOL)upsideDown {
  if (upsideDown) {
    [self pushContextAndRotateUpsideDown];
  }
  CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
  NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit
                                                                       attributes:@{NSFontAttributeName : pipFont}];
  CGSize pipSize = [attributedSuit size];
  CGPoint pipOrigin = CGPointMake(middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                  middle.y-pipSize.height/2.0-voffset*self.bounds.size.height);
  [attributedSuit drawAtPoint:pipOrigin];
  if (hoffset) {
    pipOrigin.x += hoffset*2.0*self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  if (upsideDown) {
    [self popContext];
  }
  
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically {
  [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
  }
}

- (void)pushContextAndRotateUpsideDown {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (NSString *)rankAsString {
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

- (void)drawCorners {
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
  
  NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle}];
  
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];
  
  
  // now print on the bottom right corner the rotation of what is done so far
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height); // transformation matrix. moving to the bottom right corner
  CGContextRotateCTM(context, M_PI); // rotating by pi-radians (=180 degrees)
  [cornerText drawInRect:textBounds];
}

@end
