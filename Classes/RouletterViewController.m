//
//  RouletterViewController.m
//  Rouletter
//
//  Created by t-suzuki on 10/06/28.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RouletterViewController.h"


@implementation RouletterViewController

@synthesize rouletteNumber;
@synthesize rouletteColor;
@synthesize scrollViewBase;
@synthesize editButton, infoButton;

@synthesize currentPage, roundPage, lastCurrentPage;
@synthesize currentRouletteIndex;
@synthesize randomRouletteIndex;

@synthesize startStyleValue;
@synthesize bgmGuruguruPlayer, bgmKotonPlayer;
@synthesize mSoundKachi;

@synthesize repeatingTimer;
@synthesize timerCounter;
@synthesize scrollingX;

@synthesize flickStartLocation, tapBeforeLocation;
@synthesize tapBeforeDate;
@synthesize tapDistanceValue, tapSpeed;
@synthesize rouletteFlickLevel, isRouletteSliding, isRouletteRolling, isRouletteFlicking;

@synthesize indicator, tapmeImageView, flickmeImageView;

#pragma mark -
- (NSString *)dataFilePath {
//	NSLog(@"dataFilePath");
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:kDataFileName];
//	[paths release];
//	[documentsDirectory autorelease];
//	[filePath autorelease];
	NSLog(@"dataFilePath : filePath : %@",filePath);
	return filePath;
}

// カード部分のframeを返す
- (CGSize) getFrameSizeOfCard {
	return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 44);	// 44 = toolbar.height
}
// 画面全部のframeを返す
- (CGSize) getFrameSizeRaw {
	return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}


- (NSUInteger) getRandomRouletteIndex {
	srand(time(nil));	// rand 初期化
	NSUInteger rj = rand() % [rouletteNumber count];
//∫	NSLog(@"getRandomRouletteIndex - count : %d",[rouletteNumber count]);
	NSLog(@"getRandomRouletteIndex - rand : %d",rj);
	return rj;		// max 37
}

- (void) readDataFile {
	NSLog(@"readDataFile");

	NSInteger	rouletteStyleValue	= 0;
	NSUInteger	startStyleValueTemp	= 0;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
		NSMutableDictionary * dataPlist = [[NSMutableDictionary alloc]
										   initWithContentsOfFile:[self dataFilePath]];
		
		rouletteStyleValue	= [[dataPlist objectForKey:kDataKeyName] intValue];
		startStyleValueTemp	= [[dataPlist objectForKey:kDataBgmKeyName] intValue];
	
		[dataPlist release];
	}

	// roulette Style	
	NSDictionary * rouletterDataPlist = [NSDictionary dictionaryWithContentsOfFile:[
															[NSBundle mainBundle]
															pathForResource:@"RouletterData"
															ofType:@"plist"]];
	
	
	rouletteNumber	= nil;
	rouletteColor	= nil;
	NSLog(@"readDataFile - rouletteStyleValue : %d",rouletteStyleValue);
	if (rouletteStyleValue == 1) {
		// European
		rouletteNumber	= [[NSMutableArray alloc] initWithArray:[rouletterDataPlist objectForKey:@"pRouletteNumberEuropean"]];
		rouletteColor	= [[NSMutableArray alloc] initWithArray:[rouletterDataPlist objectForKey:@"pRouletteColorEuropean"]];
	}
	else {
		// American
		rouletteNumber	= [[NSMutableArray alloc] initWithArray:[rouletterDataPlist objectForKey:@"pRouletteNumberAmerican"]];
		rouletteColor	= [[NSMutableArray alloc] initWithArray:[rouletterDataPlist objectForKey:@"pRouletteColorAmerican"]];
	}
	rouletterDataPlist = nil;
	[rouletterDataPlist release];
	
	currentRouletteIndex = self.getRandomRouletteIndex;
	startStyleValue = startStyleValueTemp;
	NSLog(@"readDataFile - startStyleValueTemp : %d",startStyleValueTemp);

	
	// bgm Setting
	NSString		* soundFilePath	= nil;
	NSURL			* fileURL		= nil;
	AVAudioPlayer	* newPlayer		= nil;
	
	if (self.startStyleValue == 0) {	
		if (self.bgmGuruguruPlayer == nil) {
			NSLog(@"readDataFile - guruguru setting.");
		
			// load - guruguru
			soundFilePath	= [[NSBundle mainBundle] pathForResource: @"guruguru2" ofType: @"wav"];
			fileURL			= [[NSURL alloc] initFileURLWithPath: soundFilePath];
			newPlayer		= [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
			self.bgmGuruguruPlayer = newPlayer;
			[self.bgmGuruguruPlayer prepareToPlay];
			[self.bgmGuruguruPlayer setDelegate: self];
	
			// load - koton
			soundFilePath	= [[NSBundle mainBundle] pathForResource: @"koton49" ofType: @"wav"];
			fileURL			= [[NSURL alloc] initFileURLWithPath: soundFilePath];
			newPlayer		= [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
			self.bgmKotonPlayer = newPlayer;
			[self.bgmKotonPlayer prepareToPlay];
			[self.bgmKotonPlayer setDelegate: self];
		}
	}
	
	if (self.startStyleValue == 1) {
		if (! self.mSoundKachi) {
			NSLog(@"readDataFile - kachi setting.");

			// load - kachi		
			NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"kachi" ofType:@"wav"];
			CFURLRef soundURL = (CFURLRef)[NSURL fileURLWithPath:soundPath];
			AudioServicesCreateSystemSoundID (soundURL, &mSoundKachi);
			CFRelease(soundURL);  
		}
	}
	
	[soundFilePath release];
	[fileURL release];
	[newPlayer release];
}

