//
//  ViewController.h
//  Ex4
//
//  Created by Zahi Ajami on 24/07/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//
// Abstract class.

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "Deck.h"

@interface ViewController : UIViewController

/// abstract
- (Deck *)createDeck;

/// abstract - get the number of cards to match in the game
- (NSUInteger)getNumOfCardsInMatch;

/// abstract - get the number of cards to start this game with
- (NSUInteger)getInitialNumOfCards;

/// abstract
- (CardView *)createCardViewFor:(Card *)card WithFrame:(CGRect)frame;

/// updates the relevant UI to \c card represented by the view \c cardView
- (void)updateCardViewUI:(CardView *)cardView card:(Card *)card;

/// abstract - handling the action of flipping a card \c cardView in the game
- (void)flipCardView:(CardView *)cardView;

/// returns the number of cards that appears on the screen at this moment
- (NSUInteger)getNumOfCardsOnScreen;

@end
