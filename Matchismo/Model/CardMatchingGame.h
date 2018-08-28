//  Created by Zahi Ajami on 29/07/2018.
//  Copyright © 2018 Lightricks. All rights reserved.

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

/// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                        matchMode:(NSUInteger)mode;

- (void)chooseCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

/// returns a random card from the deck that was not already dealt, and add it to the cards that are currently in play
- (Card *)drawAndAddRandomGameCard;

@property (readonly, nonatomic) NSInteger score;
@property (nonatomic) NSUInteger numOfCardsInMatch; // 2 or 3 in our case
/// all the cards that were chosen in the last move
@property (strong, readonly, nonatomic) NSArray *chosenCardsInLastMove;
/// the cards currently in play - not including already matched ones
@property (strong, readonly, nonatomic) NSMutableArray<Card *> *cardsInPlay;

@end
