//
//  MM_ViewController.m
//  M_CoreDataExample
//
//  Created by Jamie Thomason on 10/29/12.
//  Copyright (c) 2012 Jamie Thomason. All rights reserved.
//

#import "MM_ViewController.h"
#import "CoreData/CoreData.h"
#import "MMClass.h"

@interface MM_ViewController () <UIAlertViewDelegate>
{
    NSManagedObjectModel*           mManagedObjectModel;
    NSPersistentStoreCoordinator*   mPersintantStoreCoordinator;
    NSManagedObjectContext*         mManagedObjectContext;
    NSMutableArray*                 mAllClasses;
    
    IBOutlet UITextField*   oTextField;
    IBOutlet UITableView*   oTableView;
}

@property (nonatomic) NSInteger rowToDelete;

-(IBAction)addItem:(id)sender;
-(NSArray*)__allEntities;

@end

@implementation MM_ViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])){
        NSURL* documentsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        NSURL* coreDataURL = [documentsDirectoryURL URLByAppendingPathComponent:@"M_CoreDataExample.sqlite"];
        NSError* error;
        
        mManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        mPersintantStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mManagedObjectModel];
        
        if ([mPersintantStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:coreDataURL options:nil error:&error])
        {
            mManagedObjectContext = [[NSManagedObjectContext alloc] init];
            [mManagedObjectContext setPersistentStoreCoordinator:mPersintantStoreCoordinator];
        }
        else{
            NSLog(@"Failed to create or open database: %@", [error userInfo]);
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mAllClasses = [NSMutableArray arrayWithArray:[self __allEntities]];
    [mAllClasses retain];
 }

-(IBAction)addItem:(id)sender
{
    MMClass* mmClass = (MMClass*)[NSEntityDescription insertNewObjectForEntityForName:@"MMClass" inManagedObjectContext:mManagedObjectContext];
    NSError* error;
    
    mmClass.name = oTextField.text;
    
    if(![mManagedObjectContext save:&error]){
        NSLog(@"Failed to save: %@", [error userInfo]);
    }
    
    [mAllClasses addObject:mmClass];
//    [mAllClasses release];
//    mAllClasses = [self __allEntities];
//    [mAllClasses retain];
    
    [oTableView reloadData];
    [oTextField resignFirstResponder];
    
    oTextField.text = @"";
//    Replaced by selecting the "Clear on Editing" option in xib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSArray*)__allEntities
{
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"MMClass" inManagedObjectContext:mManagedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSFetchedResultsController* fetchedResultsController;
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:nil];
    NSError* error;
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entityDescription];
    fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:mManagedObjectContext sectionNameKeyPath:nil
                                                                               cacheName:nil]
                        autorelease];
    [fetchedResultsController performFetch:&error];
    [fetchRequest release];
    
    return fetchedResultsController.fetchedObjects;
}

#pragma mark UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // animates the deselection of the row that was clicked.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    Old code from TableView excercise
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:((MMClass*)[mAllClasses objectAtIndex:indexPath.row]).name
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:@"Delete",nil];
//    alertView.delegate=self;
////    self.rowToDelete=indexPath.row;
//    [alertView show];
//    [alertView release];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        MMClass *item=[mAllClasses objectAtIndex:indexPath.row];
        [mManagedObjectContext deleteObject:item];
        [mManagedObjectContext save:nil];
        [mAllClasses removeObjectAtIndex:indexPath.row];
        [oTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (editingStyle == UITableViewCellEditingStyleInsert){
        NSLog(@"Editing?");
    }

}
#pragma mark UITableViewDataSouce

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mAllClasses count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MMCoreDataExampleIdentifier"];
    
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MMCoreDataExampleIdentifier"];
      
    }

//    NSString *cellValue = [myArrayNew objectAtIndex:indexPath.row];
//    
//    tableViewCell.textLabel.text = cellValue;

    tableViewCell.textLabel.text = ((MMClass*)[mAllClasses objectAtIndex:indexPath.row]).name;
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }
}


@end
