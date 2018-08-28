// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Zahi Ajami.

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@implementation SetCardGameViewController

static const int kNumOfCardsInMatchSetGame = 3;
static const int kInitialNumOfCardsInSetCardGame = 12;

- (Deck *)createDeck {
  return [[SetCardDeck alloc] init];
}

- (NSUInteger)getNumOfCardsInMatch {
  return kNumOfCardsInMatchSetGame;
}

- (NSUInteger)getInitialNumOfCards {
  return kInitialNumOfCardsInSetCardGame;
}

- (CardView *)createCardViewFor:(Card *)card WithFrame:(CGRect)frame {
  SetCardView *setCardView = [[SetCardView alloc] initWithFrame:frame];
  [setCardView setup];
  SetCard *setCard = (SetCard *)card;
  [setCardView setSetCardPropertiesWithSymbol:setCard.symbol number:setCard.number
                                      shading:setCard.shading color:setCard.color];
  return setCardView;
}

@end