- (void) messageByPleaseWait {
	[indicator startAnimating];
}

- (void) displayToActive {
	NSLog(@"%@", NSStringFromSelector(_cmd));

	// refleshRoulet timer stop
	[self.repeatingTimer invalidate];
	self.repeatingTimer = nil;
	
	// starting image
	if (startStyleValue == 0) {
		tapmeImageView.hidden = NO;
	}
	else {
		flickmeImageView.hidden = NO;
	}
	
	editButton.enabled	= YES;
	infoButton.enabled	= YES;
	scrollViewBase.delaysContentTouches	= NO;
	
	isRouletteRolling	= 0;
	
	[indicator stopAnimating];
}

- (void) displayToNotActive {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	tapmeImageView.hidden	= YES;
	flickmeImageView.hidden	= YES;
	
	scrollViewBase.delaysContentTouches	= YES;
	editButton.enabled	= NO;
	infoButton.enabled	= NO;
}


- (void) refleshRoulet {
	NSLog(@"refleshRoulet");
	
	if (scrollViewBase != nil) {
		for (UIView * nc in [scrollViewBase subviews]) {
			[nc removeFromSuperview];
			nc = nil;
			[nc release];
		}
	}
	
	// setNumberCard
	CGSize frameSize	= self.getFrameSizeOfCard;
	CGRect frameOne		= {{0,0}, frameSize};
	NSUInteger setRouletteIndex = currentRouletteIndex;
	for (NSInteger i = 0; i <= kMaxPageSize; i++) {	
		
		//UIView
		frameOne.origin.x = frameOne.size.width * i;
		NumberCard * numberCard		= [[NumberCard alloc] initWithNibName:@"NumberCard" bundle:nil];
		numberCard.numberLabelValue = [NSString stringWithFormat:@"%@",[rouletteNumber objectAtIndex:setRouletteIndex]];
		numberCard.colorValue		= [rouletteColor objectAtIndex:setRouletteIndex];			
///		numberCard.myOrderValue		= [[NSString alloc] initWithFormat:@"%d",i];
		numberCard.view.frame		= frameOne;			// viewDidLoad 走る
		[scrollViewBase addSubview:numberCard.view];
		[numberCard release];
		
		setRouletteIndex++;
		if ( setRouletteIndex > ([self.rouletteNumber count] - 1) ) {
			setRouletteIndex = 0;
		}
	}
	
	// UI reflesh
	[scrollViewBase setContentOffset:CGPointMake(0, 0) animated:NO];
	
	
	// refleshRoulet処理中のタップを無効化する対応策：Timerでsleepして遅延しているタップを逃す
	// refleshRoulet timer start
	NSTimer * timer = [NSTimer timerWithTimeInterval:1.2
											  target:self
											selector:@selector(displayToActive)
											userInfo:nil 
											 repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	self.repeatingTimer = timer;

	
	NSLog(@"refleshRoulet - END");
}

/*
- (void) didEndDecelerating {
	NSLog(@"didEndDecelerating");
	
	currentRouletteIndex = (currentRouletteIndex + roundPage) % [rouletteNumber count];
	
	CGSize frameSize = self.getFrameSizeOfCard;
	[self.scrollViewBase setContentOffset:CGPointMake(frameSize.width * roundPage, 0) animated:YES];
}
*/

#pragma mark -
#pragma mark TimerAction
- (void) timerActionStart {
	NSLog(@"timerActionStart");
	
	randomRouletteIndex = self.getRandomRouletteIndex;
	NSTimer * timer = [NSTimer timerWithTimeInterval:0.01		// 最小値 0.01
											  target:self
											selector:@selector(timerFireMethod:)
											userInfo:nil 
											 repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	self.repeatingTimer = timer;
	
	// bgm Guruguru
	if (self.startStyleValue == 0) {
		self.bgmGuruguruPlayer.currentTime	= 0.18f;
		self.bgmGuruguruPlayer.volume		= 0.6f;
		[self.bgmGuruguruPlayer play];
	}
}

- (void) timerActionStop {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	if (! [repeatingTimer isValid]) {
		NSLog(@"timerActionStop - not isValid");
		return;
	}
	
	[self.repeatingTimer invalidate];
	self.repeatingTimer = nil;
	timerCounter = 0;
	
	currentRouletteIndex = (currentRouletteIndex + roundPage) % [rouletteNumber count];

	// 画面ぴったりに止まると setContentOffset の animated:YES が効かないため強制的に位置をずらす
	// → ルーレットストップ時に 必ず scrollViewDidEndScrollingAnimation を発生させる
	CGSize frameSize = self.getFrameSizeOfCard;
	if ( ((NSInteger)scrollViewBase.contentOffset.x % (NSInteger)frameSize.width) <= 0 ) {
		[self.scrollViewBase setContentOffset:CGPointMake(frameSize.width * roundPage + 1, 0) animated:NO];
	}

	[self.scrollViewBase setContentOffset:CGPointMake(frameSize.width * roundPage, 0) animated:YES];
	
	[self messageByPleaseWait];
}

- (void)timerFireMethod:(NSTimer*)theTimer {
//	NSLog(@"timerAction - %d", timerCounter);
	
	timerCounter++;
//	NSLog(@"timerCounter : %d",timerCounter);
	
	NSUInteger baseScrollFrequency	= 0;		// 基本スクロール回数
	scrollingX						= 63;		// スクロール距離（初動のスクロール距離） max:63
	CGFloat speedDownRatio			= 0.077;	// 減速率 max:0.077	min:0.178
	
	NSUInteger randomRouletteFrequency	= self.randomRouletteIndex * (self.getFrameSizeOfCard.width / scrollingX);	// 乱数分のスクロール回数
	NSUInteger firstScrollFrequency		= baseScrollFrequency + randomRouletteFrequency;	// 初動スクロール回数
//	NSLog(@"firstScrollFrequency : %d",firstScrollFrequency);
	
	
	// フリックレベル計算
	scrollingX				= scrollingX * rouletteFlickLevel / kRouletteFlickMaxLevel;
	speedDownRatio			= speedDownRatio + (0.03 - 0.03 * rouletteFlickLevel / kRouletteFlickMaxLevel);
	firstScrollFrequency	= firstScrollFrequency * rouletteFlickLevel / kRouletteFlickMaxLevel;
//	NSLog(@"Max     ::  scrollingX:%d, speedDownRatio:%f, firstScrollFrequency:%d",scrollingX, speedDownRatio, firstScrollFrequency);
	
	if (timerCounter > firstScrollFrequency ) {
		scrollingX = scrollingX - (timerCounter - firstScrollFrequency) * speedDownRatio;
	}
//	NSLog(@"scrollingX : %d",scrollingX);

	
	[self.scrollViewBase setContentOffset:CGPointMake(scrollViewBase.contentOffset.x + scrollingX, 0) animated:NO];
}


#pragma mark -
#pragma mark IBAction


- (IBAction) editCardNumber {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self displayToNotActive];
	[self messageByPleaseWait];
	
	EditCardNumber * modalView = [[EditCardNumber alloc] initWithNibName:@"EditCardNumber" bundle:nil];
	[self presentModalViewController:modalView animated:YES];
	[modalView release];
	
	NSLog(@"%@ --- end", NSStringFromSelector(_cmd));
}

- (IBAction) infoLinkAction {
	NSLog(@"infoLinkAction");
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kInfoLinkUrl]];
}


