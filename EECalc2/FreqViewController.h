//
//  FreqViewController.h
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/05/09.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayView.h"

@interface FreqViewController : UIViewController
{
	// display parts
	UISegmentedControl*	m_selectSegment;
	DisplayView*		m_freqLabel;
	DisplayView*		m_periodicLabel;
	
	// member vriable
	NSUInteger			m_imputValue;
	
	// localized string
	NSString*	LSTR_ALERT_TITLE;
	NSString*	LSTR_ALERT_MESSAGE;
}

@end
