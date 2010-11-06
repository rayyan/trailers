
//  MovieViewController.m
//  Trailers
//
//  Created by Jonah Grant on 6/10/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//

#import "MovieViewController.h"
#import "MediaPlayer/MediaPlayer.h"
#import <QuartzCore/QuartzCore.h>
#import "Summary.h"
#import "TouchXML.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
#import "SA_OAuthTwitterEngine.h"
#import <EventKit/EventKit.h>
#import "TrailersAppDelegate.h"
#import "FacebookAgent.h"
#import "MBProgressHUD.h"
#import "ClearLabelsCellView.h"


#define kOAuthConsumerKey	@"Rx8gbVuNHVIkWIWH2aPgMw"		
#define kOAuthConsumerSecret	@"7R3445wSh252iHtHxZ5Pri8dMSNgAj7ctmwshBW27w"	
#define SCREEN_FRAME [[UIScreen mainScreen] applicationFrame]
#define TESTING_SECONDARY_USER @"jonahgrant"


@implementation MovieViewController
@synthesize popoverController;
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_3_1
@synthesize moviePlayerController;
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
@synthesize moviePlayerViewController;
#endif
@synthesize tableView;
@synthesize tableViewPad;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"fuckYouApple"];
		self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"Play Trailer" 
		 style:UIBarButtonSystemItemPlay 
		 target:self 
		 action:@selector(back)] autorelease];			
		 [self performSelector:@selector(addEvent) withObject:nil afterDelay:0.00];
	//[_engine sendUpdate:@"tessssstttt"];
		[[FacebookAgent sharedAgent] setDelegate:self];
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 65) 
											 style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight; 
	tableView.backgroundColor = [UIColor colorWithRed:202/255.0 green:208/255.0 blue:212/255.0 alpha:1];
	tableView.delegate = self;
	tableView.dataSource = self;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
	header = [[TKOverviewHeaderView alloc] init];
	[self.view addSubview:header];
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		tableViewPad.hidden = YES;	
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		tableView.hidden = YES;	
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
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex:(NSIndexPath *)indexPath {
	if (buttonIndex == 0)
	{
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"trailer"];
		NSURL* videoURL = [NSURL URLWithString:myString];
		MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
		[mp play];
	}	
}
- (void)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return 3;
	}
