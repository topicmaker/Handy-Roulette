//
//  RouletterViewController.h
//  Rouletter
//
//  Created by t-suzuki on 10/06/28.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>

#import "NumberCard.h"
#import "EditCardNumber.h"
#import "MyUIScrollView.h"

#define kMyWhiteColor			[UIColor whiteColor]
#define kMyBlackColor			[UIColor colorWithRed:0.14f green:0.14f blue:0.14f alpha:1.00f]

#define kInfoLinkUrl			@"http://www.topicmaker.com/smartphone/handyroulette/"
#define kMaxPageSize			116	// max:119

#define kDataFileName			@"data.plist"
#define kDataKeyName			@"rouletteStyle"
#define kDataBgmKeyName			@"bgmStyle"

#define kRouletteFlickMaxLevel	30		// ルーレットフリックの最高レベル。　最低は 1

#ifdef DEBUG
#else
#  define NSLog(...) ;
#endif


@interface RouletterViewController : UIViewController <UIScrollViewDelegate, AVAudioPlayerDelegate> {
	NSMutableArray * rouletteNumber;
	NSMutableArray * rouletteColor;
	MyUIScrollView * scrollViewBase;
	UIBarButtonItem * editButton;
	UIBarButtonItem * infoButton;
	
	NSUInteger currentPage, roundPage, lastCurrentPage;
	NSInteger cardMinValue, cardMaxValue;
	NSUInteger currentRouletteIndex;
	NSUInteger randomRouletteIndex;
	
	NSUInteger startStyleValue;
	AVAudioPlayer * bgmGuruguruPlayer;
	AVAudioPlayer * bgmKotonPlayer;
	SystemSoundID mSoundKachi;
	
	NSTimer * repeatingTimer;
	NSUInteger timerCounter;
	NSUInteger scrollingX;		// アニメーションするスクロール距離
	
	CGPoint flickStartLocation, tapBeforeLocation;
	NSDate * tapBeforeDate;
	CGFloat tapDistanceValue, tapSpeed;
	NSUInteger rouletteFlickLevel, isRouletteSliding, isRouletteRolling, isRouletteFlicking;
	
	UIActivityIndicatorView * indicator;
	UIImageView * tapmeImageView, * flickmeImageView;
}

@property (nonatomic, retain) NSMutableArray * rouletteNumber;
@property (nonatomic, retain) NSMutableArray * rouletteColor;
@property (nonatomic, retain) MyUIScrollView * scrollViewBase;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * editButton;
@property (nonatomic, retain) UIBarButtonItem * infoButton;

@property (nonatomic) NSUInteger currentPage, roundPage, lastCurrentPage;
@property (nonatomic) NSUInteger currentRouletteIndex;
@property (nonatomic) NSUInteger randomRouletteIndex;

@property (nonatomic) NSUInteger startStyleValue;
@property (retain) AVAudioPlayer * bgmGuruguruPlayer, * bgmKotonPlayer;
@property (readonly) SystemSoundID mSoundKachi;
@property (nonatomic, assign) NSTimer * repeatingTimer;
@property (nonatomic) NSUInteger timerCounter;
@property (nonatomic) NSUInteger scrollingX;

@property (nonatomic) CGPoint flickStartLocation, tapBeforeLocation;
@property (nonatomic, retain) NSDate * tapBeforeDate;
@property (nonatomic) CGFloat tapDistanceValue, tapSpeed;
@property (nonatomic) NSUInteger rouletteFlickLevel, isRouletteSliding, isRouletteRolling, isRouletteFlicking;

@property (nonatomic, retain) UIActivityIndicatorView * indicator;
@property (nonatomic, retain) UIImageView * tapmeImageView, * flickmeImageView;

- (IBAction) editCardNumber;
- (IBAction) infoLinkAction;

@end

