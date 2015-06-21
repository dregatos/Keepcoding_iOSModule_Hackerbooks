//
//  DRGLibraryTableVC.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibraryTableVC.h"
#import "DRGBookDetailVC.h"

#import "NotificationKeys.h"
#import "Settings.h"

#import "DRGLibraryPresenter.h"
#import "DRGBook.h"

#import "DRGBookViewCell.h"

@interface DRGLibraryTableVC ()

@property (nonatomic, strong) DRGLibraryPresenter *libraryPresenter;

@end

NSString * const CustomCell = @"CustomCell";

@implementation DRGLibraryTableVC

#pragma mark - Init

- (id)initWithLibraryPresenter:(DRGLibraryPresenter *)libraryPresenter
                         style:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        _libraryPresenter = libraryPresenter;
        self.title = @"Library";
    }
    
    return self;
}

#pragma mark - Notification

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBookFavoriteStatusDidChange:)
                                                 name:BOOK_INFO_WAS_UPDATED_NOTIFICATION_NAME
                                               object:nil];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// LIBRARY_DID_CHANGE_NOTIFICATION_NAME
- (void)notifyBookFavoriteStatusDidChange:(NSNotification *)notification {
    // Update content view
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Notifications **********************
    [self registerForNotifications];
    
    // Register custom cell
    [self.tableView registerNib:[UINib nibWithNibName:@"DRGBookViewCell" bundle:nil]
         forCellReuseIdentifier:CustomCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // NOTE: we cannot unregister here on iPhone version
    //[self unregisterForNotifications];   //optionally we can unregister a notification when the view disappears
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.libraryPresenter tags] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.libraryPresenter bookCountForTag:[self tagAtIndex:section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data for indexPath
    DRGBook *book = [self bookAtIndexPath:indexPath];
    
    // Custom Cell
    DRGBookViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCell];
    if(cell == nil) {
        cell = [[DRGBookViewCell alloc] init];
    }
    
    // Configure the cell...
    [cell configureCellForBook:book];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data for indexPath
    DRGBook *book = [self bookAtIndexPath:indexPath];

    // Save title of last selected book
    [[NSUserDefaults standardUserDefaults] setObject:book.title forKey:LAST_SELECTED_BOOK];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Talk with the delegate, if it implements the method
    if ([self.delegate respondsToSelector:@selector(libraryTableVC:didSelectCharacter:)]) {
        [self.delegate libraryTableVC:self didSelectCharacter:book];
    }
    
    // Notify BOOK was selected - ONLY FOR iPad VERSION
    NSDictionary *dict = @{BOOK_KEY:book};
    [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_WAS_SELECTED_NOTIFICATION_NAME
                                                        object:self
                                                      userInfo:dict];
    
    // DeSelect Row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self tagAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DRGBookViewCell height];
}

#pragma mark - Helpers

- (DRGBook *)bookAtIndexPath:(NSIndexPath *)indexPath {
    return [self.libraryPresenter bookForTag:[self tagAtIndex:indexPath.section] atIndex:indexPath.row];
}

- (NSString *)tagAtIndex:(NSUInteger)index {
    return [[self.libraryPresenter tags] objectAtIndex:index];
}

#pragma mark - DRGLibraryTableVCDelegate

- (void)libraryTableVC:(DRGLibraryTableVC *)libraryTableVC didSelectCharacter:(DRGBook *)book {
    DRGBookDetailVC *bookVC = [[DRGBookDetailVC alloc] initWithBook:book];
    [self.navigationController pushViewController:bookVC animated:YES];
}

@end
