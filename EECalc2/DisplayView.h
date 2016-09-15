//
//  DisplayView.h
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/04/25.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum typDisplayMode : NSUInteger {
	DISPMODE_DEC = 0,
	DISPMODE_HEX,
	DISPMODE_BIN,
	DISPMODE_FREQ,
	DISPMODE_PERIODIC,
	DISPMODE_INTEGER,
	DISPMODE_BITLEN,
	DISPMODE_BYTELEN
} typDisplayMode;


@interface DisplayView : UIView
{
	UILabel*			m_tagLabel;
	UILabel*			m_display1Label;
	UILabel*			m_display2Label;
	UILabel*			m_unitLabel;
	
	typDisplayMode		m_dispMode;
	BOOL				m_emphasis;
	BOOL				m_decNumFlag;
	NSUInteger			m_uintNumber;
	NSDecimalNumber*	m_decimalNumber;
}

- (void) setDisplayMode:(typDisplayMode)type;
- (void) setEmphasis:(BOOL)emphasis;
- (void) setDecNumFlag:(BOOL)enable;
- (void) setUIntNumber:(NSUInteger)num;
- (void) setDecimalNumber:(NSDecimalNumber*)num;

@end
