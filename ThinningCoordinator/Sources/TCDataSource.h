//
//  TCDataSource.h
//  ThinningCoordinator
//
//  Created by Roy Shaw on 8/24/15.
//  Copyright (c) 2015 Red Rain (https://github.com/cuzv).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "TCDataSourceProtocol.h"

@class TCGlobalDataMetric;
@class TCDelegate;
@interface TCDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

@property (nonatomic, weak, readonly, nullable) UITableView *tableView;
- (nullable instancetype)initWithTableView:(nonnull UITableView *)tableView;

@property (nonatomic, weak, readonly, nullable) UICollectionView *collectionView;
- (nullable instancetype)initWithCollectionView:(nonnull UICollectionView *)collectionView;

/// The tableview or collction view data metric.
@property (nonatomic, strong, nonnull) TCGlobalDataMetric *globalDataMetric;

- (nullable TCDelegate *)delegate;

/// TCDataSource subclass UICollectionViewDataSource flow layout require SupplementaryView, simple return this method.
- (nonnull UICollectionReusableView *)viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath;

@end
