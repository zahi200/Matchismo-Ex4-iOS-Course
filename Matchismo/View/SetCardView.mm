// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Zahi Ajami.

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;
@end

@implementation SetCardView

static const CGFloat kWidthPercentage = 0.7;
static const CGFloat kCornerFontStandardHeight = 180.0;
static const CGFloat kCornerRadius = 12.0;

- (void)setSetCardPropertiesWithSymbol:(NSUInteger)symbol
                                number:(NSUInteger)number
                               shading:(NSUInteger)shading
                                 color:(NSUInteger)color {
  self.symbol = symbol;
  self.number = number;
  self.shading = shading;
  self.color = color;
  [self setNeedsDisplay];
}

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / kCornerFontStandardHeight;
}

- (CGFloat)cornerRadius {
  return kCornerRadius * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}


- (void)handleMatchedCard {
  if (!self.superview) {
    return;
  }
  self.alpha = 1;
  [UIView animateWithDuration:1.0
                        delay:0.0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     int x = (arc4random()%(int)(self.superview.bounds.size.width*5)) - (int)self.superview.bounds.size.width*2;
                     int y = -self.superview.bounds.size.height;
                     self.center = CGPointMake(x, y);
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       [self removeFromSuperview];
                     }
                   }];
}

- (BOOL)shouldAllocateCellInGridForMatchedCard {
  return NO;
}


- (void)drawRect:(CGRect)rect {
  
  UIBezierPath *cardRoundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                             cornerRadius:[self cornerRadius]];
  [cardRoundedRect addClip]; // we don't want to draw outside this roundedRect
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [cardRoundedRect stroke];
  
  [self paintSetCard];
}


- (void)paintSetCard {
  if (self.symbol == 1) {
    [self paintOvalSetCard];
  } else if (self.symbol == 2) {
    [self paintDiamondSetCard];
  } else if (self.symbol == 3) {
    [self paintSquiggleSetCard];
  }
}


- (UIColor *)getCardColor {
  if (self.color == 1) {
    return [UIColor redColor];
  } else if (self.color == 2) {
    return [UIColor purpleColor];
  } else if (self.color == 3) {
    return [UIColor greenColor];
  }
  return [UIColor yellowColor];
}


- (void)fillSetCardInPath:(UIBezierPath *)path {
  UIColor *cardColor = [self getCardColor];
  if (self.shading == 1) {
    return;
  } else if (self.shading == 2) {
    [cardColor setFill];
    [path fill];
  } else if (self.shading == 3) {
    CGRect bounds = path.bounds;
    UIBezierPath *stripes = [UIBezierPath bezierPath];
    for (int x = 0; x < bounds.size.width; x += self.bounds.size.width/30) {
      [stripes moveToPoint:CGPointMake(bounds.origin.x + x, bounds.origin.y)];
      [stripes addLineToPoint:CGPointMake(bounds.origin.x + x, bounds.origin.y + bounds.size.height)];
    }
    [stripes setLineWidth:0.4];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [path addClip];
    [cardColor setStroke];
    [stripes stroke];
    CGContextRestoreGState(context);
  }
}


- (void)paintOvalSetCard {
  NSUInteger number = self.number;
  
  CGFloat ovalSetCardHeight = self.bounds.size.height / 6.0;
  CGFloat ovalSetCardWidth = self.bounds.size.width * kWidthPercentage;
  CGFloat ovalSetCardCornerRadius = ovalSetCardHeight / 2.0;
  
  
  CGFloat centerViewY = self.bounds.origin.y + self.bounds.size.height / 2.0;
  CGFloat centerViewX = self.bounds.origin.x + self.bounds.size.width / 2.0;
  CGFloat verticalSpaceBetweenConsecutiveSymbols = ovalSetCardHeight / 2.0;
  CGFloat ovalSetCardOriginX = centerViewX  -  ovalSetCardWidth / 2.0;
  CGFloat ovalSetCardOriginYTopSymbol = centerViewY - number * ovalSetCardHeight / 2.0 - (number - 1) / 2.0 * verticalSpaceBetweenConsecutiveSymbols;
  CGFloat ovalSetCardOriginYCurrentSymbol;
  
  UIColor *cardColor = [self getCardColor];
  
  for (int i = 0; i < number ; i++) {
    
    ovalSetCardOriginYCurrentSymbol = ovalSetCardOriginYTopSymbol + i * (ovalSetCardHeight + verticalSpaceBetweenConsecutiveSymbols);
    
    CGRect ovalSetCardRect = CGRectMake(ovalSetCardOriginX, ovalSetCardOriginYCurrentSymbol, ovalSetCardWidth, ovalSetCardHeight);
    
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:ovalSetCardRect
                                                           cornerRadius:ovalSetCardCornerRadius];
    
    [cardColor setStroke];
    [roundedRect stroke];
    
    [self fillSetCardInPath:roundedRect];
  }
}