#pragma mark -
#pragma mark Default

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	// scrollViewBase
	CGSize frameSize = self.getFrameSizeOfCard;
	MyUIScrollView * defaultScrollView = [[MyUIScrollView alloc]
										initWithFrame:CGRectMake(0, 0, frameSize.width, frameSize.height)];
	defaultScrollView.pagingEnabled	= NO;
	defaultScrollView.contentSize	= CGSizeMake(frameSize.width * kMaxPageSize, frameSize.height);
	defaultScrollView.showsHorizontalScrollIndicator	= NO;
	defaultScrollView.showsVerticalScrollIndicator		= NO;
	defaultScrollView.bounces							= NO;
	defaultScrollView.scrollEnabled						= NO;
	defaultScrollView.delaysContentTouches				= NO;	// touchesBegan発生させるため
    defaultScrollView.delegate							= self;
	self.scrollViewBase = defaultScrollView;
	
	[self.view addSubview:defaultScrollView];
	[defaultScrollView release];

	
	// info ボタン
	UIButton * iButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[iButton addTarget:self action:@selector(infoLinkAction)
	  forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * infoBarButton	= [[UIBarButtonItem alloc] initWithCustomView:iButton];
	UIToolbar * toolBar				= [[self.view subviews] objectAtIndex:0];
	NSMutableArray * toolBarItems	= [[NSMutableArray alloc] initWithArray:[toolBar items]];
	[toolBarItems addObject:infoBarButton];
	[toolBar setItems:toolBarItems];
	self.infoButton = infoBarButton;
	
	[iButton release];
	[infoBarButton release];
	[toolBar release];
	[toolBarItems release];
	
	
	// indicator
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicator setFrame:CGRectMake ((frameSize.width/2)-13, (frameSize.height + 11), 26, 26)];
	[self.view addSubview:indicator];

	
	// starting imageView
	NSString * stPath		= [[NSBundle mainBundle] pathForResource:@"st_tapme" ofType:@"png"];
	tapmeImageView			= [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:stPath]];
	stPath					= [[NSBundle mainBundle] pathForResource:@"st_flickme" ofType:@"png"];
	flickmeImageView		= [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:stPath]];
	[stPath release];
	
	NSArray * stStartingViews = [NSArray arrayWithObjects: tapmeImageView, flickmeImageView, nil];
	for (UIImageView * stView in stStartingViews) {
		stView.hidden	= YES;
		stView.center	= CGPointMake((frameSize.width/2), (frameSize.height - 50));
		[self.view addSubview:stView];
	}
	stStartingViews = nil;
	[stStartingViews autorelease];
	
	
	// 画面制御
	self.view.subviews;			// 無いと落ちる
	[self displayToNotActive];
	[self messageByPleaseWait];

