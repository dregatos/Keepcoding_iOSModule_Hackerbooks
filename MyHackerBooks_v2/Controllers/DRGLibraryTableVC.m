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

#import "DRGLibrary.h"
#import "DRGBook.h"

#import "DRGBookViewCell.h"

#define FAVORITE_SECTION_INDEX 0

@interface DRGLibraryTableVC ()

@end

NSString * const CustomCell = @"CustomCell";

@implementation DRGLibraryTableVC

#pragma mark - Init

- (id)initWithLibrary:(DRGLibrary *)aLibrary style:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        _library = aLibrary;
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
                                             selector:@selector(notifyLibraryDidChange:)
                                                 name:LIBRARY_DID_CHANGE_NOTIFICATION_NAME
                                               object:self.library];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// LIBRARY_DID_CHANGE_NOTIFICATION_NAME
- (void)notifyLibraryDidChange:(NSNotification *)notification {
    
    // Get updated book
    DRGLibrary *updatedLibrary = notification.userInfo[LIBRARY_KEY];
    // Update model
    self.library = updatedLibrary;
    // Update content view
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Notifications **********************
    [self registerForNotifications];
    
    // Register custom cell
    [self.tableView registerNib:[UINib nibWithNibName:@"DRGBookViewCell" bundle:nil] forCellReuseIdentifier:CustomCell];
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
    return [[self.library tags] count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == FAVORITE_SECTION_INDEX) {
        return [self.library favoriteBooksCount];
    } else {
        return [self.library bookCountForTag:[self tagAtIndex:section-1]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data for indexPath
    DRGBook *book = [self bookAtIndexPath:indexPath];
    
    // Create standard cell
    /*
    static NSString *cellId = @"BookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
     */
    
    // Custom Cell
    DRGBookViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCell];
    if(cell == nil) {
        cell = [[DRGBookViewCell alloc] init];
    }
    
    // NOTE: If you are using forCellReuseIdentifier: don't forget to register your cell before using it
    // [self.tableView registerNib:[UINib nibWithNibName:@"myCustomCell" bundle:nil] forCellReuseIdentifier:@"myCustomCell"];
    // OR to set the "Identifier" of the custom cell in the Storyboard (see Attributes Inspector of your custom cell)
    
    // Configure the cell...
    cell.bookTitle.text = book.title;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data for indexPath
    DRGBook *book = [self bookAtIndexPath:indexPath];
    
    // Talk with the delegate, if it implements the method
    if ([self.delegate respondsToSelector:@selector(libraryTableVC:didSelectCharacter:)]) {
        [self.delegate libraryTableVC:self didSelectCharacter:book];
    }
    
    // Notify BOOK was selected - ONLY FOR iPad VERSION
    NSDictionary *dict = @{BOOK_KEY:book};
    [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_WAS_SELECTED_NOTIFICATION_NAME object:self userInfo:dict];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == FAVORITE_SECTION_INDEX) {
        return @" Favorites";
    } else {
        return [self tagAtIndex:section-1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

#pragma mark - Helpers

- (DRGBook *)bookAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == FAVORITE_SECTION_INDEX) {
        // Favorite section
        return [[self.library favoriteBookList] objectAtIndex:indexPath.row];
    }
    // For section != than favorite one
    return [self.library bookForTag:[self tagAtIndex:indexPath.section-1] atIndex:indexPath.row];
}

- (NSString *)tagAtIndex:(NSUInteger)index {
    return [[self.library tags] objectAtIndex:index];
}

#pragma mark - DRGLibraryTableVCDelegate

- (void)libraryTableVC:(DRGLibraryTableVC *)libraryTableVC didSelectCharacter:(DRGBook *)book {
    DRGBookDetailVC *bookVC = [[DRGBookDetailVC alloc] initWithBook:book ofLibrary:self.library];
    [self.navigationController pushViewController:bookVC animated:YES];
}

@end
