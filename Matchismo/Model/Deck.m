//
//  Deck.m
//  Ex4
//
//  Created by Zahi Ajami on 25/07/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation Deck

- (NSMutableArray *)cards {
  if (!_cards) {
    _cards = [[NSMutableArray alloc] init];
  }
  return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop {
  if (atTop) {
    [self.cards insertObject:card atIndex:0];
  } else {
    [self.cards addObject:card];
  }
}

- (void)addCard:(Card *)card {
  [self addCard:card atTop:NO];
}

- (Card *)drawRandomCard {
  Card *randomCard = nil;
  if ([self.cards count]) {
    unsigned index = arc4random() % [self.cards count];
//    unsigned index = 0;
    randomCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }
  return randomCard;
}

@end
