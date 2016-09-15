//
//  BitLengthViewController.h
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/05/10.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayView.h"

@interface BitLengthViewController : UIViewController
{
	// Display parts
	DisplayView*		m_decLabel;
	DisplayView*		m_bitLabel;
	DisplayView*		m_byteLabel;
	
	// member variable
	NSDecimalNumber*	m_imputDecNum;
	
	// localized string
	NSString*	LSTR_ALERT_TITLE;
	NSString*	LSTR_ALERT_MESSAGE;
}
@end
