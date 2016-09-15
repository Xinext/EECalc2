//
//  DisplayView.m
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/04/25.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import "DisplayView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DisplayView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
		
		// init property
		m_dispMode = DISPMODE_DEC;
		m_emphasis = FALSE;
		m_decNumFlag = FALSE;
		
		// init member variable
		m_tagLabel = [[UILabel alloc] init];
		m_display1Label = [[UILabel alloc] init];
		m_display2Label = [[UILabel alloc] init];
		m_unitLabel = [[UILabel alloc] init];
		
		m_uintNumber = 0U;
		m_decimalNumber = nil;
		
		// init proc
		[self initFirstDisplay];
		
		// add sub view
		[self addSubview:m_tagLabel];
		[self addSubview:m_display1Label];
		[self addSubview:m_display2Label];
		[self addSubview:m_unitLabel];
	}
	return self;
}

// *****************************************************************
//	@brief	Initialization for all view.
//	@note
//		Nothing
// *****************************************************************
- (void) initFirstDisplay
{
	// *** define value for common design ***
	const CGFloat WIDTH_PITCH = self.frame.size.width / 30;
	const CGFloat HEIGHT_PITCH = self.frame.size.height / 6;
	
	// *** setting for myself view ***
	self.backgroundColor = [UIColor whiteColor];
	[[self layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
	[[self layer] setBorderWidth:2.0];
	[[self layer] setCornerRadius:10.0];
	[self setClipsToBounds:YES];
	
	// *** setting for sub view ***
	[self initFirstDisplay_tagLabel		:WIDTH_PITCH pichOfHight:HEIGHT_PITCH];
	[self initFirstDisplay_display1Label:WIDTH_PITCH pichOfHight:HEIGHT_PITCH];
	[self initFirstDisplay_display2Label:WIDTH_PITCH pichOfHight:HEIGHT_PITCH];
	[self initFirstDisplay_unitLabel	:WIDTH_PITCH pichOfHight:HEIGHT_PITCH];
	
	// re draw display
	[self tagAndUnitReDisplay];
	[self displayReDisplay];
}

// *****************************************************************
//	@brief	Initialization for tagLabel
//	@note
//		Nothing
// *****************************************************************
- (void) initFirstDisplay_tagLabel: (const CGFloat)WIDTH_PITCH pichOfHight: (const CGFloat)HEIGHT_PITCH
{
	// set color and border
	[[m_tagLabel layer] setBorderWidth:0];
	m_tagLabel.backgroundColor = [UIColor clearColor];
	
	// set size and position
	CGRect	rectTag = self.frame;
	rectTag.origin.x = WIDTH_PITCH * 1;
	rectTag.origin.y = 0.0f;
	
	switch (m_dispMode)
	{
		case DISPMODE_DEC:
		case DISPMODE_HEX:
		case DISPMODE_BIN:
		case DISPMODE_INTEGER:
			rectTag.size.width = WIDTH_PITCH * 5;
			break;
			
		case DISPMODE_FREQ:
		case DISPMODE_PERIODIC:
			rectTag.size.width = WIDTH_PITCH * 10;
			break;
		case DISPMODE_BITLEN:
		case DISPMODE_BYTELEN:
			rectTag.size.width = WIDTH_PITCH * 11;
			break;
		
		default:
			rectTag.size.width = WIDTH_PITCH * 5;
			break;
	}
	
	rectTag.size.height = self.frame.size.height;
	m_tagLabel.frame = rectTag;

	m_tagLabel.textAlignment = NSTextAlignmentLeft;
	m_tagLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

// *****************************************************************
//	@brief	Initialization for display1Label
//	@note
//		Nothing
// *****************************************************************
- (void) initFirstDisplay_display1Label: (const CGFloat)WIDTH_PITCH pichOfHight: (const CGFloat)HEIGHT_PITCH
{
	// set color and border
	[[m_display1Label layer] setBorderWidth:0];
	m_display1Label.backgroundColor = [UIColor clearColor];
	
	// set size and position
	CGRect	rectDisplay1 = self.frame;
	
	switch (m_dispMode)
	{
		case DISPMODE_DEC:
		case DISPMODE_HEX:
		case DISPMODE_INTEGER:
			rectDisplay1.origin.x = WIDTH_PITCH * 7;
			rectDisplay1.origin.y = 0.0f;
			rectDisplay1.size.width = WIDTH_PITCH * 22;
			rectDisplay1.size.height = HEIGHT_PITCH * 6;
			break;
		case DISPMODE_BIN:
			rectDisplay1.origin.x = WIDTH_PITCH * 6;
			rectDisplay1.origin.y = HEIGHT_PITCH * 0.5f;
			rectDisplay1.size.width = WIDTH_PITCH * 20;
			rectDisplay1.size.height = HEIGHT_PITCH * 3;
			break;
			
		case DISPMODE_FREQ:
		case DISPMODE_PERIODIC:
			rectDisplay1.origin.x = WIDTH_PITCH * 11;
			rectDisplay1.origin.y = 0.0f;
			rectDisplay1.size.width = WIDTH_PITCH * 15;
			rectDisplay1.size.height = HEIGHT_PITCH * 6;
			break;

		case DISPMODE_BITLEN:
		case DISPMODE_BYTELEN:
			rectDisplay1.origin.x = WIDTH_PITCH * 12;
			rectDisplay1.origin.y = 0.0f;
			rectDisplay1.size.width = WIDTH_PITCH * 13;
			rectDisplay1.size.height = HEIGHT_PITCH * 6;
			break;
			
		default:
			rectDisplay1.origin.x = WIDTH_PITCH * 6;
			rectDisplay1.origin.y = 0.0f;
			rectDisplay1.size.width = WIDTH_PITCH * 24;
			rectDisplay1.size.height = HEIGHT_PITCH * 6;
			break;
	}
	
	m_display1Label.frame = rectDisplay1;
	m_display1Label.textAlignment = NSTextAlignmentRight;
	m_display1Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

// *****************************************************************
//	@brief	Initialization for display1Labe2
//	@note
//		used only in BIN mode
// *****************************************************************
- (void) initFirstDisplay_display2Label: (const CGFloat)WIDTH_PITCH pichOfHight: (const CGFloat)HEIGHT_PITCH
{
	// set color and border
	[[m_display2Label layer] setBorderWidth:0];
	m_display2Label.backgroundColor = [UIColor clearColor];
	
	// set size and position
	CGRect	rectDisplay2 = self.frame;

	switch (m_dispMode)
	{
		case DISPMODE_BIN:
			rectDisplay2.origin.x = WIDTH_PITCH * 9;
			rectDisplay2.origin.y = HEIGHT_PITCH * 2.5f;
			rectDisplay2.size.width = WIDTH_PITCH * 20;
			rectDisplay2.size.height = HEIGHT_PITCH * 3;
			m_display2Label.hidden = NO;
			break;
		default:
			rectDisplay2.origin.x = 0.0f;
			rectDisplay2.origin.y = 0.0f;
			rectDisplay2.size.width = 0.0f;
			rectDisplay2.size.height = 0.0f;
			m_display2Label.hidden = YES;
			break;
	}
	
	m_display2Label.frame = rectDisplay2;
	m_display2Label.textAlignment = NSTextAlignmentRight;
	m_display2Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

// *****************************************************************
//	@brief	Initialization for unitLabel
//	@note
//		Nothing
// *****************************************************************
- (void) initFirstDisplay_unitLabel: (const CGFloat)WIDTH_PITCH pichOfHight: (const CGFloat)HEIGHT_PITCH
{
	// set color and border
	[[m_unitLabel layer] setBorderWidth:0];
	m_unitLabel.backgroundColor = [UIColor clearColor];

	// set size and position
	CGRect	rectUnit = self.frame;

	
	switch (m_dispMode)
	{
		case DISPMODE_FREQ:
		case DISPMODE_PERIODIC:
			rectUnit.origin.x = WIDTH_PITCH * 26;
			rectUnit.origin.y = HEIGHT_PITCH * 2;
			rectUnit.size.width = WIDTH_PITCH * 4;
			rectUnit.size.height = HEIGHT_PITCH * 3;
			m_unitLabel.hidden = NO;
			break;
		case DISPMODE_BITLEN:
		case DISPMODE_BYTELEN:
			rectUnit.origin.x = WIDTH_PITCH * 25;
			rectUnit.origin.y = HEIGHT_PITCH * 2;
			rectUnit.size.width = WIDTH_PITCH * 4;
			rectUnit.size.height = HEIGHT_PITCH * 4;
			m_unitLabel.hidden = NO;
			break;
		default:
			rectUnit.origin.x = 0.0f;
			rectUnit.origin.y = 0.0f;
			rectUnit.size.width = 0.0f;
			rectUnit.size.height = 0.0f;
			m_unitLabel.hidden = YES;
			break;
	}

	m_unitLabel.frame = rectUnit;
	m_unitLabel.textAlignment = NSTextAlignmentLeft;
	m_unitLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	// Drawing code
}
*/

// *****************************************************************
//	@brief	(Re)Display tag label
//	@note
//		Nothing
// *****************************************************************
- (void) tagAndUnitReDisplay
{
	// set string
	NSString*	strTagLabel;
	NSString*	strUnitLabel;
	
	switch (m_dispMode)
	{
		case DISPMODE_DEC:
			strTagLabel = @"DEC:";
			strUnitLabel = @"";
			break;
		case DISPMODE_HEX:
			strTagLabel = @"HEX:";
			strUnitLabel = @"";
			break;
		case DISPMODE_BIN:
			strTagLabel = @"BIN:";
			strUnitLabel = @"";
			break;
		case DISPMODE_FREQ:
			strTagLabel = @"Frequency:";
			strUnitLabel = @"Hz";
			break;
		case DISPMODE_PERIODIC:
			strTagLabel = @"Periodic:";
			strUnitLabel = @"ms";
			break;
		case DISPMODE_INTEGER:
			strTagLabel = @"INT:";
			strUnitLabel = @"";
			break;
		case DISPMODE_BITLEN:
			strTagLabel = @"Bit length:";
			strUnitLabel = @"bit";
			break;
		case DISPMODE_BYTELEN:
			strTagLabel = @"Byte length:";
			strUnitLabel = @"byte";
			break;
		default:
			strTagLabel = @"Err:";
			strUnitLabel = @"Err";
			break;
	}
	m_tagLabel.text = strTagLabel;
	m_unitLabel.text = strUnitLabel;

	// set color
	if (m_emphasis == TRUE) {
		m_tagLabel.textColor = [UIColor colorWithRed:1.00f green:0.38f blue:0.38f alpha:1.0f];
	}
	else {
		m_tagLabel.textColor = [UIColor colorWithRed:0.28f green:0.38f blue:0.59f alpha:1.0f];
	}
	
	m_unitLabel.textColor = [UIColor colorWithRed:0.28f green:0.38f blue:0.59f alpha:1.0f];
	
	// set font
	CGFloat fontSize = self.frame.size.width * 0.07;
	
	m_tagLabel.font = [UIFont boldSystemFontOfSize:fontSize];
	m_tagLabel.adjustsFontSizeToFitWidth = YES;

	m_unitLabel.font = [UIFont boldSystemFontOfSize:fontSize];
	m_unitLabel.adjustsFontSizeToFitWidth = YES;
}

// *****************************************************************
//	@brief	change from number to dec text
//	@note
//		Nothing
// *****************************************************************
- (NSString*) uintNumber2DecText
{
	NSString*	strtext;
	
	strtext = [NSString stringWithFormat:@"%u", m_uintNumber ];
	
	return strtext;
}

// *****************************************************************
//	@brief	change from number to dec text
//	@note
//		Nothing
// *****************************************************************
- (NSString*) uintNumber2DecStyleText
{
	NSNumber* num = [NSNumber numberWithUnsignedInteger:m_uintNumber];
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	NSString* strtext = [formatter stringFromNumber:num];
	
	return strtext;
}

// *****************************************************************
//	@brief	change from number to hex text
//	@note
//		Nothing
// *****************************************************************
- (NSString*) uintNumber2HexText
{
	NSString*	strtext;
	NSString*	strHex = [NSString stringWithFormat:@"%08X", m_uintNumber ];
	
	NSString* str1 = [strHex substringWithRange:NSMakeRange(6, 2)];
	NSString* str2 = [strHex substringWithRange:NSMakeRange(4, 2)];
	NSString* str3 = [strHex substringWithRange:NSMakeRange(2, 2)];
	NSString* str4 = [strHex substringWithRange:NSMakeRange(0, 2)];
	
	strtext = [NSString stringWithFormat:@"%@ %@ %@ %@", str4, str3, str2, str1];
	
	return strtext;
}

// *****************************************************************
//	@brief	change from number to bin text
//	@note
//		Nothing
// *****************************************************************
- (NSString*) uintNumber2BinText: (NSInteger)lineNumber
{
	
	//argument check
	if ( lineNumber > 1 ) {
		return @"";
	}
	
	// convert to bin text
	NSString* strText = @"";
	
	NSString* strBin[] = { @"0000", @"0001", @"0010", @"0011", @"0100", @"0101", @"0110", @"0111",
						   @"1000", @"1001", @"1010", @"1011", @"1100", @"1101", @"1110", @"1111" };
	
	NSString*	strHex = [NSString stringWithFormat:@"%08X", m_uintNumber ];
	
	NSInteger	index;
	NSInteger	stratPos, endPos;
	if ( lineNumber == 0 ) {
		stratPos = 0;
		endPos = 4;
	}
	else {
		stratPos = 4;
		endPos = 8;
	}
	for ( index = stratPos; index < endPos; index++ ) {
		
		NSString*	strByte = [@"0x" stringByAppendingString:[strHex substringWithRange:NSMakeRange(index, 1)]];
		NSScanner*	scanByte = [NSScanner scannerWithString: strByte];
		unsigned int intByte;
		[scanByte scanHexInt: &intByte];
		if ( index != stratPos) {
			strText = [strText stringByAppendingString:@" "];
		}
		strText = [strText stringByAppendingString:strBin[intByte]];
	}
	
	return strText;
}

// *****************************************************************
//	@brief	change from number to text according to float flag
//	@note
//		Nothing
// *****************************************************************
- (NSString*) number2TextAccordingToFloatFlag
{
	NSString* strText;

	if ( m_decNumFlag == TRUE ) {
		strText = [NSString stringWithFormat:@"%@", m_decimalNumber];
	}
	else {
		strText = [self uintNumber2DecText];
	}

	return strText;
}

// *****************************************************************
//	@brief	(Re)Display display label
//	@note
//		Nothing
// *****************************************************************
- (void) displayReDisplay
{
	// set string
	NSString*	strLabel1;
	NSString*	strLabel2;
	CGFloat		minimumFontScale = 0.0;
	
	switch (m_dispMode)
	{
		case DISPMODE_DEC:
			strLabel1 = [self uintNumber2DecStyleText];
			strLabel2 = @"";
			break;
		case DISPMODE_BITLEN:
		case DISPMODE_BYTELEN:
			strLabel1 = [self uintNumber2DecText];
			strLabel2 = @"";
			break;
		case DISPMODE_HEX:
			strLabel1 = [self uintNumber2HexText];
			strLabel2 = @"";
			break;
		case DISPMODE_BIN:
			strLabel1 = [self uintNumber2BinText: 0];
			strLabel2 = [self uintNumber2BinText: 1];
			break;
		case DISPMODE_INTEGER:
			strLabel1 = [self number2TextAccordingToFloatFlag];
			strLabel2 = @"";
			break;
		case DISPMODE_FREQ:
		case DISPMODE_PERIODIC:
			strLabel1 = [self number2TextAccordingToFloatFlag];
			strLabel2 = @"";
			if ( m_decNumFlag == TRUE ) {
				minimumFontScale= 0.5;
			}
			break;
		default:
			strLabel1 = @"Error";
			strLabel2 = @"";
			break;
	}
	m_display1Label.text = strLabel1;
	m_display2Label.text = strLabel2;
	
	// set font
	CGFloat fontSize1 = m_display1Label.frame.size.height * 0.8;
	m_display1Label.font = [UIFont systemFontOfSize:fontSize1];
	m_display1Label.adjustsFontSizeToFitWidth = YES;
	m_display1Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	m_display1Label.minimumScaleFactor = minimumFontScale;

	CGFloat fontSize2 = m_display2Label.frame.size.height * 0.8;
	m_display2Label.font = [UIFont systemFontOfSize:fontSize2];
	m_display2Label.adjustsFontSizeToFitWidth = YES;
	m_display2Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

// *****************************************************************
//	@brief	(Re)Display all object
//	@note
//		Nothing
// *****************************************************************
- (void) allReDisplay
{
	if (m_emphasis == TRUE) {
		self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.5f alpha:1.0f];
	}
	else {
		self.backgroundColor = [UIColor whiteColor];
	}

	[self tagAndUnitReDisplay];
	[self displayReDisplay];
}

// *****************************************************************
//	@brief	update display mode
//	@note
//		Nothing
// *****************************************************************
- (void) setDisplayMode:(typDisplayMode)type
{
	m_dispMode = type;
	[self initFirstDisplay];
	[self allReDisplay];
}

// *****************************************************************
//	@brief	Update emphasis
//	@note
//		Nothing
// *****************************************************************
- (void) setEmphasis:(BOOL)emphasis
{
	m_emphasis = emphasis;
	[self allReDisplay];
}

// *****************************************************************
//	@brief	Update float mode
//	@note
//		Nothing
// *****************************************************************
- (void) setDecNumFlag:(BOOL)enable
{
	m_decNumFlag = enable;
	[self allReDisplay];
}

// *****************************************************************
//	@brief	Update number case NSInterger
//	@note
//		Nothing
// *****************************************************************
- (void) setUIntNumber:(NSUInteger)num
{
	m_uintNumber = num;
	[self allReDisplay];
}

// *****************************************************************
//	@brief	Update number case CGFloat
//	@note
//		Nothing
// *****************************************************************
- (void) setDecimalNumber:(NSDecimalNumber*)num
{
	m_decimalNumber = num;
	[self allReDisplay];
}

@end
