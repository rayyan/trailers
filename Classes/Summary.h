
//  Summary.h
//  Trailers
//
//  Created by Jonah Grant on 6/11/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//
 

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface Summary : UIViewController {
	IBOutlet UITextView *text;
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_1
	MPMoviePlayerController *moviePlayerController;
#endif
	//On a 4.0 device, implement the MPMoviePlayerViewController
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
	MPMoviePlayerViewController *moviePlayerViewController;
#endif
	IBOutlet UIBarButtonItem *colorText;
	NSString *colorChanged;
	IBOutlet UINavigationBar *navBar;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_1
@property (readwrite, retain) MPMoviePlayerController *moviePlayerController;
#endif
//On a 4.0 device, implement the MPMoviePlayerViewController
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
@property (readwrite, retain) MPMoviePlayerViewController *moviePlayerViewController;
#endif
-(IBAction)larger;
-(IBAction)smaller;
-(IBAction)color;
-(IBAction)done;
@end
