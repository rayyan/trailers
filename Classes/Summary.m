
//  Summary.m
//  Trailers
//
//  Created by Jonah Grant on 6/11/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//

#import "Summary.h"
#import "MediaPlayer/MediaPlayer.h"
#import "Reachability.h"

@implementation Summary
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_1
@synthesize moviePlayerController;
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
@synthesize moviePlayerViewController;
#endif

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Summary";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"title"];
	NSString *myString1 = [prefs stringForKey:@"description"];
	text.text = myString1;
		self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"Play Trailer" 
																				 style:UIBarButtonSystemItemPlay 
																				target:self 
																				action:@selector(back)] autorelease];			
	colorChanged = @"white";
	text.textColor = [UIColor blackColor];
	text.backgroundColor = [UIColor whiteColor];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		navBar.hidden = YES;
		[text setFrame:CGRectMake(0,0,320,460)];
	}
	[text addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
	[text removeObserver:self forKeyPath:@"contentSize"];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint offset = scrollView.contentOffset;
	text.transform = CGAffineTransformMakeTranslation(0, -offset.y);
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftMainViewWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnMainViewToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
	else {
		return NO;
	}
}

-(void)back
{
	[Reachability sharedReachability].hostName = @"jonahgrant.com";
	if ([[Reachability sharedReachability] remoteHostStatus] == ReachableViaCarrierDataNetwork) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention"
														message:@"You are on a carrier data network, which may result in extended loading time of the trailer.  It is reccomemended that you connect to a Wi-Fi network for faster viewing." 
													   delegate:nil 
											  cancelButtonTitle:@"Dismiss"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];	
	}	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"trailer"];
	NSURL* videoURL = [NSURL URLWithString:myString];
	
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_1	
	MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
	[mp play];	
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
	MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
	if (mp)
	{
		self.moviePlayerViewController = mp;
		[mp release];
		[self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
		self.moviePlayerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
		[self.moviePlayerViewController.moviePlayer play];
	}
#endif
	
}


-(IBAction)done
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
