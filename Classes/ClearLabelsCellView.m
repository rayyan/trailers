//
//  ClearLabelsCellView.m
//  ShadowedTableView
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import "ClearLabelsCellView.h"


@implementation ClearLabelsCellView

//
// setSelected:animated:
//
// The default setSelected:animated: method sets the textLabel and
// detailTextLabel background to white when invoked (which is
// on every construction). This override undoes that and sets their background
// to clearColor.
//
// Parameters:
//    selected - is the cell being selected
//    animated - should the selection be animated
//
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];

	self.textLabel.backgroundColor = [UIColor clearColor];
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
	//self.selected.textLabel.shadowColor = [UIColor whiteColor];
	//self.textLabel.highlightedTextColor.shadowOffset = CGSizeMake(0.0, 1.0);
	if (self.highlighted) {
		self.detailTextLabel.shadowColor = [UIColor whiteColor];
		self.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		self.textLabel.shadowColor = [UIColor whiteColor];
		self.textLabel.shadowOffset = CGSizeMake(0.0, 4.0);
	}
	//self.detailTextLabel.selected.shadowColor = [UIColor whiteColor];
	//self.detailTextLabel.selected.shadowOffset = CGSizeMake(0.0, 1.0);
}


@end
