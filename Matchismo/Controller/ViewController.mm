//
//  ViewController.mm - Ex4
//  Ex4
//
//  Created by Zahi Ajami on 24/07/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "ViewController.h"
#import "CardMatchingGame.h"

#import "SetCardView.h"
#import "SetCardDeck.h"
#import "PlayingCardView.h"
#import "Grid.h"


@interface ViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray<CardView *> *cardViews;
@property (strong, nonatomic) Grid *grid;
@property (nonatomic) BOOL isDeckPiled;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardsSuperView;
@property (weak, nonatomic) IBOutlet UIButton *add3CardButton;
@end


@implementation ViewController

- (CardMatchingGame *)game {
  if (!_game) {
    NSUInteger matchMode = [self getNumOfCardsInMatch];
    NSUInteger initialNumberOfCards = [self getInitialNumOfCards];
    _game = [[CardMatchingGame alloc] initWithCardCount:initialNumberOfCards
                                              usingDeck:[self createDeck]
                                              matchMode:matchMode];
  }
  return _game;
}

- (NSMutableArray<CardView *> *)cardViews {
  if (!_cardViews) {
    _cardViews = [[NSMutableArray alloc] init];
  }
  return _cardViews;
}

// abstract
- (Deck *)createDeck {
  return nil;
}

// abstract
- (NSUInteger)getNumOfCardsInMatch {
  assert(NO);
}

// abstract
- (NSUInteger)getInitialNumOfCards {
  assert(NO);
}

// abstract
- (CardView *)createCardViewFor:(Card *)card WithFrame:(CGRect)frame {
  return nil;
}

// abstract
- (void)flipCardView:(CardView *)cardView {
}


- (void)createCardViewForCard:(Card *)card {
  CardView *cardView = [self createCardViewFor:card WithFrame:CGRectZero];
  [self.cardsSuperView addSubview:cardView];
  [self.cardViews addObject:cardView];
  [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(tap:)]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.grid = [[Grid alloc] init];
  self.grid.cellAspectRatio = 2.0 / 3.0;
  
  for (Card *card in [self.game cardsInPlay]) {
    [self createCardViewForCard:card];
  }
  
  [self regridCardsOnScreen];
}

- (void)viewDidLayoutSubviews {
  if (!self.isDeckPiled) {
    [self regridCardsOnScreen];
  }
}

- (void)updateCardViewUI:(CardView *)cardView card:(Card *)card {
  if (card.isMatched) {
    [cardView handleMatchedCard];
    [cardView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      [cardView removeGestureRecognizer:obj];
    }];
    return;
  }
  
  if (!card.isChosen) {
    cardView.alpha = 1;
    if (cardView.faceUp) {
       [self flipCardView:cardView];
    } else {
      cardView.faceUp = NO;
    }
  } else if (card.isChosen && !card.isMatched) {
    cardView.alpha = 0.8;
    cardView.faceUp = YES;
  }
  [cardView setNeedsDisplay];
}

- (void)updateUI {
  for (UIView *subview in self.cardsSuperView.subviews) {
    assert([subview isKindOfClass:[CardView class]]);
    CardView *cardView = (CardView *)subview;
    NSUInteger cardIndex = [self.cardViews indexOfObject:cardView];
    Card *card = [self.game cardAtIndex:cardIndex];
    [self updateCardViewUI:cardView card:card];
  }
  [self regridCardsOnScreen];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)regridCardsOnScreen {
  self.grid.size = self.cardsSuperView.bounds.size;
  self.grid.minimumNumberOfCells = [self getNumOfCardsOnScreen];
  
  if ([self getNumOfCardsOnScreen] == 0) {
    return;
  }
  
  if (!self.grid.inputsAreValid) {
    NSLog(@"Grid cannot allocate the grid with these parameters");
    return; // exception ?
  }
  
  NSUInteger numOfCols = self.grid.columnCount;
  NSUInteger cardIndex = 0;
  
  for (CardView *cardView in self.cardViews) {
    NSUInteger cardViewIndex = [self.cardViews indexOfObject:cardView];
    Card *card = [self.game cardAtIndex:cardViewIndex];
    
    NSUInteger cardRow = cardIndex / numOfCols;
    NSUInteger cardColumn = cardIndex % numOfCols;
    CGRect frame = [self.grid frameOfCellAtRow:cardRow inColumn:cardColumn];
    
    if (card.isMatched && ![cardView shouldAllocateCellInGridForMatchedCard]) {
      continue;
    }
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      cardView.frame = frame;
    } completion:^(BOOL finished) { }];
    cardIndex++;
  }
}


- (NSUInteger)getNumOfCardsOnScreen {
  NSUInteger numOfCardsOnScreen = 0;
  for (Card *card in [self.game cardsInPlay]) {
    if (!card.isMatched) {
      numOfCardsOnScreen++;
    }
  }
  return numOfCardsOnScreen;
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
  if ([self getNumOfCardsOnScreen] == 0) {
    return;
  }
  if (!self.isDeckPiled) {
    CGPoint pinchPoint = [sender locationInView:self.cardsSuperView];
    [UIView animateWithDuration:1.0 animations:^{
      for (CardView *cardView in self.cardViews) {
        cardView.center = pinchPoint;
      }
    }];
    self.isDeckPiled = YES;
  }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
  
  if (self.isDeckPiled) {
    [self updateUI];
    self.isDeckPiled = NO;
    return;
  }
  
  if (![sender.view isKindOfClass:[CardView class]]) {
    return;
  }
  CardView *tappedCardView = (CardView *)sender.view;
  NSUInteger tappedCardIndex = [self.cardViews indexOfObject:tappedCardView];
  [self flipCardView:tappedCardView];
  [self.game chooseCardAtIndex:tappedCardIndex];
  [self updateUI];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
  if (!self.isDeckPiled) {
    return;
  }
  CGPoint translation = [sender translationInView:self.cardsSuperView];
  
  [UIView animateWithDuration:0.1 animations:^{
    for (CardView *cardView in self.cardViews) {
      cardView.center = CGPointMake(cardView.center.x + translation.x, cardView.center.y + translation.y);
    }
  }];
  
  [sender setTranslation:CGPointZero inView:self.cardsSuperView];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
  self.game = nil;
  [self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  self.cardViews = nil;
  
  for (Card *card in [self.game cardsInPlay]) {
    [self createCardViewForCard:card];
  }
  
  self.isDeckPiled = NO;
  [self.add3CardButton setTitle:@"Add 3 cards" forState:UIControlStateNormal];
  [self updateUI];
}

- (IBAction)touchAdd3CardsButton:(UIButton *)sender {
  NSUInteger numOfCardsToAdd = 3;
  Card* card = nil;
  for (int i=0; i < numOfCardsToAdd; i++) {
    card = [self.game drawAndAddRandomGameCard];
    if (card) {
      [self createCardViewForCard:card];
    } else {
      [self.add3CardButton setTitle:@"No more cards" forState:UIControlStateNormal];
    }
  }
  [self updateUI];
}

@end
