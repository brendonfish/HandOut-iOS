//
//  DocListTVC.m
//  HandOut
//
//  Created by Brendonfish on 2015/9/12.
//  Copyright (c) 2015年 Brendonfish. All rights reserved.
//

#import "DocListTVC.h"

@interface DocListTVC ()

@property (nonatomic, retain) NSArray* docList;
@property (nonatomic, retain) IBOutlet UITableView* docTable;
@property (nonatomic, retain) NSURL* selectedFileURL;
@end

#define CELL_IDENTIFIER @"DocumentCellID"

@implementation DocListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.docTable registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CELL_IDENTIFIER];
    
    _docList = [[NSArray alloc] initWithObjects:@"Hackthon.ppt", @"Travel.ppt", @"Report.ppt", nil];
    NSArray* tmpArr = [self findFiles:@"pptx"];
    self.docList = [NSArray arrayWithArray:tmpArr];

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_docList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    // Configure the cell...
    cell.indentationLevel = 2;
    cell.textLabel.text = [_docList objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(_docTable.frame.origin.x, _docTable.frame.origin.y, _docTable.frame.size.width, _docTable.frame.size.height)];
    QLPreviewController* qlViewer = [[QLPreviewController alloc] init];
    qlViewer.dataSource = self;
    qlViewer.delegate = self;
    
    
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    NSString* fullPath = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(), @"Documents", [contents objectAtIndex:[indexPath row]]];
    
    
    NSURL* fullURL = [NSURL fileURLWithPath:fullPath];;
    [self setSelectedFileURL:fullURL];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [self.navigationController pushViewController:qlViewer animated:YES];
        
    }];
    
    //[self.view addSubview:qlViewer];
    //NSURLRequest *request = [NSURLRequest requestWithURL:fullURL];
    //[webView loadRequest:request];
    //[self.view addSubview: webView];
}

-(NSArray *)findFiles:(NSString *)extension{
    
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    // >>> this section here adds all files with the chosen extension to an array
    for (item in contents){
        if ([[item pathExtension] isEqualToString:extension]) {
            [matches addObject:item];
        }
    }
    return matches;
}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx {
    return _selectedFileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
