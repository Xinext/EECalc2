//
//  libCalculator.h
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/05/04.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum typCalcMode : NSUInteger {
	CALCMODE_DEC = 0,
	CALCMODE_HEX
} typCalcMode;

@interface libCalculator : NSObject
{
	typCalcMode		m_mode;
	NSUInteger		m_number;
}

// Initializer
- (id)init;		// Mode is DEC.
- (id)initWithCalcMode:(typCalcMode)mode;

// Management
- (void)modeChanegWithInit:(typCalcMode)mode;

// Operation
- (BOOL)appendNumber: (NSUInteger) num;
- (void)reduceDigit;
- (NSUInteger)getNumber;

@end