else {
	return 5;

}
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		if([indexPath section] == 0){
			height = 600.0;
		}
		if([indexPath section] == 1){
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			NSString *myString = [prefs stringForKey:@"description"];
			height = 70;
		}
		if([indexPath section] == 2){
			if (indexPath.row == 0) {
				height = 30.0;
			}
			else {
			height = 50.0;
			}
		}
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
	if([indexPath section] == 0){
		if (indexPath.row == 0) {
			height = 30.0;
		}
		if (indexPath.row == 1) {
			height = 70.0;
		}
	}
	if([indexPath section] == 1){
		height = 445.0;
	}
	if([indexPath section] == 2){
		height = 30.0;
	}
	if([indexPath section] == 3){
		height = 30.0;
	}
		if([indexPath section] == 4){
			if (indexPath.row == 0) {
				height = 30.0;
			}
			else {
				height = 35.0;

			}
		}
		if ([indexPath section] == 5) {
			if (indexPath.row == 0) {
				height = 30.0;
			}
			else {
				height = 50.0;
			}
		}
	}
	return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	

	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		if (section == 2) {
			return 3;
		}
		else {
			return 1;
		}
	}
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
		if (section == 4) {
			return 5;
		}
		if (section == 3) {
			return 2;
		}
		if (section == 2) {
			return 2;
		}
		if (section == 5) {
			return 2;
		}
		if (section == 0) {
			return 2;
		}
		else {
			return 1;
		}
	}
}
-(void)addAlert
{
	UILocalNotification* alarm = [[[UILocalNotification alloc] init] autorelease];
    if (alarm)
    {
        alarm.fireDate = movieReleaseDate;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *_movieName = [prefs stringForKey:@"title"];
        alarm.alertBody = [NSString stringWithFormat:@"%@ comes out in theaters today!", _movieName];
		UIApplication* app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:alarm];
		NSLog(@"worked");
    }	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"title"];
	NSString *myString1 = [prefs stringForKey:@"description"];
	NSString *myString2 = [prefs stringForKey:@"director"];
	NSString *myString3 = [prefs stringForKey:@"poster"];
	NSString *rating = [prefs stringForKey:@"rating"];
	NSString *runtime = [prefs stringForKey:@"copyright"];
	NSString *myString4 = [prefs stringForKey:@"genre"];
	NSString *releaseDate = [prefs stringForKey:@"releaseDate"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [dateFormatter dateFromString:[prefs stringForKey:@"releasedate"]];
	NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
	NSString *theDate = [_dateFormatter stringFromDate:date];
	movieReleaseDate = date;
	NSLog(@"%@",movieReleaseDate);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		static NSString *CellIdentifier = @"CustomAppCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		
		switch(indexPath.section)
		{
			case 0:
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.textLabel.text = myString ;
				[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
				cell.textLabel.numberOfLines = 0;
				[cell.textLabel sizeToFit];
				cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
				cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
				[cell.detailTextLabel setLineBreakMode:UILineBreakModeWordWrap];
				cell.detailTextLabel.numberOfLines = 0;
				[cell.detailTextLabel sizeToFit];
				cell.detailTextLabel.text = [NSString stringWithFormat:@"Director: %@\nRelease Date: %@\n\n\n\n\n\n",myString2, theDate];
				NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
				NSString *string = [prefs stringForKey:[NSString stringWithFormat:@"loaded:%@", myString]];
				if ([string isEqualToString:@"NO"]) {
					NSData  *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:myString3]];
					[prefs setObject:imageData forKey:[NSString stringWithFormat:@"poster:%@", myString]];
					NSLog(@"%@",[prefs stringForKey:[NSString stringWithFormat:@"poster:%@", myString]]);
					UIImage *image = [[UIImage alloc] initWithData:imageData];
					[cell.imageView setImage:image];
					[imageData release];
					[image release];
					[prefs setObject:@"YES" forKey:[NSString stringWithFormat:@"loaded:%@", myString]];
				}
				if ([string isEqualToString:@"YES"]) {
					NSData *imageData;
					imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"poster:%@",myString]];
					UIImage *poster = [[UIImage alloc] initWithData:imageData];
					[cell.imageView setImage:poster];
					[imageData retain];
					[poster release];				
				}
				cell.imageView.layer.masksToBounds = YES;
				CALayer * layer = [cell.imageView layer];
				[layer setMasksToBounds:YES];
				[layer setCornerRadius:8.6];
				[layer setBorderColor:[[UIColor clearColor] CGColor]];
				if ([rating isEqualToString:@"G"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"Rated_G.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 46.0, 40.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}
				if ([rating isEqualToString:@"PG"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"Rated_PG.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 54.0, 25.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}		
				if ([rating isEqualToString:@"PG-13"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"Rated_PG-13.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 66.0, 20.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}		
				if ([rating isEqualToString:@"R"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"Rated_R.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 30.0, 28.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}
				if ([rating isEqualToString:@"Not yet rated"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"Rated_NOT_YET_RATED.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 110.0, 27.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}
				if ([rating isEqualToString:@"NR"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"Rated_NOT_YET_RATED.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 110.0, 27.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}
				if ([rating isEqualToString:@"NYR"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"Rated_NOT_YET_RATED.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 110.0, 27.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}
				if ([rating isEqualToString:@"Unrated"]) {
					UIImage *accessoryImage = [UIImage imageNamed:@"UNRATED.png"];
					UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
					accImageView.userInteractionEnabled = YES;
					[accImageView setFrame:CGRectMake(0, 0, 130.0, 40.0)];
					cell.accessoryView = accImageView;
					[accImageView release];	  
				}
				break;
			case 1:
				if (indexPath.row == 0) {
					cell.textLabel.text = [NSString stringWithFormat:@"Summary"];
					cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
														   green:230.0/255.0
															blue:233.0/255.0
														   alpha:1];
					cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
															   green:143.0/255.0
																blue:155.0/255.0
															   alpha:1];
					cell.textLabel.shadowColor = [UIColor whiteColor];
					cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);	
					cell.accessoryType = UITableViewCellAccessoryNone;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				}
				if (indexPath.row == 1) {
					NSRange stringRange = {0,100};
					NSString *myString1 = [prefs stringForKey:@"description"];
					myString1 = [myString1 substringWithRange:stringRange];
					NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
					cell.textLabel.text = finalInfo;
					[cell.textLabel sizeToFit];
					cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
					cell.textLabel.numberOfLines = 0;
					
				}				
				[cell.textLabel sizeToFit];
				cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
				cell.textLabel.numberOfLines = 0;
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				break;
			case 2:
				if (indexPath.row == 0) {
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					cell.textLabel.text = @"Sharing";
					cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
														   green:230.0/255.0
															blue:233.0/255.0
														   alpha:1];
					cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
															   green:143.0/255.0
																blue:155.0/255.0
															   alpha:1];
					cell.textLabel.shadowColor = [UIColor whiteColor];
					cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);	
					cell.accessoryType = UITableViewCellAccessoryNone;
				}
				if (indexPath.row == 1) {
					cell.textLabel.text = [NSString stringWithFormat:@"Share via Twitter"];
					cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				}
				if (indexPath.row == 2) {
					cell.textLabel.text = [NSString stringWithFormat:@"Share via Email"];
					cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				}
				[cell.textLabel sizeToFit];
				cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
				cell.textLabel.numberOfLines = 0;
				
				
				
		}
		return cell;

	}
	else {
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (indexPath.section == 4) {
			cell = [[[ClearLabelsCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

		}
		else
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

		}
	switch(indexPath.section)
	{
		
		case 0:
			if (indexPath.row == 0) {
				cell.textLabel.text = [NSString stringWithFormat:@"Summary"];
				cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
													   green:230.0/255.0
														blue:233.0/255.0
													   alpha:1];
				cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
														   green:143.0/255.0
															blue:155.0/255.0
														   alpha:1];
				cell.textLabel.shadowColor = [UIColor whiteColor];
				cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);	
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			if (indexPath.row == 1) {
				NSRange stringRange = {0,130};
				NSString *myString1 = [prefs stringForKey:@"description"];
				myString1 = [myString1 substringWithRange:stringRange];
				NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
				cell.textLabel.text = finalInfo;
				[cell.textLabel sizeToFit];
				cell.textLabel.font = [UIFont systemFontOfSize:12];
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
				cell.textLabel.numberOfLines = 0;
				
			}
			break;
		case 1:
			NSLog(@"");
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			NSString *string = [prefs stringForKey:[NSString stringWithFormat:@"loaded:%@", myString]];
			if ([string isEqualToString:@"NO"]) {
				NSData  *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:myString3]];
				[prefs setObject:imageData forKey:[NSString stringWithFormat:@"poster:%@", myString]];
				NSLog(@"%@",[prefs stringForKey:[NSString stringWithFormat:@"poster:%@", myString]]);
				UIImage *image = [[UIImage alloc] initWithData:imageData];
				[cell.imageView setImage:image];
				[imageData release];
				[image release];
				[prefs setObject:@"YES" forKey:[NSString stringWithFormat:@"loaded:%@", myString]];
			}
			if ([string isEqualToString:@"YES"]) {
				NSData *imageData;
				imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"poster:%@",myString]];
				UIImage *poster = [[UIImage alloc] initWithData:imageData];
				[cell.imageView setImage:poster];
				[imageData retain];
				[poster release];				
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.imageView.layer.masksToBounds = YES;
			cell.imageView.layer.cornerRadius = 7.0;
			CALayer * layer = [cell.imageView layer];
			[layer setMasksToBounds:YES];
			[layer setCornerRadius:8.6];
			[layer setBorderWidth:0.0];
			[layer setBorderColor:[[UIColor clearColor] CGColor]];
			cell.backgroundColor = [UIColor clearColor];
			break;
		case 2:
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
			cell.accessoryType = UITableViewCellAccessoryNone;
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Runtime";
					cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
														   green:230.0/255.0
															blue:233.0/255.0
														   alpha:1];
					cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
															   green:143.0/255.0
																blue:155.0/255.0
															   alpha:1];
					cell.textLabel.shadowColor = [UIColor whiteColor];
					cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
					break;
				case 1:
					cell.textLabel.text = runtime;
					cell.detailTextLabel.text = nil;
					cell.imageView.image = [UIImage imageNamed:nil];
					break;
				default:
					break;
			}
			break;
		case 3:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Release Date";
					cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
														   green:230.0/255.0
															blue:233.0/255.0
														   alpha:1];
					cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
															   green:143.0/255.0
																blue:155.0/255.0
															   alpha:1];
					cell.textLabel.shadowColor = [UIColor whiteColor];
					cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
					break;
					case 1:
					cell.textLabel.text = theDate;
						break;
				default:
					break;
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.detailTextLabel.text = nil;
			cell.accessoryView = UITableViewCellAccessoryNone;
			break;
			case 4:
				switch (indexPath.row) {
					case 0:
						cell.selectionStyle = UITableViewCellSelectionStyleNone;
						cell.textLabel.text = @"Sharing";
						cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
															   green:230.0/255.0
																blue:233.0/255.0
															   alpha:1];
						cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
																   green:143.0/255.0
																	blue:155.0/255.0
																   alpha:1];
						cell.textLabel.shadowColor = [UIColor whiteColor];
						cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);				
						break;
					case 1:
						cell.textLabel.text = @"Twitter";
						cell.imageView.layer.masksToBounds = YES;
						cell.imageView.layer.cornerRadius = 7.0;
						CALayer * layer = [cell.imageView layer];
						[layer setMasksToBounds:YES];
						[layer setCornerRadius:8.6];
						[layer setBorderWidth:0.0];
						[layer setBorderColor:[[UIColor clearColor] CGColor]];
						
						break;
						case 2:
						cell.textLabel.text = @"Email";
						cell.imageView.layer.masksToBounds = YES;
						cell.imageView.layer.cornerRadius = 7.0;	
						break;
						case 3:
						cell.textLabel.text = @"SMS";			
						cell.imageView.layer.masksToBounds = YES;
						cell.imageView.layer.cornerRadius = 7.0;
						break;
						case 4:
							cell.textLabel.text = @"Facebook";
						cell.imageView.layer.masksToBounds = YES;
						cell.imageView.layer.cornerRadius = 7.0;
							break;
						case 5:
						cell.selectionStyle = UITableViewCellSelectionStyleNone;
						cell.textLabel.text = @"Related Links"; // NONE OF THIS MADE IT INTO THE FINAL BUILD, SO DO NOT EXPECT TO SEE THIS INSIDE THE APPLICATION
						cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
															   green:230.0/255.0
																blue:233.0/255.0
															   alpha:1];
						cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
																   green:143.0/255.0
																	blue:155.0/255.0
																   alpha:1];
						cell.textLabel.shadowColor = [UIColor whiteColor];
						cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);	
							break;
						case 6:
							cell.textLabel.text = @"IMDb";
							break;
					case 7:
						cell.textLabel.text = @"Netflix";
						break;
					case 8:
						cell.textLabel.text = @"Rotten Tomatoes";
						break;
					case 9:
						cell.textLabel.text = @"Yahoo! Movies";
						break;



						
						break;
					

				}				
		break;
	}  
		if (indexPath.section == 6)
		{
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Advertisement";
					cell.backgroundColor = [UIColor colorWithRed:227.0/255.0
														   green:230.0/255.0
															blue:233.0/255.0
														   alpha:1];
					cell.textLabel.textColor = [UIColor colorWithRed:132.0/255.0
															   green:143.0/255.0
																blue:155.0/255.0
															   alpha:1];
					cell.textLabel.shadowColor = [UIColor whiteColor];
					cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);		
					break;
				case 1:
					[cell addSubview:iAd];
					CALayer *layer = [iAd layer];
					[iAd.layer setMasksToBounds:YES];
					iAd.layer.masksToBounds = YES;
					[iAd.layer setFrame:CGRectMake(10,00,18.0,50.0)];
					[iAd.layer setBounds:CGRectMake(10,00,18.0,50.0)];

					break;
					
				default:
					break;
			}
			
		}
		return cell;

	}

}
-(void)addEvent
{
	// To add an event to the address book.  Never got around to finishing this.
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *releaseDate = [prefs stringForKey:@"releaseDate"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [dateFormatter dateFromString:[prefs stringForKey:@"releasedate"]];
	NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
	NSString *theDate = [_dateFormatter stringFromDate:date];
	NSDate *endDate = [_dateFormatter dateFromString:theDate];
	

}
-(void)beforeTweet
{
	if (_engine) return;
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	
	UIViewController	*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
		[self performSelector:@selector(tweet) withObject:nil afterDelay:0.20];
	}
		
}
- (NSString *)tableView:(UITableView *)tblView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionName = nil;
	
	switch(section)
	{
		case 0:
			sectionName = [NSString stringWithString:@""];
			break;
		case 1:
			sectionName = [NSString stringWithString:@""];
			break;
		case 2:
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			{
				sectionName = [NSString stringWithString:@""]; 
				break;
			}
			else {
	sectionName = [NSString stringWithString:@""];
						break;
				}

		case 3:
			sectionName = [NSString stringWithString:@""];
			break;
			case 4:
			sectionName = [NSString stringWithString:@""];
				break;

	}


	return sectionName;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"runtime"];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {	
	switch (section)
		{
				case 4:
					return myString;
					break;
			default:
				return @"";
			break;
				
		}
	}
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
	switch (section)
	{
			case 2:
				return myString;
				break;
		case 3:
			return @"";
			break;
			
		default:
			return @"";
			break;
	}
		}
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch(indexPath.section)
	{
		
		case 0:
			NSLog(@"");
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				Summary *summary = [[Summary alloc] initWithNibName:@"Summary" bundle:nil];
				[self.navigationController pushViewController:summary animated:YES];
				[summary release];	
			}
			break;
			case 1:
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				Summary *myVC = [[Summary alloc]initWithNibName:@"Summary" bundle:nil];
				myVC.modalPresentationStyle = UIModalPresentationFormSheet;
				[self presentModalViewController:myVC animated:YES];
				[myVC release];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				
			}
			break;
			case 2:
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				if (indexPath.row == 1) {
					if (_engine) return;
					_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
					_engine.consumerKey = kOAuthConsumerKey;
					_engine.consumerSecret = kOAuthConsumerSecret;
					
					UIViewController	*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
					
					if (controller) 
						[self presentModalViewController: controller animated: YES];
					else {
						[tableView deselectRowAtIndexPath:indexPath animated:YES];
						[self performSelector:@selector(tweet) withObject:nil afterDelay:0.20];
					}
				}
				if (indexPath.row == 2) {
					[self showPicker];
					[tableView deselectRowAtIndexPath:indexPath animated:YES];
				}
			}
			break;
			case 4:
			if (indexPath.row == 2) {
				[self showPicker];
				
			}
			if(indexPath.row == 4) {
				[[FacebookAgent sharedAgent] login]; 
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
			}
			if (indexPath.row == 1) {
				if (_engine) return;
				_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
				_engine.consumerKey = kOAuthConsumerKey;
				_engine.consumerSecret = kOAuthConsumerSecret;
				
				UIViewController	*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
				
				if (controller) 
					[self presentModalViewController: controller animated: YES];
				else {
					[tableView deselectRowAtIndexPath:indexPath animated:YES];
					[self performSelector:@selector(tweet) withObject:nil afterDelay:0.20];
				}
			}
			if (indexPath.row == 3) {
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
				message.messageComposeDelegate = self;
				NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
				NSString *trailer = [prefs stringForKey:@"trailer"];
				NSString *movieName = [prefs stringForKey:@"title"];
				NSString *myString = [prefs stringForKey:@"title"];
				NSString *_name = [prefs stringForKey:@"title"];
				NSString *studio = [prefs stringForKey:@"studio"];
				myString = [myString lowercaseString];
				NSString *noSpaces = [[myString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @""];
				noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@":" withString:@""];
				noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"'" withString:@""];
				noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"-" withString:@""];
				noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"," withString:@""];
				NSLog(@"%@", noSpaces);
				if ([studio isEqualToString:@"Walt Disney Pictures"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/disney/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Paramount Vantage"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/paramount_vantage/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
					
				}
				if ([studio isEqualToString:@"20th Century Fox"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/fox/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"DreamWorks"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/dreamworks/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Focus Features"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/focus_features/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"IFC Films"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/independent/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"IMAX Corporation"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/imax/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Lionsgate"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/lions_gate/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Magnolia Pictures"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/magnolia/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"MGM Studios "]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/mgm/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Miramax Films "]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/miramax/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"New Line Cinema"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/newline/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Paramount Pictures"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/paramount/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Summit Entertainment"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/summit/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Touchstone Pictures"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/touchstone/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Universal Pictures"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/universal/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Warner Bros. Pictures"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/wb/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Sony Pictures Classics"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/sony/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
				}
				if ([studio isEqualToString:@"Sony Pictures"]) {
					NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/sony_pictures/%@", noSpaces];
					NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
					NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																  encoding:NSASCIIStringEncoding
																	 error:nil];
					message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					isIndenendent = NO;
					
					if ([studio isEqualToString:@"Weinstein Company"]) {
						NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/weinstein/%@", noSpaces];
						NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
						NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																	  encoding:NSASCIIStringEncoding
																		 error:nil];
						message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
						isIndenendent = NO;
					}
					
					else if (isIndenendent) {
						NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/independent/%@", noSpaces];
						NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@", trailerURL];
						NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
																	  encoding:NSASCIIStringEncoding
																		 error:nil];
						message.body = [NSString stringWithFormat:@"Hey! Check out the movie trailer for %@: %@", movieName, shortURL ];
					}
				
					
				}
			
				
				
				[self presentModalViewController:message animated:YES];
			}
			if (indexPath.row == 6) {
				NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
				NSString *imdbURL = [NSString stringWithFormat:@"http://imdb.com/find?q=%@", [prefs stringForKey:@"title"]];
				NSURL *imdbNSURL = [NSURL URLWithString:imdbURL];	
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://imdb.com/find?q=%@"]];
			}
			if (indexPath.row == 7) {
				NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
				NSString *_imdbURL = [NSString stringWithFormat:@"http://www.netflix.com/Search?v1=%@", [prefs stringForKey:@"title"]];
				NSURL *_imdbNSURL = [NSURL URLWithString:_imdbURL];	
				[[UIApplication sharedApplication] openURL:_imdbNSURL];
			}
				break;
	
	}
}
// override delegate methods of FacebookAgentDelegate


