
//  RootViewController.m
//  Trailers
//
//  Created by Jonah Grant on 6/16/10.
//  Copyright Jonah Grant 2010. All rights reserved.
//


#import "RootViewController.h"
#import "TouchXML.h"
#import "MovieViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MovieViewController.h"
#import "GradientView.h"
#import "ClearLabelsCellView.h"
#import "Reachability.h"

@implementation RootViewController


@synthesize bannerView;
@synthesize tableView;
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[Reachability sharedReachability].hostName = @"jonahgrant.com";
	if ([[Reachability sharedReachability] remoteHostStatus] == NotReachable) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Detected"
														message:@"Please check your connection" 
													   delegate:nil 
											  cancelButtonTitle:nil
											  otherButtonTitles:nil];
		[alert show];
		[alert release];	
		bannerView.hidden = YES;	

	}	
	if ([[Reachability sharedReachability] remoteHostStatus] == ReachableViaWiFiNetwork | ReachableViaCarrierDataNetwork) {
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:HUD];
		HUD.delegate = self;
		HUD.labelText = @"Loading...";
		HUD.detailsLabelText = @"Downloading movie information";
		[HUD showWhileExecuting:@selector(load) onTarget:self withObject:nil animated:YES];
	alert = [[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[alert show];
	[alert setHidden:YES];
	[self performSelector:@selector(load) withObject:nil afterDelay:1.00];
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
		[self moveBannerViewOffScreen];
	}
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		CGRect originalTableFrame = self.tableView.frame;
		CGFloat newTableHeight = self.view.frame.size.height;
		CGRect newTableFrame = originalTableFrame;
		newTableFrame.size.height = newTableHeight;
		bannerView.hidden = YES;		
		self.tableView.frame = newTableFrame;
	}
	}
	self.title = @"Trailers";
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (NSString *)nibName
{
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		return @"RootViewControllerPad";
	}
	else if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
	return @"RootViewController";
	}
}
-(void)done
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionFade];
	[animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];	
	contentRows = [blogEntries count];
	[alert dismissWithClickedButtonIndex:0 animated:YES];	
}
-(void)load
{
	if([blogEntries count] == 0) {
        NSString *blogAddress = @"http://trailers.apple.com/trailers/home/xml/current_480p.xml";
        [self grabRSSFeed:blogAddress];
		[self _grabRSSFeed:blogAddress];
        [self __grabRSSFeed:blogAddress];
        [self ___grabRSSFeed:blogAddress];
        [self ____grabRSSFeed:blogAddress];
		[self _____grabRSSFeed:blogAddress];
		[self ______grabRSSFeed:blogAddress];
		[self _______grabRSSFeed:blogAddress];
		[self ________grabRSSFeed:blogAddress];
		[self _________grabRSSFeed:blogAddress];
		[self __________grabRSSFeed:blogAddress];
		[self ___________grabRSSFeed:blogAddress];

		[self.tableView reloadData];
	}
	[self performSelector:@selector(done) withObject:nil afterDelay:0.10];
	
	
}

