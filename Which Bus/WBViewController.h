//
//  WBViewController.h
//  Which Bus
//
//  Created by Joe Schulman on 1/19/13.
//  Copyright (c) 2013 Which Bus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WBViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain, readwrite) NSArray* baseDomains;
@property (nonatomic, retain, readwrite) NSString* defaultUrl;
@property (nonatomic, retain, readwrite) NSString* directionUrlFormatter;
@property (nonatomic, retain, readwrite) NSString* directionFromHereUrlFormatter;
@property (nonatomic, retain, readwrite) NSString* directionToHereUrlFormatter;
@property (nonatomic, retain, readwrite) IBOutlet UIWebView* mWebView;

- (void) getDirectionsFrom: (CLLocation*) source To: (CLLocation*) dest;
- (void) getDirectionsFromHereTo: (CLLocation*) dest;
- (void) getDirectionsToHereFrom: (CLLocation*) source;

@end