- (void)paintDiamondSetCard {
  CGFloat setCardSymbolHeight = self.bounds.size.height / 6.0;
  CGFloat setCardSymbolWidth = self.bounds.size.width * kWidthPercentage;

  CGFloat centerViewY = self.bounds.origin.y + self.bounds.size.height / 2.0;
  CGFloat centerViewX = self.bounds.origin.x + self.bounds.size.width / 2.0;
  CGFloat verticalSpaceBetweenConsecutiveSymbols = setCardSymbolHeight / 2.0;

  CGFloat setCardSymbolOriginX = centerViewX  -  setCardSymbolWidth / 2.0;
  CGFloat setCardOriginYTopSymbol = centerViewY - self.number * setCardSymbolHeight / 2.0 - (self.number - 1) / 2.0 * verticalSpaceBetweenConsecutiveSymbols;
  CGFloat setCardOriginYCurrentSymbol;

  UIColor *cardColor = [self getCardColor];
  
  for (int i = 0; i < self.number ; i++) {

    setCardOriginYCurrentSymbol = setCardOriginYTopSymbol + i * (setCardSymbolHeight + verticalSpaceBetweenConsecutiveSymbols);

    UIBezierPath *diamondSymbolPath = [[UIBezierPath alloc] init];

    [diamondSymbolPath moveToPoint:CGPointMake(setCardSymbolOriginX + setCardSymbolWidth / 2.0, setCardOriginYCurrentSymbol)];
    [diamondSymbolPath addLineToPoint:CGPointMake(setCardSymbolOriginX + setCardSymbolWidth, setCardOriginYCurrentSymbol + setCardSymbolHeight / 2.0)];
    [diamondSymbolPath addLineToPoint:CGPointMake(setCardSymbolOriginX + setCardSymbolWidth / 2.0, setCardOriginYCurrentSymbol + setCardSymbolHeight)];
    [diamondSymbolPath addLineToPoint:CGPointMake(setCardSymbolOriginX, setCardOriginYCurrentSymbol + setCardSymbolHeight / 2.0)];

    [diamondSymbolPath closePath];

    [cardColor setStroke];
    [diamondSymbolPath stroke];

    [self fillSetCardInPath:diamondSymbolPath];
  }
}

- (void)paintSquiggleSetCard {
  CGFloat setCardSymbolHeight = self.bounds.size.height / 6.0;
  CGFloat setCardSymbolWidth = self.bounds.size.width * kWidthPercentage;
  
  CGFloat centerViewY = self.bounds.origin.y + self.bounds.size.height / 2.0;
  CGFloat centerViewX = self.bounds.origin.x + self.bounds.size.width / 2.0;
  CGFloat verticalSpaceBetweenConsecutiveSymbols = setCardSymbolHeight / 2.0;
  
  CGFloat setCardSymbolOriginX = centerViewX  -  setCardSymbolWidth / 2.0;
  CGFloat setCardOriginYTopSymbol = centerViewY - self.number * setCardSymbolHeight / 2.0 - (self.number - 1) / 2.0 * verticalSpaceBetweenConsecutiveSymbols;
  CGFloat setCardOriginYCurrentSymbol = setCardOriginYTopSymbol;
  
  UIColor *cardColor = [self getCardColor];
  
  for (int i = 0; i < self.number ; i++) {
    
    setCardOriginYCurrentSymbol = setCardOriginYTopSymbol + i * (setCardSymbolHeight + verticalSpaceBetweenConsecutiveSymbols);
    
    UIBezierPath *squiggleSymbolPath = [[UIBezierPath alloc] init];
    
    squiggleSymbolPath = [self drawSquiggleAtPoint:CGPointMake(setCardSymbolOriginX, setCardOriginYCurrentSymbol)];
    
    [cardColor setStroke];
    [squiggleSymbolPath stroke];
    
    [self fillSetCardInPath:squiggleSymbolPath];
  }
}

// from: https://stackoverflow.com/questions/25387940/how-to-draw-a-perfect-squiggle-in-set-card-game-with-objective-c
- (UIBezierPath *)drawSquiggleAtPoint:(CGPoint)point {
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  CGSize size = CGSizeMake(self.bounds.size.width * kWidthPercentage, self.bounds.size.height);
  UIBezierPath *path = [[UIBezierPath alloc] init];
  
  [path moveToPoint:CGPointMake(104, 15)];
  [path addCurveToPoint:CGPointMake(63, 54) controlPoint1:CGPointMake(112.4, 36.9) controlPoint2:CGPointMake(89.7, 60.8)];
  [path addCurveToPoint:CGPointMake(27, 53) controlPoint1:CGPointMake(52.3, 51.3) controlPoint2:CGPointMake(42.2, 42)];
  [path addCurveToPoint:CGPointMake(5, 40) controlPoint1:CGPointMake(9.6, 65.6) controlPoint2:CGPointMake(5.4, 58.3)];
  [path addCurveToPoint:CGPointMake(36, 12) controlPoint1:CGPointMake(4.6, 22) controlPoint2:CGPointMake(19.1, 9.7)];
  [path addCurveToPoint:CGPointMake(89, 14) controlPoint1:CGPointMake(59.2, 15.2) controlPoint2:CGPointMake(61.9, 31.5)];
  [path addCurveToPoint:CGPointMake(104, 15) controlPoint1:CGPointMake(95.3, 10) controlPoint2:CGPointMake(100.9, 6.9)];
  
  [path applyTransform:CGAffineTransformMakeScale(0.92 * size.width / 100, 0.2 * size.height / 50)];
  [path applyTransform:CGAffineTransformMakeTranslation(point.x - width * 0.02, point.y - height * 0.05)];
  
  return path;
}

@end
