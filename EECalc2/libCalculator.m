//
//  libCalculator.m
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/05/04.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import "libCalculator.h"

@implementation libCalculator

// *****************************************************************
//	@brief	Initializer
//	@note
//		Nothing
// *****************************************************************
- (id)init
{
	self = [super init];

	if (self != nil) {
		
		// Custom code
		[self initModule:CALCMODE_DEC];
	}

	return self;
}

// *****************************************************************
//	@brief	Initializer with Calclator mode
//	@note
//		Nothing
// *****************************************************************
- (id)initWithCalcMode:(typCalcMode)mode;
{
	self = [super init];
	
	if (self != nil) {
		
		// Custom code
		[self initModule:mode];
	}
	
	return self;
}

// *****************************************************************
//	@brief	Mode change and module init.
//	@note
//		Nothing
// *****************************************************************
- (void)modeChanegWithInit:(typCalcMode)mode
{
	[self initModule:mode];
}

// *****************************************************************
//	@brief	all init for this module
//	@note
//		Nothing
// *****************************************************************
- (void)initModule:(typCalcMode)mode
{
	m_mode = mode;
	m_number = 0U;
}

// *****************************************************************
//	@brief	append value to member variable
//	@note
//		Nothing
// *****************************************************************
- (BOOL)appendNumber: (NSUInteger) num
{
	const long long	CALC_MAX_VALUE = 0xFFFFFFFF;
	
	long long tempValue = (long long)m_number;
	
	switch (m_mode)
	{
		case CALCMODE_DEC:
			tempValue = (tempValue * 10) + num;
			if ( (num > 9) || (tempValue > CALC_MAX_VALUE) ) {		// limit chack depending on DEC
				return FALSE;
			}
			else {
				m_number *= 10;
			}
			break;

		case CALCMODE_HEX:
			tempValue = (tempValue * 0x10) + num;
			if ( (num > 0x0F) || (tempValue > CALC_MAX_VALUE) ) {	// limit chack depending on HEX
				return FALSE;
			}
			else {
				m_number *= 0x10;
			}
			break;

		default:	// error 
			return FALSE;
			break;
	}

	m_number += num;
	
	return TRUE;
}

// *****************************************************************
//	@brief	reduce value from member variable
//	@note
//		Nothing
// *****************************************************************
- (void)reduceDigit
{
	switch (m_mode)
	{
		case CALCMODE_DEC:
			m_number /= 10;
			break;
			
		case CALCMODE_HEX:
			m_number /= 0x10;
			break;
			
		default:	// error
			m_number = 0;
			break;
	}
}

// *****************************************************************
//	@brief	provide number
//	@note
//		Nothing
// *****************************************************************
- (NSUInteger)getNumber
{
	return m_number;
}

@end
