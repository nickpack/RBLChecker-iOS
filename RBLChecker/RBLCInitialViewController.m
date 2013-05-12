//
//  RBLCInitialViewController.m
//  RBLChecker
//
//  Created by Nick Pack on 11/05/2013.
//  Copyright (c) 2013 Nick Pack.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "RBLCInitialViewController.h"
#import "RBLCBlacklist.h"
#import "RBLCBlacklistResult.h"
#include <sys/types.h>
#include <sys/socket.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if.h>
#include <netdb.h>
#import "PrettyKit.h"
#import "SVModalWebViewController.h"
#import "TSMessage.h"
#import "ODRefreshControl.h"
#import "FontAwesomeKit.h"


@interface RBLCInitialViewController ()
- (void)reload:(id)sender;
- (BOOL)isValidIP:(NSString*)address isV6:(BOOL)ipv6;
- (BOOL)isValidFQDN:(NSString *)address;
- (void)customizeNavBar;
- (void)checkListings:(NSString *)ip;
- (NSString *)ipForHostname:(NSString *)hostname;
@end

@implementation RBLCInitialViewController {

@private
    NSArray *_lists;
    __strong UIActivityIndicatorView *_activityIndicatorView;
    __strong  ODRefreshControl *_refreshView;
}

@synthesize searchHost = _searchHost;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.trackedViewName = @"Main View Controller";
    }
    return self;
}

- (void)customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;

    navBar.bottomLineColor = [UIColor colorWithHex:0x000000];
    navBar.gradientStartColor = [UIColor colorWithHex:0x444444];
    navBar.gradientEndColor = [UIColor colorWithHex:0x333333];
    navBar.topLineColor = [UIColor colorWithHex:0x000000];
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;
}

- (void)loadView {
    [super loadView];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
    _refreshView = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshView addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    [self.tableView dropShadows];
    [self customizeNavBar];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];

    [self reload:nil];
}

- (void)viewDidUnload {
    _activityIndicatorView = nil;

    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
    }

    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];

    RBLCBlacklist *list = [_lists objectAtIndex:indexPath.row];

    cell.textLabel.text = list.name;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    if ([list.statusMessage count] > 0) {
        cell.detailTextLabel.text = [list.statusMessage objectAtIndex:0];
        if (!list.listed) {
            cell.gradientStartColor = safe_start_color;
            cell.gradientEndColor = safe_end_color;
            UIImage *statusIcon = [FontAwesomeKit imageForIcon:FAKIconOkSign
                                                     imageSize:CGSizeMake(30, 30)
                                                      fontSize:29
                                                    attributes:nil];
            UIImageView *statusView = [[UIImageView alloc] initWithImage:statusIcon];
            cell.accessoryView = statusView;
        } else {
            cell.gradientStartColor = listed_start_color;
            cell.gradientEndColor = listed_end_color;
            UIImage *statusIcon = [FontAwesomeKit imageForIcon:FAKIconWarningSign
                                                     imageSize:CGSizeMake(30, 30)
                                                      fontSize:29
                                                    attributes:nil];
            UIImageView *statusView = [[UIImageView alloc] initWithImage:statusIcon];
            cell.accessoryView = statusView;
        }

    } else {
        cell.detailTextLabel.text = list.endpoint;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RBLCBlacklist *list = [_lists objectAtIndex:indexPath.row];
    // @todo Segue
    //[self performSegueWithIdentifier:@"webview" sender:self];
    if (list.listed) {
        NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink error:nil];
        NSArray* matches = [detector matchesInString:[list.statusMessage objectAtIndex:0] options:0 range:NSMakeRange(0, [[list.statusMessage objectAtIndex:0] length])];
        SVModalWebViewController* webView = [[SVModalWebViewController alloc] initWithAddress:[NSString stringWithFormat:@"%@", [[matches objectAtIndex:0] URL]]];
        webView.barsTintColor = [UIColor blackColor];
        [self presentViewController:webView animated:YES completion:nil];
    }
}

- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];

    if ([self.searchHost length] > 0) {
        [self checkListings:self.searchHost];
    } else {
        [RBLCBlacklist listsWithBlock:^(NSArray *lists, NSError *error) {
            if (error) {
                [TSMessage showNotificationInViewController:self
                                                withTitle:NSLocalizedString(@"Error", nil)
                                                withMessage:NSLocalizedString(@"An error was encountered when trying to retrieve the list of RBLs.", nil)
                                                withType:TSMessageNotificationTypeError];
            } else {
                _lists = lists;
                [self.tableView reloadData];
            }
            [_refreshView endRefreshing];
            [_activityIndicatorView stopAnimating];
        }];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _lists = nil;
    [self reload:nil];
}

- (BOOL)isValidFQDN:(NSString *)address {
    NSRange r;
    NSString *regEx = @"(?=^.{1,254}$)(^(?:(?!\\d+\\.|-)[a-zA-Z0-9\\-]{1,63}(?<!-)\\.?)+(?:[a-zA-Z]{2,})$)";
    r = [address rangeOfString:regEx options:NSRegularExpressionSearch];
    if (r.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isValidIP:(NSString*)address isV6:(BOOL)ipv6 {
    NSString *regEx = nil;
    if (!ipv6) {
        regEx = @"\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b";
    } else {
        regEx = @"^\\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:)))(%.+)?\\s*$";
    }
    NSRange r = [address rangeOfString:regEx options:NSRegularExpressionSearch];
 
    if (r.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }

}

- (void)checkListings:(NSString *)ip {
    if ([_lists count] < 1) {
        return;
    }
    
    int currentIndex = 0;
    for (RBLCBlacklist* rbl in _lists) {
        [_activityIndicatorView startAnimating];
        [_refreshView beginRefreshing];
        [RBLCBlacklistResult forList:rbl.endpoint withIP:ip resultWithBlock:^(NSArray *result, NSError *error) {
            if (error) {
                [TSMessage showNotificationInViewController:self
                                                withTitle:NSLocalizedString(@"Error", nil)
                                                withMessage:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"An error was encountered when checking", nil), rbl.endpoint]
                                                withType:TSMessageNotificationTypeError];
            } else {
                NSIndexPath *path = [NSIndexPath indexPathForRow:currentIndex inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
                RBLCBlacklist *currentList = [_lists objectAtIndex:currentIndex];
                
                if ([result isKindOfClass: [NSArray class]] ) {
                    currentList.statusMessage = result;
                    currentList.listed = YES;
                } else {
                    currentList.statusMessage = [NSArray arrayWithObject: NSLocalizedString(@"Not Listed", nil)];
                    currentList.listed = NO;
                }

                cell.detailTextLabel.text = [currentList.statusMessage objectAtIndex:0];
            }
            [_activityIndicatorView stopAnimating];
            [_refreshView endRefreshing];
            [self.tableView reloadData];

        }];
        currentIndex++;
    }
}

- (NSString *)ipForHostname:(NSString *)hostname {
    struct hostent *remoteHostEnt = gethostbyname([hostname UTF8String]);
    if (!remoteHostEnt) {
        herror("resolv");
        return nil;
    }
    
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);

    return [NSString stringWithUTF8String:sRemoteInAddr];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *ipToCheck = [[NSString alloc] init];

    if ([self isValidFQDN:searchBar.text]) {
        ipToCheck = [self ipForHostname:searchBar.text];
    }
    if ([self isValidIP:searchBar.text isV6:NO]) {
       ipToCheck = searchBar.text;
    }

    if ([ipToCheck length] < 1) {
        [TSMessage showNotificationInViewController:self
                                          withTitle:NSLocalizedString(@"Error", nil)
                                        withMessage:NSLocalizedString(@"Please enter a valid IPv4 address or FQDN", nil)
                                           withType:TSMessageNotificationTypeError];

    } else {
        _searchHost = searchBar.text;
        [searchBar resignFirstResponder];
        [self checkListings:ipToCheck];
    }
}

@end
