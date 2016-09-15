//
//  CalcButton.m
//  EECalc2
//
//  Created by Hiroaki Fujisawa on 2013/04/24.
//  Copyright (c) 2013年 Hiroaki Fujisawa. All rights reserved.
//

#import "CalcButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CalcButton

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
		self.redButton = FALSE;
		
		CGFloat	fontSize = frame.size.height * 0.5;
		[self.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
	}
	return self;
}

-(void)setHighlighted:(BOOL)value {
	[super setHighlighted:value];
	[self setNeedsDisplay];
}
-(void)setSelected:(BOOL)value {
	[super setSelected:value];
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	[[self layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
	[[self layer] setBorderWidth:1.0];
	
	[[self layer] setCornerRadius:10.0];
	[self setClipsToBounds:YES];
	
	if ( self.redButton == TRUE ) {
		[self setTitleColor:[UIColor colorWithRed:1.00f green:0.38f blue:0.38f alpha:1.0f]
				   forState:UIControlStateNormal];
	}
	else {
		[self setTitleColor:[UIColor colorWithRed:0.28f green:0.38f blue:0.59 alpha:1.0f]
				   forState:UIControlStateNormal];
	}

	[self setTitleColor:[UIColor whiteColor]	forState:UIControlStateHighlighted];
	[self setTitleColor:[UIColor lightGrayColor]forState:UIControlStateDisabled];
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGFloat w = self.bounds.size.width;
	CGFloat h = self.bounds.size.height;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextSaveGState(c);
	CGContextSetShouldAntialias(c, true);

	CGFloat locations[2] = {0.0, 1.0};
	size_t num_locations = 2;
	CGGradientRef gradient;
	if (self.state & (UIControlStateSelected | UIControlStateHighlighted)) {
		CGFloat components[8] = {0.68, 0.68, 0.68, 1.0, 0.35, 0.35, 0.35, 1.0};
		gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
	} else {
		CGFloat components[8] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
		gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
		
	}
	// 生成したCGGradientを描画する
	// 始点と終点を指定してやると、その間に直線的なグラデーションが描画される。
	CGPoint startPoint = CGPointMake(w/2, 0.0);
	CGPoint endPoint = CGPointMake(w/2, h-1);
	CGContextDrawLinearGradient(c, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(c);
	
	[super drawRect:rect];
}

@end