-(void)tweet
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"title"];
	NSString *_name = [prefs stringForKey:@"title"];
	NSString *trailer = [prefs stringForKey:@"trailer"];
	NSString *studio = [prefs stringForKey:@"studio"];
	NSLog(@"%@",studio);
	myString = [myString lowercaseString];
	NSString *noSpaces = [[myString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@":" withString:@""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"'" withString:@""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"-" withString:@""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"," withString:@""];
	[_engine enableUpdatesFor:TESTING_SECONDARY_USER];
	if ([studio isEqualToString:@"Walt Disney Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/disney/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		NSLog(@"%@", link);
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		[_engine enableUpdatesFor:TESTING_SECONDARY_USER];

	}
	if ([studio isEqualToString:@"Paramount Vantage"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/paramount_vantage/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];

		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		[_engine enableUpdatesFor:TESTING_SECONDARY_USER];

		
	}
	if ([studio isEqualToString:@"20th Century Fox"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/fox/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];

		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		[_engine enableUpdatesFor:TESTING_SECONDARY_USER];

	}
	if ([studio isEqualToString:@"DreamWorks"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/dreamworks/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Focus Features"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/focus_features/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"IFC Films"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/independent/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"IMAX Corporation"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/imax/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Lionsgate"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/lions_gate/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Magnolia Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/magnolia/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"MGM Studios "]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/mgm/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Miramax Films "]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/miramax/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"New Line Cinema"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/newline/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Paramount Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/paramount/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Summit Entertainment"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/summit/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Touchstone Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/touchstone/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Universal Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/universal/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Warner Bros. Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/wb/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Sony Pictures Classics"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/sony/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Sony Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/sony_pictures/%@", noSpaces];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
		NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
		isIndenendent = NO;
		
		if ([studio isEqualToString:@"Weinstein Company"]) {
			NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/weinstein/%@", noSpaces];
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
			NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
			[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];
			isIndenendent = NO;
		}
		
		else if (isIndenendent) {
			NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/independent/%@", noSpaces];
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", trailerURL]];
			NSString *link = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];

			[_engine sendUpdate: [NSString stringWithFormat: @"Check out the movie trailer for %@: %@.", _name, link]];					
		}
		
	}
}
-(void)stopAnimating:(NSIndexPath*)indexPath
{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username:(NSIndexPath*)indexPath {
	NSLog(@"Authenicated for %@", username);
	[_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier{
	NSLog(@"Request %@ succeeded", requestIdentifier);
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeCustomView;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Completed";
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];	
 }
-(void)addSucessHUD
{
	
}
- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
		usleep(50000);

    }
}
- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
													message:@"Tweet failed.  Please try again." 
												   delegate:nil 
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

