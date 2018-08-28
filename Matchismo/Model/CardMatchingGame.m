//
//  CardMatchingGame.m
//  Ex4
//
//  Created by Zahi Ajami on 29/07/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) Deck *deck;
@property (readwrite, nonatomic) NSInteger score;
@property (strong, nonatomic) NSMutableArray *chosenCards;
@property (strong, readwrite, nonatomic) NSArray *chosenCardsInLastMove;
@property (strong, readwrite, nonatomic) NSMutableArray<Card *> *cardsInPlay;
@end


@implementation CardMatchingGame

static const int kMismatchPenalty = 2;
static const int kMatchBonus = 4;
static const int kCostToChoose = 1;
static const int kDefaultMatchMode = 2;


- (NSMutableArray<Card *> *)cardsInPlay {
  if (!_cardsInPlay) {
    _cardsInPlay = [[NSMutableArray alloc] init];
  }
  return _cardsInPlay;
}

- (NSMutableArray *)chosenCards {
  if (!_chosenCards) {
    _chosenCards = [[NSMutableArray alloc] init];
  }
  return _chosenCards;
}

// TODO - not sure about this getter. Maybe should just delete this method
- (Deck *)deck {
  if (!_deck) {
    _deck = [[Deck alloc] init];
  }
  return _deck;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck {
  return [self initWithCardCount:count usingDeck:deck matchMode:kDefaultMatchMode];
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                        matchMode:(NSUInteger)mode {
  assert(mode==2 || mode==3);
  if (self = [super init]){
    for (int i=0; i<count; i++) {
      Card *card = [deck drawRandomCard];
      if (card) {
        [self.cardsInPlay addObject:card];
      } else {
        self = nil;
        break;
      }
    }
  }
  self.deck = deck;
  self.numOfCardsInMatch = mode;
  return self;
}

- (NSArray *)chosenCardsInLastMove {
  if (!_chosenCardsInLastMove) {
    _chosenCardsInLastMove = [[NSArray alloc] init];
  }
  return _chosenCardsInLastMove;
}


- (Card *)cardAtIndex:(NSUInteger) index {
  return (index < [self.cardsInPlay count]) ? self.cardsInPlay[index] : nil;
}

- (void)matchCards {
  int matchScore = 0;

  for (Card *card in self.chosenCards) {
    matchScore += [card match:self.chosenCards];
  }
  
  if (matchScore > 0) {
    for (Card *chosenCard in self.chosenCards) {
      chosenCard.isMatched = YES;
    }
    self.chosenCards = nil;
    matchScore = kMatchBonus * matchScore / 2;
    self.score += matchScore;
  } else {
    Card *firstChosenCard = [self.chosenCards firstObject];
    firstChosenCard.isChosen = NO;
    [self.chosenCards removeObject:firstChosenCard];
    self.score -= kMismatchPenalty;
  }
}

- (void)chooseCardAtIndex:(NSUInteger) index {
  Card *card = [self cardAtIndex:index];

  if (!card.isMatched) {
    if (card.isChosen) {
      card.isChosen = NO;
      [self.chosenCards removeObject:card];
      self.chosenCardsInLastMove = [self.chosenCards copy];
    } else {
      [self.chosenCards addObject:card];
      self.chosenCardsInLastMove = [self.chosenCards copy];
      assert([self.chosenCards count] <= self.numOfCardsInMatch);
    
      if ([self.chosenCards count] == self.numOfCardsInMatch) {
        [self matchCards];
      }
    
      self.score -= kCostToChoose;
      card.isChosen = YES;
    }
  }
}

- (Card *)drawAndAddRandomGameCard {
  Card *newCard = [self.deck drawRandomCard];
  if (newCard) {
    [self.cardsInPlay addObject:newCard];
  }
  return newCard;
}

@end
