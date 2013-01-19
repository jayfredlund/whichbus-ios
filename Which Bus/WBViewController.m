//
//  WBViewController.m
//  Which Bus
//
//  Created by Joe Schulman on 1/19/13.
//  Copyright (c) 2013 Which Bus, LLC. All rights reserved.
//

#import "WBViewController.h"

@interface WBViewController ()

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.defaultUrl = @"http://www.whichbus.org";
    self.directionUrlFormatter = @"http://www.whichbus.org/plan/%f,%f/%f,%f";
    self.directionFromHereUrlFormatter = @"http://www.whichbus.org/plan/here/%f,%f";
    self.directionToHereUrlFormatter = @"http://www.whichbus.org/plan/%f,%f/here";
    self.baseDomains = [NSArray arrayWithObjects:
                        @"error.html",@"www.whichbus.org", @"whichbus.org", @"dev.whichb.us", @"whichb.us", nil];
    
    // java-like craziness except in a smalltalk accent :)
    [self.mWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:self.defaultUrl]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Receiving request to navigate to host: %@", request.URL.host);
    if(request.URL == NULL || request.URL == nil || request.URL.host == nil)
    {
        // NULL for offline cases
        NSLog(@"Approving empty navigation");
        return YES;
    }
    for(NSString* baseDomain in self.baseDomains)
    {
        NSComparisonResult result = [baseDomain compare:request.URL.host options:NSCaseInsensitiveSearch];
        if(result == NSOrderedSame)
        {
            NSLog(@"Approving navigation");
            return YES;
        }
    }
    // we'll let the system handle the off-site link
    NSLog(@"Declining offsite navigation");
    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Application failed to load...");
    if(error != NULL)
    {
        NSLog(@"%@",[error description]);
    }
    // if the page can't load, show an offline landing page
    NSString* errorPath = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html" inDirectory:@""];
    NSString* htmlString = [NSString stringWithContentsOfFile:errorPath encoding:NSUTF8StringEncoding error:nil];
    [self.mWebView loadHTMLString:htmlString baseURL:nil];
}
-(void)getDirectionsFrom:(CLLocation *)source To:(CLLocation *)dest
{
    NSString* directionsUrl = [NSString stringWithFormat:
                               self.directionUrlFormatter,
                               source.coordinate.latitude,
                               source.coordinate.longitude,
                               dest.coordinate.latitude,
                               dest.coordinate.longitude
                               ];
    NSLog(@"Attempting to navigate directions: %@", directionsUrl);
    [self.mWebView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString: directionsUrl ]
      ]
     ];
}
-(void)getDirectionsFromHereTo:(CLLocation *)dest
{
    NSString* directionsUrl = [NSString stringWithFormat:
                               self.directionFromHereUrlFormatter,
                               dest.coordinate.latitude,
                               dest.coordinate.longitude
                               ];
    NSLog(@"Attempting to navigate directions from here: %@", directionsUrl);
    [self.mWebView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString: directionsUrl ]
      ]
     ];
}
-(void)getDirectionsToHereFrom:(CLLocation *)source
{
    NSString* directionsUrl = [NSString stringWithFormat:
                               self.directionToHereUrlFormatter,
                               source.coordinate.latitude,
                               source.coordinate.longitude
                               ];
    NSLog(@"Attempting to navigate directions to here: %@", directionsUrl);
    [self.mWebView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString: directionsUrl ]
      ]
     ];
}

@end
