
//  TrailersAppDelegate.m
//  Trailers
//
//  Created by Jonah Grant on 6/16/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//
 

#import "TrailersAppDelegate.h"
#import "RootViewController.h"
#import "MovieViewController.h"
#import "FacebookAgent.h"
#import "GANTracker.h"

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation TrailersAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
    [[FacebookAgent sharedAgent]  initializeWithApiKey:@"3d6d8f795a7fe138d64e62dc01293ffd"
											 ApiSecret:@"f81d5e90d6f1f62e8df4365391e3cb77"
											  ApiProxy:nil];
	    
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];	
	
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-19541660-1"
										   dispatchPeriod:kGANDispatchPeriodSec
												 delegate:nil];
	NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:@"my_category"
										 action:@"my_action"
										  label:@"my_label"
										  value:-1
									  withError:&error]) {
	}
	
	if (![[GANTracker sharedTracker] trackPageview:@"/app_entry_point"
										 withError:&error]) {
		// Handle error here
	}
	
	
    return YES;
}

#pragma mark -
#pragma mark Memory management


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end
