
//  RootViewController.h
//  Trailers
//
//  Created by Jonah Grant on 6/16/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"
#import "MBProgressHUD.h"

@class MovieViewController, TrailersAppDelegate;

@interface RootViewController : UIViewController  <UIScrollViewDelegate, ADBannerViewDelegate, MBProgressHUDDelegate> 
{
	NSMutableArray *blogEntries;
	NSMutableArray *directors;
	NSMutableArray *ratings;
	NSMutableArray *studios;
	NSMutableArray *copyListOfItems;
	NSMutableArray *cast;
	NSMutableArray *trailers;
	NSMutableArray *description;
	NSMutableArray *posters;
	NSMutableArray *copyright;
	NSMutableArray *runtime;
	NSMutableArray *releaseDate;
	NSMutableArray *genre;
	MovieViewController *bdvController;
	TrailersAppDelegate *appDelegate;
	RootViewController *viewController;
	MBProgressHUD *HUD;
	UIWindow *window;
	BOOL adDidLoad;
	IBOutlet UIView *adLoading;
	UIControl* adView;
	NSInteger numberOfSections;
	NSInteger contentRows;
	UIAlertView *alert;
	UIView *_contentView;
	id _adBannerView;
	BOOL _adBannerViewIsVisible;
	IBOutlet UIView *iAd;
}
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) id adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *adLoading;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;

@end

