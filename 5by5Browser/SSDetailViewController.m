//
//  SSDetailViewController.m
//  5by5Browser
//
//  Created by Sami Samhuri on 11-12-17.
//  Copyright (c) 2011 Guru Logic. All rights reserved.
//

#import "SSDetailViewController.h"

@interface SSDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation SSDetailViewController

@synthesize episode = _episode;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize webView = _webView;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
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
    // Update the user interface for the detail item.

    if (self.episode) {
        self.title = self.episode.name;
        self.detailDescriptionLabel.text = self.episode.name;
        [self.webView loadRequest: [NSURLRequest requestWithURL: self.episode.url]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
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

- (void) webViewDidFinishLoad: (UIWebView *)webView
{
    [self.backButton setEnabled: webView.canGoBack];
    [self.forwardButton setEnabled: webView.canGoForward];
}

- (IBAction) goHome
{
    while (self.webView.canGoBack) {
        [self.webView goBack];
    }
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
