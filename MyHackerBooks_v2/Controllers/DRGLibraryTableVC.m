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
#import "DRGPersistanceManager.h"

//#import "DRGLibraryTableVCDelegate.h"
//#import "DRGBookVCDelegate.h"

#define FAVORITE_SECTION_INDEX 0

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == FAVORITE_SECTION_INDEX) {
        return @" Favorites";
    } else {
        return [self tagAtIndex:section-1];
    }
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

#pragma mark - DRGBookVCDelegate

- (void)bookVC:(DRGBookVC *)aBookVC didFavoriteABook:(DRGBook *)aBook {
    
    self.library = [self.library markBookAsFavorite:aBook];
    [self.tableView reloadData];
    
    // Save library
    [DRGPersistanceManager saveLibraryOnDocumentFolder:self.library];
}


@end
