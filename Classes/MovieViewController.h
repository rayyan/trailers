
//  MovieViewController.h
//  Trailers
//
//  Created by Jonah Grant on 6/10/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import "SA_OAuthTwitterController.h"
#import <EventKit/EventKit.h>
#import "iAd/ADBannerView.h"
#import "MBProgressHUD.h"
#import "FacebookAgent.h"
#import "TKOverviewHeaderView.h"
#import "TKOverviewIndicatorView.h"

@class SA_OAuthTwitterEngine;
@class RootViewController;

@interface MovieViewController : UIViewController <UIPopoverControllerDelegate, 
													SA_OAuthTwitterControllerDelegate, 
													MFMessageComposeViewControllerDelegate,
													UIPopoverControllerDelegate,
													ADBannerViewDelegate,
													FacebookAgentDelegate,
													MBProgressHUDDelegate> {
	
    id movieTitle;
	UISegmentedControl  *segmentedControl;
	FacebookAgent* fbAgent;
	UIPopoverController *popoverController;
	NSArray               * segmentedViewControllers;
	IBOutlet id customCell;
	NSString *shortName;
	IBOutlet UILabel *name;
	SA_OAuthTwitterEngine				*_engine;
	RootViewController *root;
	EKEvent *event;
	MBProgressHUD *HUD;
	NSString *url;
	IBOutlet UIView *ad;
	UIToolbar *toolbar;
	UIActivityIndicatorView *activityInd;
	UITextField *txtTwitterUserName;
	EKEventStore *eventStore;
	BOOL isIndenendent;
	BOOL *fbLoggedIn;
	UITextField *txtTwitterPassword;
	IBOutlet UIView *iAd;
	NSDate *movieReleaseDate;
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_1
	MPMoviePlayerController *moviePlayerController;
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
	MPMoviePlayerViewController *moviePlayerViewController;
#endif
	BOOL adDidLoad;
	UIControl* adView;
	NSInteger numberOfSections;
	NSInteger contentRows; 
    UIWindow *window;
	NSInteger _expanded;
	TKOverviewHeaderView *header;
	TKOverviewIndicatorView *indicator;
}

@property (nonatomic, retain) TKOverviewHeaderView *header;
@property (nonatomic, retain) IBOutlet UITableViewCell *theCell;
@property(nonatomic,retain)UIPopoverController *popoverController;
@property (nonatomic, retain, readonly) IBOutlet UISegmentedControl * segmentedControl;
@property (nonatomic, retain, readonly) NSArray * segmentedViewControllers;
@property (nonatomic, retain) id movieTitle;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableView *tableViewPad;

#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_1
@property (readwrite, retain) MPMoviePlayerController *moviePlayerController;
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
@property (readwrite, retain) MPMoviePlayerViewController *moviePlayerViewController;
#endif


@end