//=============================================================================================================================

-(void)showPicker
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
			[self displayComposerSheet];
	}
}

#pragma mark -
#pragma mark Compose Mail

-(void)displayComposerSheet 
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"title"];
	NSString *myString1 = [prefs stringForKey:@"description"];
	NSString *myString2 = [prefs stringForKey:@"director"];
	NSString *genre = [prefs stringForKey:@"genre"];
	NSString *trailer = [prefs stringForKey:@"trailer"];

	MFMailComposeViewController *mfcontroller = [[MFMailComposeViewController alloc] init];
	mfcontroller.mailComposeDelegate = self;
	NSLog(@"delegate:%@", mfcontroller.delegate);
	NSString *apiEndpoint = [NSString stringWithFormat:@"http://api.tr.im/v1/trim_simple?url=%@",trailer];
	NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
												  encoding:NSASCIIStringEncoding
													 error:nil];
	[mfcontroller setSubject: @"Found a pretty cool movie trailer"];
	[mfcontroller setMessageBody:[NSString stringWithFormat:@"Hey! \n\n	I found a pretty cool movie trailer using Previews (http://jonahgrant.com/previews). It's called %@ and it's directed by %@.  It's a %@ movie. \n\n Check out the preview here: %@",myString,myString2, genre, shortURL] isHTML:NO];
	[self presentModalViewController:mfcontroller animated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{		
	[self dismissModalViewControllerAnimated:YES];
}
#pragma mark FacebookAgentDelegate
- (void) facebookAgent:(FacebookAgent*)agent statusChanged:(BOOL) success{}
- (void) facebookAgent:(FacebookAgent*)agent didLoadInfo:(NSDictionary*) info{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *myString = [prefs stringForKey:@"title"];
	NSString *_name = [prefs stringForKey:@"title"];
	NSString *trailer = [prefs stringForKey:@"trailer"];
	NSString *studio = [prefs stringForKey:@"studio"];
	NSLog(@"%@",studio);
	myString = [myString lowercaseString];
	NSString *noSpaces = [[myString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString: @""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@":" withString:@""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"'" withString:@""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"-" withString:@""];
	noSpaces = [noSpaces stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSLog(@"%@", noSpaces);
	if ([studio isEqualToString:@"Walt Disney Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/disney/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Paramount Vantage"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/paramount_vantage/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;		
		
	}
	if ([studio isEqualToString:@"20th Century Fox"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/fox/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"DreamWorks"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/dreamworks/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;		
	}
	if ([studio isEqualToString:@"Focus Features"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/focus_features/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;		
	}
	if ([studio isEqualToString:@"IFC Films"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/independent/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"IMAX Corporation"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/imax/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;		
	}
	if ([studio isEqualToString:@"Lionsgate"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/lions_gate/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Magnolia Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/magnolia/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;		
	}
	if ([studio isEqualToString:@"MGM Studios "]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/mgm/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Miramax Films "]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/miramax/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;		
	}
	if ([studio isEqualToString:@"New Line Cinema"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/newline/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Paramount Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/paramount/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];	
		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Summit Entertainment"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/summit/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Touchstone Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/touchstone/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Universal Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/universal/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Warner Bros. Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/wb/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Sony Pictures Classics"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/sony/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];		isIndenendent = NO;
		
	}
	if ([studio isEqualToString:@"Sony Pictures"]) {
		NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/sony_pictures/%@", noSpaces];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *myString = [prefs stringForKey:@"title"];
		NSRange stringRange = {0,200};
		NSString *myString1 = [prefs stringForKey:@"description"];
		myString1 = [myString1 substringWithRange:stringRange];
		NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
		[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
											 captionText:finalInfo
												imageurl:[prefs stringForKey:@"poster"]
												 linkurl:trailerURL
									   userMessagePrompt:@"Whats on your mind?"
											 actionLabel:@"Found via"
											  actionText:@"Trailers for iOS"
											  actionLink:@"http://jonahgrant.com/trailers"];		isIndenendent = NO;
		
		if ([studio isEqualToString:@"Weinstein Company"]) {
			NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/weinstein/%@", noSpaces];
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			NSString *myString = [prefs stringForKey:@"title"];
			NSRange stringRange = {0,200};
			NSString *myString1 = [prefs stringForKey:@"description"];
			myString1 = [myString1 substringWithRange:stringRange];
			NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
			[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
												 captionText:finalInfo
													imageurl:[prefs stringForKey:@"poster"]
													 linkurl:trailerURL
										   userMessagePrompt:@"Whats on your mind?"
												 actionLabel:@"Found via"
												  actionText:@"Trailers for iOS"
												  actionLink:@"http://jonahgrant.com/trailers"];			isIndenendent = NO;
		}
		
		else if (isIndenendent) {
			NSString *trailerURL = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/independent/%@", noSpaces];
			NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
			NSString *myString = [prefs stringForKey:@"title"];
			NSRange stringRange = {0,200};
			NSString *myString1 = [prefs stringForKey:@"description"];
			myString1 = [myString1 substringWithRange:stringRange];
			NSString *finalInfo = [NSString stringWithFormat:@"%@...", myString1];
			[[FacebookAgent sharedAgent] publishFeedWithName:[NSString stringWithFormat:@"Check out the movie trailer for %@", myString]
												 captionText:finalInfo
													imageurl:[prefs stringForKey:@"poster"]
													 linkurl:trailerURL
										   userMessagePrompt:@"Whats on your mind?"
												 actionLabel:@"Found via"
												  actionText:@"Trailers for iOS"
												  actionLink:@"http://jonahgrant.com/trailers"];			
		}
		
	}
	
	
}
- (void) facebookAgent:(FacebookAgent*)agent didLoadFriendList:(NSArray*) data onlyAppUsers:(BOOL)yesOrNo{}
- (void) facebookAgent:(FacebookAgent*)agent didLoadPermissions:(NSArray*) data{}
- (void) facebookAgent:(FacebookAgent*)agent didLoadFQL:(NSArray*) data{}
- (void) facebookAgent:(FacebookAgent*)agent permissionGranted:(FacebookAgentPermission)permission{}
- (void) facebookAgent:(FacebookAgent*)agent photoUploaded:(NSString*) pid{}
- (void) facebookAgent:(FacebookAgent*)agent requestFaild:(NSString*) message{}
- (void) facebookAgent:(FacebookAgent*)agent loginStatus:(BOOL) loggedIn{}
- (void) facebookAgent:(FacebookAgent*)agent dialog:(FBDialog*)dialog didFailWithError:(NSError*)error{}

	
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end
@interface UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size;
@end

@implementation UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
