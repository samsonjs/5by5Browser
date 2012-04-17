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

// Private API
@interface SSDetailViewController ()
{
    UIBarButtonItem *_showsButton;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property BOOL isLoading;

- (void) configureView;

@end


@implementation SSDetailViewController

@synthesize episode = _episode;
@synthesize webView = _webView;
@synthesize toolbar = _toolbar;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize instapaperButton = _instapaperButton;
@synthesize loadingView = _loadingView;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize isLoading = _isLoading;

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

- (void) configureView
{
    if (self.episode) {
        self.title = self.episode.name;
    }
    else {
        self.title = @"5by5";
    }
    [self goHome: nil];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self configureView];

    if (_showsButton) {
        NSMutableArray *items = [[self.toolbar items] mutableCopy];
        [items insertObject: _showsButton atIndex: 0];
        [self.toolbar setItems: items animated: YES];
        _showsButton = nil;
    }
}

- (void) viewDidUnload
{
    [self setWebView:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setInstapaperButton:nil];
    [self setToolbar:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (BOOL) webView: (UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType
{
    self.isLoading = navigationType == UIWebViewNavigationTypeOther ? self.isLoading : YES;
    return YES;
}

- (void) webViewDidStartLoad: (UIWebView *)webView
{
    if (self.isLoading) {
        [UIView animateWithDuration: 1.0 animations: ^{
            self.loadingView.alpha = 1.0;
        }];
    }
}

- (void) webViewDidFinishLoad: (UIWebView *)webView
{
    self.isLoading = NO;
    [UIView animateWithDuration: 0.3 animations: ^{
        self.loadingView.alpha = 0.0;
    }];
    [self.backButton setEnabled: webView.canGoBack];
    [self.forwardButton setEnabled: webView.canGoForward];

    // Custom CSS for iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.webView stringByEvaluatingJavaScriptFromString: @"var s5 = document.createElement('script');s5.async = true;s5.src = 'http://samhuri.net/f/fiveshift.js';var s = document.getElementsByTagName('script')[0];s.parentNode.insertBefore(s5, s)"];
    }
}

- (IBAction) goHome: (id)sender
{
    // Show the loading animation
    self.isLoading = YES;
    NSURL *url = self.episode ? self.episode.url : [NSURL URLWithString: @"http://5by5.tv"];
    if (![url isEqual: self.webView.request.URL]) {
        [self.webView loadRequest: [NSURLRequest requestWithURL: url]];
    }
}

- (void) sendURLToInstapaper: (NSString *)url
{
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

- (IBAction) sendToInstapaper: (id)sender
{
    [self sendURLToInstapaper: self.webView.request.URL.absoluteString];
}

#pragma mark - Split view

- (void) splitViewController: (UISplitViewController *)splitController
      willHideViewController: (UIViewController *)viewController
           withBarButtonItem: (UIBarButtonItem *)barButtonItem
        forPopoverController: (UIPopoverController *)popoverController
{
    if (self.toolbar) {
        NSMutableArray *items = [[self.toolbar items] mutableCopy];
        [items insertObject: barButtonItem atIndex: 0];
        [self.toolbar setItems: items animated: YES];
    }
    else {
        _showsButton = barButtonItem;
    }
    self.masterPopoverController = popoverController;
}

- (void) splitViewController: (UISplitViewController *)splitController
      willShowViewController: (UIViewController *)viewController
   invalidatingBarButtonItem: (UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObject: barButtonItem];
    [self.toolbar setItems: items animated: YES];
    self.masterPopoverController = nil;
}

@end
