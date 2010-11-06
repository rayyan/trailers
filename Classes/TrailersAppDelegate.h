
//  TrailersAppDelegate.h
//  Trailers
//
//  Created by Jonah Grant on 6/16/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class MovieViewController;

@interface TrailersAppDelegate : NSObject <UIApplicationDelegate, ADBannerViewDelegate> 
{
    UIWindow *window;
    UINavigationController *navigationController;
	MovieViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

