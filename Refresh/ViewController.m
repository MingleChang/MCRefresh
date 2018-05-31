//
//  ViewController.m
//  Refresh
//
//  Created by gongtao on 2018/5/31.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "ViewController.h"
#import "MCRefresh/MCRefreshHeader.h"
#import "MCRefresh/MCRefreshFooter.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MCRefreshHeader *header;
@property (nonatomic, strong) MCRefreshFooter *footer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.header = [MCRefreshHeader headerWithTarget:self action:@selector(headerRefresh:) scrollView:self.tableView];
    self.header.backgroundColor = [UIColor redColor];
    
    self.footer = [MCRefreshFooter footerWithTarget:self action:@selector(footerRefresh:) scrollView:self.tableView];
    self.footer.backgroundColor = [UIColor greenColor];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.header removeFromSuperview];
//    self.header = nil;
//}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromCGSize(self.tableView.frame.size));
//    [self.header beginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headerRefresh:(MCRefreshHeader *)sender {
    NSLog(@"Header Refresh:%@",sender);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.header endRefreshing];
    });
}
- (void)footerRefresh:(MCRefreshHeader *)sender {
    NSLog(@"Footer Refresh:%@",sender);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.footer endRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *lCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!lCell) {
        lCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        lCell.contentView.backgroundColor = [UIColor blueColor];
    }
    return lCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
@end