//	NSLog(@"subviews : %@",[self.view.subviews description]);
	
	[super viewDidLoad];
}




- (void) viewDidAppear:(BOOL)animated {
	NSLog(@"viewDidAppear");
	[self readDataFile];
	[self refleshRoulet];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;

	self.rouletteNumber = nil;
	self.rouletteColor = nil;
	self.scrollViewBase = nil;
	self.editButton = nil;
	self.infoButton = nil;
	
	self.bgmGuruguruPlayer = nil;
	self.bgmKotonPlayer = nil;
	self.repeatingTimer = nil;
	
	self.tapBeforeDate = nil;
	
	self.indicator = nil;
	self.tapmeImageView = nil;
	self.flickmeImageView = nil;
}


- (void)dealloc {
	[rouletteNumber release];
	[rouletteColor release];
	[scrollViewBase release];
	[editButton release];
	[infoButton release];
	
	[bgmGuruguruPlayer release];
	[bgmKotonPlayer release];
	AudioServicesDisposeSystemSoundID(mSoundKachi);
	[repeatingTimer release];
	
	[tapBeforeDate release];
	
	[indicator release];
	[tapmeImageView release];
	[flickmeImageView release];
	
	[super dealloc];
}



#pragma mark -
#pragma mark MyUIScrollView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isRouletteRolling) return;
	
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	
	CGSize frameSize = [self getFrameSizeRaw];
	if (location.y > frameSize.height) return;
	NSLog(@"this > %@  %@",NSStringFromSelector(_cmd), NSStringFromCGPoint(location));

	
	// tapBefore（初期化）
	tapBeforeLocation	= location;
	tapBeforeDate		= [[NSDate date] retain];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isRouletteRolling) return;
	
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];

	CGSize frameSize = [self getFrameSizeRaw];
	if (location.y > frameSize.height) return;
	NSLog(@"this >> %@  %@",NSStringFromSelector(_cmd), NSStringFromCGPoint(location));
	
	
	// 距離、時間、速度　を計算
	tapDistanceValue = tapBeforeLocation.x - location.x;
	NSLog(@"tapDistanceValue : %f",tapDistanceValue);
	NSTimeInterval tapInterval = [tapBeforeDate timeIntervalSinceNow];
	NSLog(@"tapInterval : %.20f",tapInterval);
	tapSpeed = fabs(tapDistanceValue / tapInterval);
	NSLog(@"tapSpeed : %f",tapSpeed);

	
	// flickStartLocation を取得（フリックスピード定義）
	if (tapSpeed > 100) {
		if (! isRouletteFlicking) {
			isRouletteFlicking	= 1;
			flickStartLocation	= tapBeforeLocation;
		}
	}
	else {
		isRouletteFlicking	= 0;
	}
	NSLog(@"isRouletteFlicking : %d",isRouletteFlicking);
	
	// flick
	if (startStyleValue == 1) {
		// 指に合わせてスライド start & move
		if (location.x < tapBeforeLocation.x ) {
			isRouletteSliding = 1;
			[self displayToNotActive];
		}
		if (isRouletteSliding) {
			CGFloat willContentsOffsetValue = self.scrollViewBase.contentOffset.x + tapDistanceValue;
			if (willContentsOffsetValue >= 0) {
				[self.scrollViewBase setContentOffset:CGPointMake(willContentsOffsetValue, 0) animated:NO];
			}
		}
	}
	
	// tapBefore
	tapBeforeLocation	= location;
	tapBeforeDate		= [[NSDate date] retain];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (isRouletteRolling) return;
	
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	NSLog(@"this >>> %@  %@",NSStringFromSelector(_cmd), NSStringFromCGPoint(location));
	
	// flick
	if ((startStyleValue == 1) && isRouletteSliding) {
		CGFloat endedFlickDistanceX = flickStartLocation.x - location.x;	// フリックした距離
		CGFloat endedFlickDistanceY = flickStartLocation.y - location.y;
		NSLog(@"endedFlickDistanceX:%f, endedFlickDistanceY:%f", endedFlickDistanceX, endedFlickDistanceY);

		
		//= フリック具合判定（なぞった距離と速度で判定）
		// 距離
		NSUInteger	endedFlickDistanceLevel		= kRouletteFlickMaxLevel;
///		CGFloat		endedFlickDistanceValue		= endedFlickDistanceX - fabs(endedFlickDistanceY) / 2;
		CGFloat		endedFlickDistanceValue		= endedFlickDistanceX;
		NSUInteger	endedFlickDistanceMaxValue	= 220;	// これ以上のフリックでkRouletteFlickMaxLevelになる
		for ( NSUInteger i = 1; i <= kRouletteFlickMaxLevel; i++) {
			if (endedFlickDistanceValue < ( endedFlickDistanceMaxValue / kRouletteFlickMaxLevel * i)) {
				endedFlickDistanceLevel = i;
				break;
			}
		}
		NSLog(@" endedFlickDistanceLevel : %d",endedFlickDistanceLevel);
		
		// 速度
		NSLog(@"%@  tapSpeed : %f", NSStringFromSelector(_cmd), tapSpeed);
		NSUInteger	endedTapSpeedLevel	= kRouletteFlickMaxLevel;
		CGFloat		endedTapSpeedMax	= 6600;		// これ以上の速度でkRouletteFlickMaxLevelになる
		for ( NSUInteger i = 1; i <= kRouletteFlickMaxLevel; i++) {
			if (tapSpeed < ( endedTapSpeedMax / kRouletteFlickMaxLevel * i)) {
				endedTapSpeedLevel = i;
				break;
			}
		}
		NSLog(@" endedTapSpeedLevel : %d",endedTapSpeedLevel);

		// 逆フリックは無効
		if (endedFlickDistanceX < 0) {
			endedFlickDistanceLevel		= 1;
			endedTapSpeedLevel			= 1;
			NSLog(@"reverse flick!");
		}
		
		// フリックレベルを計算（重み 距離：速度＝１：４）
		rouletteFlickLevel = round( (double)(endedFlickDistanceLevel + endedTapSpeedLevel*4) / 5 );
		NSLog(@" rouletteFlickLevel : %d",rouletteFlickLevel);
		
		// flick start
		if (isRouletteSliding) {
			isRouletteRolling = 1;
			[self timerActionStart];
		}
	}
	
	
	// tap
	CGSize frameSize = [self getFrameSizeRaw];
	if (startStyleValue == 0) {
		if (editButton.enabled && location.y < frameSize.height) {
			rouletteFlickLevel	= kRouletteFlickMaxLevel;
			isRouletteRolling	= 1;
			[self displayToNotActive];
			[self timerActionStart];
		}
	}

	isRouletteSliding	= 0;
	isRouletteFlicking	= 0;
 }

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	NSLog(@"this > %@  %@",NSStringFromSelector(_cmd), NSStringFromCGPoint(location));
}



