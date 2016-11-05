//
//  ViewController.m
//  Trenin2
//
//  Created by supermacho on 19.10.16.
//  Copyright © 2016 supermacho. All rights reserved.
//

#import "ViewController.h"
#import "Group.h"
#import "Student.h"
@interface ViewController () <UITableViewDataSource,UITableViewDelegate >

@property (strong, nonatomic) NSMutableArray* arrayGroup;
@property (strong, nonatomic) NSArray* namesArray;
@property (strong, nonatomic) NSMutableArray* saveNames;
@property (strong, nonatomic) NSMutableArray* studentsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [array addObject:[Student randStudent]];
    }
    
    self.studentsArray = array;
    Group* group = nil;
    int x = 0;
    int i = 0;
    self.arrayGroup = [NSMutableArray array];
    self.namesArray = [self addInArrayNames:self.studentsArray];
    self.saveNames = [NSMutableArray arrayWithArray:self.namesArray];
    NSLog(@"%@",self.namesArray);
    for (NSString* string in self.namesArray) {
        
        if ((x % 10) == 0) {
            i++;
            group = [[Group alloc]init];

            group.students = [NSMutableArray array];
            [group.students addObject:string];
            group.name = [NSString stringWithFormat:@"Students group #%d",(x + i) - x];
            [self.arrayGroup addObject:group];
        } else {
            group = [self.arrayGroup lastObject];
            [group.students addObject:string];
        }
        x++;
        
    }
    NSLog(@"Count group %ld",[self.arrayGroup count]);
    
    
    [self.tableView reloadData];
    //self.tableView.editing = YES;
    self.navigationItem.title = @"Students";
    
    
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(actionAddSection:)];
    [self.navigationItem setLeftBarButtonItem:addButton];

    
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}




- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        Group* sourceGroup = [self.arrayGroup objectAtIndex:indexPath.section];
        Student* student = [sourceGroup.students objectAtIndex:indexPath.row - 1];
        
        NSMutableArray* array = [NSMutableArray arrayWithArray:sourceGroup.students ];
        [array removeObject:student];
        sourceGroup.students = array;
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [tableView endUpdates];
    }
}



#pragma mark - Actions

- (void) actionEdit:(UIBarButtonItem*) sender {
    NSLog(@"actionEdit");
    
    BOOL isEdit = self.tableView.editing;
    
    [self.tableView setEditing:!isEdit animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:NO];

}

- (void) actionAddSection:(UIBarButtonItem*) sender {
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        [array addObject:[Student randStudent]];
    }
    
    Group* group = [[Group alloc]init];
    group.name = [NSString stringWithFormat:@"Students group #%ld",[self.arrayGroup count] + 1];
    group.students = [NSMutableArray arrayWithArray:[self addInArrayNames:array]];
    
    NSLog(@"%@",group.students);
    
    [self.saveNames addObjectsFromArray:group.students];
    
    self.namesArray = self.saveNames;
    NSLog(@"%@",self.namesArray);
    NSInteger newSectionIndex = 0;
    [self.arrayGroup insertObject:group atIndex:newSectionIndex];
    
    [self.tableView beginUpdates];
    
    NSIndexSet* insertSection = [NSIndexSet indexSetWithIndex:newSectionIndex ];
    [self.tableView insertSections:insertSection
                  withRowAnimation:[self.arrayGroup count] % 2 ? UITableViewRowAnimationLeft:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delayInSeconds = 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        
        
    });
    NSLog(@"Count of group %ld",[self.arrayGroup count]);
    
}



- (NSArray*) addInArrayNames:(NSMutableArray*) searchArray {
    NSMutableArray* array = nil;
    array = [NSMutableArray array];
    for (Student* student in searchArray) {
        NSString* string = [NSString stringWithFormat:@"%@ %@",student.firstName,student.lastName];
        [array addObject:string];

    }
    
    return array;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrayGroup count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.arrayGroup objectAtIndex:section]  name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Group* group = [self.arrayGroup objectAtIndex:section];
    return [group.students count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        static NSString* addStudentIdentifier = @"addStudentCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.text = @"Add Student";
        }
        return cell;
    } else {
    
    
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    Group* group = [self.arrayGroup objectAtIndex:indexPath.section];
    //Student* student = [group.students objectAtIndex:indexPath.row];
    
    //NSString* name = [group.students objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",student.firstName, student.lastName];
    cell.textLabel.text = [group.students objectAtIndex:indexPath.row - 1];
    return cell;
    
    }
    
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //NSLog(@"textDidChange %@",searchText);
     NSMutableArray* array = [NSMutableArray array];
    Group* group = nil;
    //NSString* currentLetter = nil;//
    
    
    NSLog(@"Count of group %ld",[self.arrayGroup count]);
    
    int x = 0;
    int i = 0;
    
    for (NSString* string in self.namesArray) {
        
        if ([searchText length] > 0 && [string rangeOfString:searchText].location == NSNotFound) {
            continue;
        }
        
       // NSLog(@"Self NamesArray %@",self.namesArray);
        
        if ((x % 10) == 0) {
            i++;
            group = [[Group alloc]init];
            
           
            group.students = [NSMutableArray array];
            [group.students addObject:string];
           
            //NSLog(@"%@",group.students);
            group.name = [NSString stringWithFormat:@"Students group #%d",(x + i) - x];
            [array addObject:group];
           
        } else {
            group = [array lastObject];
            [group.students addObject:string];
        }
        x++;
        
    }
    
    
    self.arrayGroup = array;
    
    [self.tableView reloadData];
    
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > 0;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    Group* sourceGroup = [self.arrayGroup objectAtIndex:sourceIndexPath.section];
    Student* student = [sourceGroup.students objectAtIndex:sourceIndexPath.row - 1];
    NSLog(@"Student %@ ",student);
    NSMutableArray* array = [NSMutableArray arrayWithArray:sourceGroup.students];
    NSLog(@"Gorup of students %@",array);
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [array exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
        sourceGroup.students = array;
    } else {
    
    
    [array removeObject:student];
    sourceGroup.students = array;
    NSLog(@"Gorup of students %@",array);
    
    Group* destinationGroup = [self.arrayGroup objectAtIndex:destinationIndexPath.section];
    array = [NSMutableArray arrayWithArray:destinationGroup.students];
    [array insertObject:student atIndex:destinationIndexPath.row];
        NSLog(@"Gorup of students %@",array);
    destinationGroup.students = array;
    }
    
    
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        Group* group = [self.arrayGroup objectAtIndex:indexPath.section];
        
        NSMutableArray* tempArray = nil;
        NSMutableArray* array = [NSMutableArray array];
        NSMutableArray* arrayWithStudent = [NSMutableArray array];
        if (group.students) {
            tempArray = [NSMutableArray arrayWithArray:group.students];
            
        } else {
            tempArray = [NSMutableArray array];
        }
        
        [array addObject:[Student randStudent]];
        [arrayWithStudent addObjectsFromArray:[self addInArrayNames:array]];
    
        NSString* string = [arrayWithStudent objectAtIndex:0];
        [tempArray insertObject:string atIndex:0];
        group.students = tempArray;
        
        [self.tableView beginUpdates];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:1 inSection:indexPath.section ];
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        
        [self.tableView endUpdates];
        //[self.tableView reloadData];
    }
    
}



  @end