-(void) grabRSSFeed:(NSString *)blogAddress {
    blogEntries = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/title" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [blogEntries addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) _grabRSSFeed:(NSString *)blogAddress {
    directors = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/director" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [directors addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) __grabRSSFeed:(NSString *)blogAddress {
    ratings = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/rating" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [ratings addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) ___grabRSSFeed:(NSString *)blogAddress {
    studios = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/studio" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [studios addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) ____grabRSSFeed:(NSString *)blogAddress {
    description = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/description" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [description addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) _____grabRSSFeed:(NSString *)blogAddress {
    trailers = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/preview/large" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [trailers addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) ______grabRSSFeed:(NSString *)blogAddress {
    posters = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/poster/xlarge" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [posters addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) _______grabRSSFeed:(NSString *)blogAddress {
}
-(void) ________grabRSSFeed:(NSString *)blogAddress {
    copyright = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/runtime" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [copyright addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) _________grabRSSFeed:(NSString *)blogAddress {
    runtime = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/copyright" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [runtime addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) __________grabRSSFeed:(NSString *)blogAddress {
	
    genre = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:1 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/genre/name" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [genre addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
-(void) ___________grabRSSFeed:(NSString *)blogAddress {
	
    releaseDate = [[NSMutableArray alloc] init];	
    NSURL *url = [NSURL URLWithString: blogAddress];
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:1 error:nil] autorelease];
    NSArray *resultNodes = NULL;
    resultNodes = [rssParser nodesForXPath:@"records/movieinfo/info/releasedate" error:nil];
    for (CXMLElement *resultElement in resultNodes) {
        NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
        int counter;
        for(counter = 0; counter < [resultElement childCount]; counter++) {
            [blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
		
        [releaseDate addObject:[blogItem copy]];
		NSLog(@"%@", [blogItem copy]);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 53;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height;
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
		return 58.0;
	}
	else {
		return 80.0;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		return 2;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return [blogEntries count]; 
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ClearLabelsCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[GradientView alloc] init] autorelease];
    }
	int blogEntryIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	cell.textLabel.text = [[blogEntries objectAtIndex:blogEntryIndex] objectForKey:@"text"];
	int directorIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int studioIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int ratingIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", 
								 [[ratings objectAtIndex:ratingIndex] objectForKey:@"text"],
								 [[directors objectAtIndex:directorIndex] objectForKey:@"text"],
								 [[studios objectAtIndex:studioIndex] objectForKey:@"text"]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	cell.textLabel.shadowColor = [UIColor whiteColor];
	cell.textLabel.shadowOffset = CGSizeMake(0,1);
	cell.detailTextLabel.shadowColor = [UIColor whiteColor];
	cell.detailTextLabel.shadowOffset = CGSizeMake(0,1);
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *name = [[blogEntries objectAtIndex:blogEntryIndex] objectForKey:@"text"];

    return cell;
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView
	 deselectRowAtIndexPath:indexPath animated:YES];
	[self performSelector:@selector(change) withObject:nil afterDelay:0.00 ];
	int blogEntryIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int infoIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int directorIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int trailerIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int posterIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int ratingIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int copyrightIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int runtimeIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	int genreIndex = [indexPath indexAtPosition: [indexPath length]  -1];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[[blogEntries objectAtIndex:blogEntryIndex] objectForKey: @"text"] forKey:@"title"];
	[prefs setObject:[[description objectAtIndex:infoIndex] objectForKey: @"text"] forKey:@"description"];
	[prefs setObject:[[directors objectAtIndex:directorIndex] objectForKey: @"text"] forKey:@"director"];
	[prefs setObject:[[trailers objectAtIndex:trailerIndex] objectForKey: @"text"] forKey:@"trailer"];
	[prefs setObject:[[posters objectAtIndex:posterIndex] objectForKey: @"text"] forKey:@"poster"];
	[prefs setObject:[[ratings objectAtIndex:ratingIndex] objectForKey: @"text"] forKey:@"rating"];
	[prefs setObject:[[copyright objectAtIndex:copyrightIndex] objectForKey: @"text"] forKey:@"copyright"];
	[prefs setObject:[[runtime objectAtIndex:runtimeIndex] objectForKey: @"text"] forKey:@"runtime"];
	[prefs setObject:[[genre objectAtIndex:genreIndex] objectForKey: @"text"] forKey:@"genre"];
	[prefs setObject:[[studios objectAtIndex:genreIndex] objectForKey:@"text"] forKey:@"studio"];
	[prefs setObject:[[releaseDate objectAtIndex:genreIndex] objectForKey: @"text"] forKey:@"releasedate"];
	NSString *string = [prefs stringForKey:[NSString stringWithFormat:@"loaded:%@", [[blogEntries objectAtIndex:blogEntryIndex] objectForKey:@"text"]]];
	if ([string isEqualToString:@"YES"]) {
	}
	else {
	[prefs setObject:@"NO" forKey:[NSString stringWithFormat:@"loaded:%@", [[blogEntries objectAtIndex:blogEntryIndex] objectForKey:@"text"]]];
	}

}
-(void)change
{
	MovieViewController *movieViewController = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
	[self.navigationController pushViewController:movieViewController animated:YES];
	[movieViewController release];
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	[self performSelector:@selector(moveBannerViewOnScreen) withObject:nil afterDelay:0.00];
	//[self moveBannerViewOnScreen];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    
}

- (void)bannerView:(ADBannerView *) didFailToReceiveAdWithError:(NSError *)error {
	[self moveBannerViewOffScreen];
}

-(void)moveBannerViewOffScreen
{
	CGRect originalTableFrame = self.tableView.frame;
	CGFloat newTableHeight = self.view.frame.size.height;
	CGRect newTableFrame = originalTableFrame;
	newTableFrame.size.height = newTableHeight;
	
	CGRect newBannerFrame = self.bannerView.frame;
	newBannerFrame.origin.y = newTableHeight;
	
	self.tableView.frame = newTableFrame;
	self.bannerView.frame = newBannerFrame;
}
-(void)moveBannerViewOnScreen
{
	CGRect newBannerFrame = self.bannerView.frame;
	newBannerFrame.origin.y = self.view.frame.size.height - newBannerFrame.size.height;
	
	CGRect originalTableViewFrame = self.tableView.frame;
	CGFloat newTableHeight = self.view.frame.size.height - newBannerFrame.size.height;
	CGRect newTableFrame = originalTableViewFrame;
	newTableFrame.size.height = newTableHeight;
	
	[UIView beginAnimations:@"BannerViewIntro" context:NULL];
	self.tableView.frame = newTableFrame;
	self.bannerView.frame = newBannerFrame;
	[UIView commitAnimations];
}
	
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
	bannerView.delegate = nil;
	[bannerView release];
    [super dealloc];
}


@end

