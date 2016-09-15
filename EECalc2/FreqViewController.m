//
//  FreqViewController.m
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/05/09.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import "FreqViewController.h"
#import "CalcButton.h"

#define TABBAR_HEIGHT	(49)
#define HEADER_HEIGHT	(20)

#define SEG_FREQ		(0)
#define SEG_PREODIC		(1)

@interface FreqViewController ()	

@end

@implementation FreqViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
		self.title = @"Freq";
		self.tabBarItem.image = [UIImage imageNamed:@"freq.png"];
		
		// init member variable
		m_imputValue = 0;
		
		// get localized string
		LSTR_ALERT_TITLE	= NSLocalizedString(@"AlertTitle_Info",	@"Alert title");
		LSTR_ALERT_MESSAGE	= NSLocalizedString(@"AlertMessage_OverLimitOfDec", @"Alert massegae for over limit");
		
		// init display parts
		[self initFirstDisplay];
		[self updateDisplay];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

// *****************************************************************
//	@brief	Initialization for all view.
//	@note
//		Nothing
// *****************************************************************
- (void) initFirstDisplay
{
	self.view.backgroundColor = [UIColor darkGrayColor];
	
	CGRect	rectMainFrame = self.view.frame;
	rectMainFrame.origin.y = HEADER_HEIGHT;
	rectMainFrame.size.height -= (TABBAR_HEIGHT + rectMainFrame.origin.y);
	
	const CGFloat ROW_PITCH = rectMainFrame.size.width / 30;
	const CGFloat LINE_PITCH = rectMainFrame.size.height / 80;

	const CGFloat SEG_WIDTH = ROW_PITCH * 28;
	const CGFloat SEG_HIGHT = LINE_PITCH * 10;
	
	NSArray *segArray = [NSArray arrayWithObjects:@"Hz to msec", @"msec to Hz", nil];
	m_selectSegment = [[UISegmentedControl alloc] initWithItems:segArray];
	CGRect	rectSelectSegment = rectMainFrame;
	rectSelectSegment.origin.x += ROW_PITCH * 1;
	rectSelectSegment.origin.y += LINE_PITCH * 2;
	rectSelectSegment.size.width = SEG_WIDTH;
	rectSelectSegment.size.height = SEG_HIGHT;
	m_selectSegment.frame = rectSelectSegment;
	m_selectSegment.segmentedControlStyle = UISegmentedControlStylePlain;
	m_selectSegment.selectedSegmentIndex = 0;
	[m_selectSegment addTarget:self action:@selector(actSelect:) forControlEvents:UIControlEventValueChanged];
	[m_selectSegment setTitleTextAttributes:
											[ NSDictionary dictionaryWithObject:[ UIFont boldSystemFontOfSize:(m_selectSegment.frame.size.height / 3) ]
											forKey:UITextAttributeFont ]
											forState:UIControlStateNormal];
	[self.view addSubview:m_selectSegment];

	
	const CGFloat LABEL_WIDTH = ROW_PITCH * 28;
	const CGFloat LABEL_HIGHT = LINE_PITCH * 11;
	
	CGRect	rectFreqLabel = rectMainFrame;
	rectFreqLabel.origin.x += ROW_PITCH * 1;
	rectFreqLabel.origin.y += LINE_PITCH * 13;
	rectFreqLabel.size.width = LABEL_WIDTH;
	rectFreqLabel.size.height = LABEL_HIGHT;
	m_freqLabel = [[DisplayView alloc] initWithFrame:rectFreqLabel];
	[m_freqLabel setEmphasis:TRUE];
	[m_freqLabel setDisplayMode:DISPMODE_FREQ];
	[self.view addSubview:m_freqLabel];
	
	CGRect	rectPeriodicLabel = rectMainFrame;
	rectPeriodicLabel.origin.x += ROW_PITCH * 1;
	rectPeriodicLabel.origin.y += LINE_PITCH * 24;
	rectPeriodicLabel.size.width = LABEL_WIDTH;
	rectPeriodicLabel.size.height = LABEL_HIGHT;
	m_periodicLabel = [[DisplayView alloc] initWithFrame:rectPeriodicLabel];
	[m_periodicLabel setEmphasis:FALSE];
	[m_periodicLabel setDisplayMode:DISPMODE_PERIODIC];
	[self.view addSubview:m_periodicLabel];

	
	// *** Create buttons ***
	const CGFloat BUTTON_WIDTH = ROW_PITCH * 6;
	const CGFloat BUTTON_HIGHT = LINE_PITCH * 12;
	const CGFloat BUTTON_ROW_OFFSET = ROW_PITCH * 0.5;
	
	const CGFloat BUTTON_LINE1_POS = LINE_PITCH * 37;
	const CGFloat BUTTON_LINE2_POS = LINE_PITCH * 51;
	const CGFloat BUTTON_LINE3_POS = LINE_PITCH * 65;
	
	// line 1
	CGRect	rectClearButton = rectMainFrame;
	rectClearButton.origin.x += (ROW_PITCH * 1) + BUTTON_ROW_OFFSET;
	rectClearButton.origin.y += BUTTON_LINE1_POS;
	rectClearButton.size.width = BUTTON_WIDTH;
	rectClearButton.size.height = BUTTON_HIGHT;
	CalcButton* clearButton = [[CalcButton alloc] initWithFrame:rectClearButton];
	[clearButton setTitle:@"C" forState:UIControlStateNormal];
	clearButton.redButton = TRUE;
	[clearButton addTarget:self action:@selector(actPush_clear:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:clearButton];
	
	CGRect	rectSevenButton = rectMainFrame;
	rectSevenButton.origin.x += (ROW_PITCH * 8) + BUTTON_ROW_OFFSET;
	rectSevenButton.origin.y += BUTTON_LINE1_POS;
	rectSevenButton.size.width = BUTTON_WIDTH;
	rectSevenButton.size.height = BUTTON_HIGHT;
	CalcButton* sevenButton = [[CalcButton alloc] initWithFrame:rectSevenButton];
	[sevenButton setTitle:@"7" forState:UIControlStateNormal];
	[sevenButton addTarget:self action:@selector(actPush_7:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:sevenButton];
	
	CGRect	rectEightButton = rectMainFrame;
	rectEightButton.origin.x += (ROW_PITCH * 15) + BUTTON_ROW_OFFSET;
	rectEightButton.origin.y += BUTTON_LINE1_POS;
	rectEightButton.size.width = BUTTON_WIDTH;
	rectEightButton.size.height = BUTTON_HIGHT;
	CalcButton* eightButton = [[CalcButton alloc] initWithFrame:rectEightButton];
	[eightButton setTitle:@"8" forState:UIControlStateNormal];
	[eightButton addTarget:self action:@selector(actPush_8:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:eightButton];
	
	CGRect	rectNineButton = rectMainFrame;
	rectNineButton.origin.x += (ROW_PITCH * 22) + BUTTON_ROW_OFFSET;
	rectNineButton.origin.y += BUTTON_LINE1_POS;
	rectNineButton.size.width = BUTTON_WIDTH;
	rectNineButton.size.height = BUTTON_HIGHT;
	CalcButton* nineButton = [[CalcButton alloc] initWithFrame:rectNineButton];
	[nineButton setTitle:@"9" forState:UIControlStateNormal];
	[nineButton addTarget:self action:@selector(actPush_9:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:nineButton];
	
	// line 2
	CGRect	rectBackButton = rectMainFrame;
	rectBackButton.origin.x += (ROW_PITCH * 1) + BUTTON_ROW_OFFSET;
	rectBackButton.origin.y += BUTTON_LINE2_POS;
	rectBackButton.size.width = BUTTON_WIDTH;
	rectBackButton.size.height = BUTTON_HIGHT;
	CalcButton* backButton = [[CalcButton alloc] initWithFrame:rectBackButton];
	[backButton setTitle:@">" forState:UIControlStateNormal];
	backButton.redButton = TRUE;
	[backButton addTarget:self action:@selector(actPush_back:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	
	CGRect	rectFourButton = rectMainFrame;
	rectFourButton.origin.x += (ROW_PITCH * 8) + BUTTON_ROW_OFFSET;
	rectFourButton.origin.y += BUTTON_LINE2_POS;
	rectFourButton.size.width = BUTTON_WIDTH;
	rectFourButton.size.height = BUTTON_HIGHT;
	CalcButton* fourButton = [[CalcButton alloc] initWithFrame:rectFourButton];
	[fourButton setTitle:@"4" forState:UIControlStateNormal];
	[fourButton addTarget:self action:@selector(actPush_4:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:fourButton];
	
	CGRect	rectFiveButton = rectMainFrame;
	rectFiveButton.origin.x += (ROW_PITCH * 15) + BUTTON_ROW_OFFSET;
	rectFiveButton.origin.y += BUTTON_LINE2_POS;
	rectFiveButton.size.width = BUTTON_WIDTH;
	rectFiveButton.size.height = BUTTON_HIGHT;
	CalcButton* fiveButton = [[CalcButton alloc] initWithFrame:rectFiveButton];
	[fiveButton setTitle:@"5" forState:UIControlStateNormal];
	[fiveButton addTarget:self action:@selector(actPush_5:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:fiveButton];
	
	CGRect	rectSixButton = rectMainFrame;
	rectSixButton.origin.x += (ROW_PITCH * 22) + BUTTON_ROW_OFFSET;
	rectSixButton.origin.y += BUTTON_LINE2_POS;
	rectSixButton.size.width = BUTTON_WIDTH;
	rectSixButton.size.height = BUTTON_HIGHT;
	CalcButton* sixButton = [[CalcButton alloc] initWithFrame:rectSixButton];
	[sixButton setTitle:@"6" forState:UIControlStateNormal];
	[sixButton addTarget:self action:@selector(actPush_6:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:sixButton];
	
	// line 3
	CGRect	rectZeroButton = rectMainFrame;
	rectZeroButton.origin.x += (ROW_PITCH * 1) + BUTTON_ROW_OFFSET;
	rectZeroButton.origin.y += BUTTON_LINE3_POS;
	rectZeroButton.size.width = BUTTON_WIDTH;
	rectZeroButton.size.height = BUTTON_HIGHT;
	CalcButton* zeroButton = [[CalcButton alloc] initWithFrame:rectZeroButton];
	[zeroButton setTitle:@"0" forState:UIControlStateNormal];
	[zeroButton addTarget:self action:@selector(actPush_0:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:zeroButton];
	
	CGRect	rectOneButton = rectMainFrame;
	rectOneButton.origin.x += (ROW_PITCH * 8) + BUTTON_ROW_OFFSET;
	rectOneButton.origin.y += BUTTON_LINE3_POS;
	rectOneButton.size.width = BUTTON_WIDTH;
	rectOneButton.size.height = BUTTON_HIGHT;
	CalcButton* oneButton = [[CalcButton alloc] initWithFrame:rectOneButton];
	[oneButton setTitle:@"1" forState:UIControlStateNormal];
	[oneButton addTarget:self action:@selector(actPush_1:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:oneButton];
	
	CGRect	rectTwoButton = rectMainFrame;
	rectTwoButton.origin.x += (ROW_PITCH * 15) + BUTTON_ROW_OFFSET;
	rectTwoButton.origin.y += BUTTON_LINE3_POS;
	rectTwoButton.size.width = BUTTON_WIDTH;
	rectTwoButton.size.height = BUTTON_HIGHT;
	CalcButton* twoButton = [[CalcButton alloc] initWithFrame:rectTwoButton];
	[twoButton setTitle:@"2" forState:UIControlStateNormal];
	[twoButton addTarget:self action:@selector(actPush_2:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:twoButton];
	
	CGRect	rectThreeButton = rectMainFrame;
	rectThreeButton.origin.x += (ROW_PITCH * 22) + BUTTON_ROW_OFFSET;
	rectThreeButton.origin.y += BUTTON_LINE3_POS;
	rectThreeButton.size.width = BUTTON_WIDTH;
	rectThreeButton.size.height = BUTTON_HIGHT;
	CalcButton* threeButton = [[CalcButton alloc] initWithFrame:rectThreeButton];
	[threeButton setTitle:@"3" forState:UIControlStateNormal];
	[threeButton addTarget:self action:@selector(actPush_3:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:threeButton];

}

// *****************************************************************
//	@brief	update display text
//	@note
//		Nothing
// *****************************************************************
- (void) updateDisplay
{
	if ( m_selectSegment.selectedSegmentIndex == SEG_FREQ ) {
		
		if (m_imputValue != 0 ){
			
			// The following cords calculate the next formula.
			// answer = (1.0 / m_imputValue) * 1000
			NSDecimalNumber *decNum1 = [NSDecimalNumber decimalNumberWithString:@"1.0"];
			NSDecimalNumber *decNum2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%u", m_imputValue]];
			NSDecimalNumber *decNum3 = [NSDecimalNumber decimalNumberWithString:@"1000"];
			NSDecimalNumber *decAnswer = [[decNum1 decimalNumberByDividingBy:decNum2]decimalNumberByMultiplyingBy:decNum3];
			
			// freq label
			[m_freqLabel setDecNumFlag:FALSE];
			[m_freqLabel setUIntNumber:m_imputValue];
			
			// periodic label
			[m_periodicLabel setDecNumFlag:TRUE];
			[m_periodicLabel setDecimalNumber:decAnswer];
		}
		else {
			// freq label
			[m_freqLabel setDecNumFlag:FALSE];
			[m_freqLabel setUIntNumber:0U];

			// periodic label
			[m_periodicLabel setDecNumFlag:FALSE];
			[m_periodicLabel setUIntNumber:0U];
		}
	}
	else {

		if (m_imputValue != 0 ){
			
			// The following cords calculate the next formula.
			// answer = 1000 / m_imputValue
			NSDecimalNumber *decNum1 = [NSDecimalNumber decimalNumberWithString:@"1000"];
			NSDecimalNumber *decNum2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%u", m_imputValue]];
			NSDecimalNumber *decAnswer = [decNum1 decimalNumberByDividingBy:decNum2];
			
			// freq label
			[m_freqLabel setDecNumFlag:TRUE];
			[m_freqLabel setDecimalNumber:decAnswer];
			
			// periodic label
			[m_periodicLabel setDecNumFlag:FALSE];
			[m_periodicLabel setUIntNumber:m_imputValue];
		}
		else {
			// freq label
			[m_freqLabel setDecNumFlag:FALSE];
			[m_freqLabel setUIntNumber:0U];
			
			// periodic label
			[m_periodicLabel setDecNumFlag:FALSE];
			[m_periodicLabel setUIntNumber:0U];
		}
	}
}

// *****************************************************************
//	@brief	Click event function ( select segment )
//	@note
//		Nothing
// *****************************************************************
-(void)actSelect:(UISegmentedControl*)seg
{
	if ( seg.selectedSegmentIndex == SEG_FREQ ) {
		[m_freqLabel setEmphasis	:TRUE];
		[m_periodicLabel setEmphasis:FALSE];
	}
	else {
		[m_freqLabel setEmphasis	:FALSE];
		[m_periodicLabel setEmphasis:TRUE];
	}

	[self initNumber];
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 0 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_0:(id)inSender
{
	BOOL result = [self appendNumber:0];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 1 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_1:(id)inSender
{
	BOOL result = [self appendNumber:1];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 2 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_2:(id)inSender
{
	BOOL result = [self appendNumber:2];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 3 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_3:(id)inSender
{
	BOOL result = [self appendNumber:3];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 4 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_4:(id)inSender
{
	BOOL result = [self appendNumber:4];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 5 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_5:(id)inSender
{
	BOOL result = [self appendNumber:5];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 6 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_6:(id)inSender
{
	BOOL result = [self appendNumber:6];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 7 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_7:(id)inSender
{
	BOOL result = [self appendNumber:7];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 8 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_8:(id)inSender
{
	BOOL result = [self appendNumber:8];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( 9 button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_9:(id)inSender
{
	BOOL result = [self appendNumber:9];
	if ( result == FALSE ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LSTR_ALERT_TITLE
														message:LSTR_ALERT_MESSAGE
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
	
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( back button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_back:(id)inSender
{
	[self reduceDigitNumber];
	[self updateDisplay];
}

// *****************************************************************
//	@brief	Click event function ( clear button )
//	@note
//		Nothing
// *****************************************************************
- (void) actPush_clear:(id)inSender
{
	[self initNumber];
	[self updateDisplay];
}

// *****************************************************************
//	@brief	initilize value
//	@note
//		Nothing
// *****************************************************************
- (void)initNumber
{
	m_imputValue = 0;
}

// *****************************************************************
//	@brief	append value to member variable
//	@note
//		Nothing
// *****************************************************************
- (BOOL)appendNumber: (NSUInteger) num
{
	BOOL result = FALSE;
	
	const long long	CALC_MAX_VALUE = 0xFFFFFFFF;
	
	long long tempValue = (long long)m_imputValue;
	tempValue = (tempValue * 10) + (long long)num;
	
	if ( tempValue <= CALC_MAX_VALUE ) {
		m_imputValue = tempValue;
		result = TRUE;
	}
	else {
		result = FALSE;
	}
	
	return result;
	
}

// *****************************************************************
//	@brief	reduce value from member variable
//	@note
//		Nothing
// *****************************************************************
- (void)reduceDigitNumber
{
	m_imputValue /= 10;
}

@end
