//
//  RBLCInitialViewController.h
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

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface RBLCInitialViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSString *searchHost;

#define start_color [UIColor colorWithHex:0xFFFFFF]
#define end_color [UIColor colorWithHex:0xEFEFEF]
#define listed_start_color [UIColor colorWithHex:0xf2dede]
#define listed_end_color [UIColor colorWithHex:0xF9CBCC]
#define safe_end_color [UIColor colorWithHex:0xdff0d8]
#define safe_start_color [UIColor colorWithHex:0xdff0d8]

@end
