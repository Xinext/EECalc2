//
//  HexdecimalViewController.h
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/05/07.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libCalculator.h"
#import "DisplayView.h"

@interface HexdecimalViewController : UIViewController
{
	// Display parts
	DisplayView*	m_decLabel;
	DisplayView*	m_hexLabel;
	DisplayView*	m_binLabel;
	
	// member variable
	libCalculator*	m_libCalc;
	
	// localized string
	NSString*	LSTR_ALERT_TITLE;
	NSString*	LSTR_ALERT_MESSAGE;
}

@end