#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//	NSLog(@"scrollViewDidScroll - x : %f", scrollView.contentOffset.x);
	
	// page
	double pageValue = scrollView.contentOffset.x / scrollView.frame.size.width;

	roundPage		= round(pageValue);
	currentPage		= floor(pageValue); // from 0 ~
//	NSLog(@"scrollViewDidScroll - roundPage	: %d",roundPage);
//	NSLog(@"scrollViewDidScroll - currentPage : %d",currentPage);
	
//	NSLog(@"scrollViewDidScroll - scrollingX : %d",scrollingX);
	
	if (lastCurrentPage != currentPage) {
		lastCurrentPage = currentPage;

		// kachi
		if ((self.startStyleValue == 1) && (lastCurrentPage != 0)) {
			AudioServicesPlaySystemSound(mSoundKachi);	
		}
		
		if (scrollingX <= 5) {
//			NSLog(@"scrollViewDidScroll - roundPage	: %d",roundPage);
			[self timerActionStop];
		}
	}

	if ( [repeatingTimer isValid] && (scrollingX <= 2)) {
		NSLog(@"scrollViewDidScroll - Safe Stop - roundPage : %d",roundPage);
		[self timerActionStop];
	}

}

/*
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	NSLog(@"scrollViewWillBeginDragging");
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	NSLog(@"scrollViewDidEndDragging ... decelerate : %d",decelerate);
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	NSLog(@"scrollViewWillBeginDecelerating");
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSLog(@"scrollViewDidEndDecelerating - roundPage:%d",roundPage);
}
*/

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	NSLog(@"scrollViewDidEndScrollingAnimation - roundPage:%d",roundPage);
 
	if (self.startStyleValue == 0) {
		// bgm Koton
		self.bgmKotonPlayer.currentTime = 0.0f;
		self.bgmKotonPlayer.volume		= 1.0f;
		[self.bgmKotonPlayer play];
		[self.bgmGuruguruPlayer stop];
	}
	else if (self.startStyleValue == 1) {
		// kachi
		AudioServicesPlaySystemSound(mSoundKachi);	
	}
	
 	[self refleshRoulet];
}



#pragma mark -
#pragma mark AVAudioPlayerDelegate
//サウンドファイルの再生が終了した時に呼び出される
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

//サウンドファイルの再生中に電話等の割り込みが発生した場合に呼出されるメソッド
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}
//上の割り込みが終了した時に呼出される
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}



@end
