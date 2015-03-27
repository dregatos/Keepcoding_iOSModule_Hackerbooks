//
//  DRGLibraryTableVC.m
//  MyHackerBooks_v2
//
//  Created by David Regatos on 27/03/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGLibraryTableVC.h"
#import "DRGLibrary.h"
#import "DRGBook.h"

@interface DRGLibraryTableVC ()

@end

@implementation DRGLibraryTableVC

#pragma mark - Init

- (id)initWithLibrary:(DRGLibrary *)aLibrary style:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        _library = aLibrary;
        self.title = @"Library";
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.library booksCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get data for indexPath
    DRGBook *book = [self bookAtIndexPath:indexPath];
    
    // Create standard cell
    static NSString *cellId = @"BookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.textLabel.text = book.title;
    
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
    
    // Notify the change
}


#pragma mark - Helpers

- (DRGBook *)bookAtIndexPath:(NSIndexPath *)indexPath {
    return [self.library.bookList objectAtIndex:indexPath.row];
}


@end
