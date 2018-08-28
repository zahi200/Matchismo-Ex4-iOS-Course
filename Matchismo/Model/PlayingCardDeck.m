//  Created by Zahi Ajami on 25/07/2018.
//  Copyright © 2018 Lightricks. All rights reserved.

#import "PlayingCardDeck.h"

@implementation PlayingCardDeck

- (instancetype)init {
  if (self = [super init]) {
    for (NSString *suit in [PlayingCard validSuits]) {
      for (NSUInteger rank=1; rank <= [PlayingCard maxRank]; rank++) {
        PlayingCard *card = [[PlayingCard alloc] init];
        card.rank = rank;
        card.suit = suit;
        [self addCard:card];
      }
    }
  }
  return self;
}

@end
