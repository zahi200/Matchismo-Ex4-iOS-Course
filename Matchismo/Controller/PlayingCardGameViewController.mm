// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Zahi Ajami.

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@implementation PlayingCardGameViewController

static const int kNumOfCardsInMatchPlayingCardGame = 2;
static const int kInitialNumOfCardsInPlayingCardGame = 30;

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)getNumOfCardsInMatch {
  return kNumOfCardsInMatchPlayingCardGame;
}

- (NSUInteger)getInitialNumOfCards {
  return kInitialNumOfCardsInPlayingCardGame;
}

- (CardView *)createCardViewFor:(Card *)card WithFrame:(CGRect)frame {
  PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:frame];
  [playingCardView setup];
  PlayingCard *playingCard = (PlayingCard *)card;
  [playingCardView setPlayingCardPropertiesWithSuit:playingCard.suit rank:playingCard.rank faceUp:NO];
  return playingCardView;
}

- (void)flipCardView:(CardView *)cardView {
  [UIView transitionWithView:cardView duration:0.5
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations:^{
                    cardView.faceUp = !cardView.faceUp;
                  } completion:^(BOOL finished) {}];
}

- (NSUInteger)getNumOfCardsOnScreen {
  return kInitialNumOfCardsInPlayingCardGame;
}

@end
