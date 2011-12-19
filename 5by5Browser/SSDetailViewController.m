//
//  SSDetailViewController.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "SSDetailViewController.h"
#import "MMHTTPClient.h"
#import "InstapaperCredentials.h"
#import "UIAlertView+marshmallows.h"

@interface SSDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation SSDetailViewController

@synthesize episode = _episode;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize webView = _webView;
@synthesize toolbar = _toolbar;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize instapaperButton = _instapaperButton;
@synthesize loadingView = _loadingView;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void) setEpisode: (Episode *)episode
{
    if (_episode != episode) {
        _episode = episode;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    if (self.episode) {
        self.title = self.episode.name;
        self.detailDescriptionLabel.text = self.episode.name;
        [self goHome: nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setInstapaperButton:nil];
    [self setToolbar:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) webViewDidStartLoad: (UIWebView *)webView
{
    [UIView animateWithDuration: 1.0 animations: ^{
        self.loadingView.alpha = 1.0;
    }];
}

- (void) webViewDidFinishLoad: (UIWebView *)webView
{
    [UIView animateWithDuration: 0.3 animations: ^{
        self.loadingView.alpha = 0.0;
    }];
    [self.backButton setEnabled: webView.canGoBack];
    [self.forwardButton setEnabled: webView.canGoForward];
}

- (IBAction) goHome: (id)sender
{
    [self.webView loadRequest: [NSURLRequest requestWithURL: self.episode.url]];
}

- (IBAction) sendToInstapaper: (id)sender
{
    NSString *url = self.webView.request.URL.absoluteString;
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            kInstapaperUser, @"username",
                            kInstapaperPassword, @"password",
                            url, @"url",
                            nil];

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [indicatorView startAnimating];
    UIBarButtonItem *indicatorItem = [[UIBarButtonItem alloc] initWithCustomView: indicatorView];
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    NSInteger i = [items indexOfObject: self.instapaperButton];
    [items replaceObjectAtIndex: i withObject: indicatorItem];
    [self.toolbar setItems: items];
    [MMHTTPClient post: @"https://www.instapaper.com/api/add" fields: fields then: ^(NSInteger status, id data) {
        [items replaceObjectAtIndex: i withObject: self.instapaperButton];
        [self.toolbar setItems: items];
        if (status != 201) {
            [UIAlertView showAlertWithTitle: @"Error" message: @"Failed to send to Instapaper. Try again later."];
        }
    }];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Shows";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
