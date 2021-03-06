//
//  TCGlobalDataMetric.m
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

#import "TCGlobalDataMetric.h"
#import "TCSectionDataMetric.h"
#import "TCSectionDataMetric+Private.h"
#import "TCHelper.h"


@interface TCGlobalDataMetric ()
@property (nonatomic, strong) NSMutableArray<TCSectionDataMetric *> *sectionDataMetrics;
@property (nonatomic, strong) id dataForHeader;
@property (nonatomic, strong) id dataForFooter;
@end

@implementation TCGlobalDataMetric

#pragma mark - Initializer

- (instancetype)init {
    NSAssert(NO, NSLocalizedString(@"Ues `initWithSectionDataMetrics:` instead", nil));
    return nil;
}

- (nullable instancetype)initWithSectionDataMetrics:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _sectionDataMetrics = [NSMutableArray new];
    [_sectionDataMetrics addObjectsFromArray:sectionDataMetrics];
    
    return self;
}

- (nullable instancetype)initWithSectionDataMetrics:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics dataForHeader:(nonnull id)dataForHeader dataForFooter:(nonnull id)dataForFooter {
    self = [self initWithSectionDataMetrics:sectionDataMetrics];
    
    self.dataForHeader = dataForHeader;
    self.dataForFooter = dataForFooter;
    
    return self;
}

+ (nullable instancetype)empty {
    return [[[self class] alloc] initWithSectionDataMetrics:@[]];
}

#pragma mark - Retrieve

- (NSInteger)numberOfSections {
    return self.sectionDataMetrics.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [[self.sectionDataMetrics objectAtIndex:section] numberOfItems];
}

- (nullable NSArray<TCSectionDataMetric *> *)allSectionDataMetrics {
    return self.sectionDataMetrics;
}

- (nullable NSArray<TCSectionDataMetric *> *)sectionDataMetrics {
    return _sectionDataMetrics;
}

- (nullable NSArray *)dataInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric itemsData];
}

- (nullable id)dataForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if ([self.sectionDataMetrics count] <= section) {
        return nil;
    }

    return [[self.sectionDataMetrics objectAtIndex:section] dataAtIndex:indexPath.item];
}

- (nullable NSIndexPath *)indexPathOfData:(nonnull id)data {
    __block NSIndexPath *indexPath = nil;
    [self.sectionDataMetrics enumerateObjectsUsingBlock:^(TCSectionDataMetric *sectionDataMetric, NSUInteger idx, BOOL *stop) {
        NSArray *items = [sectionDataMetric itemsData];
        if ([items containsObject:data]) {
            NSInteger row = [items indexOfObjectIdenticalTo:data];
            indexPath = [NSIndexPath indexPathForItem:row inSection:idx];
            *stop = YES;
        }
    }];
    
    return indexPath;
}

- (nullable NSArray *)allData {
    NSMutableArray *allData = [NSMutableArray new];
    for (TCSectionDataMetric *sectionDataMetric in self.sectionDataMetrics) {
        [allData addObjectsFromArray:sectionDataMetric.itemsData];
    }
    
    return allData;
}

- (nullable NSString *)titleForHeaderInSection:(NSInteger)section {
    if ([self.sectionDataMetrics count] <= section) {
        return nil;
    }

    return [[self.sectionDataMetrics objectAtIndex:section] titleForHeader];
}

- (nullable NSString *)titleForFooterInSection:(NSInteger)section {
    if ([self.sectionDataMetrics count] <= section) {
        return nil;
    }
 
    return [[self.sectionDataMetrics objectAtIndex:section] titleForFooter];
}

- (nullable id)dataForHeaderInSection:(NSInteger)section {
    if ([self.sectionDataMetrics count] <= section) {
        return nil;
    }

    return [[self.sectionDataMetrics objectAtIndex:section] dataForHeader];
}

- (nullable id)dataForFooterInSection:(NSInteger)section {
    if ([self.sectionDataMetrics count] <= section) {
        return nil;
    }

    return [[self.sectionDataMetrics objectAtIndex:section] dataForFooter];
}

- (NSInteger)indexOfHeaderData:(nonnull id)data {
    NSArray *headerData = [self.sectionDataMetrics valueForKey:@"dataForHeader"];
    if ([headerData containsObject:data]) {
        return [headerData indexOfObjectIdenticalTo:data];
    }
    
    return -1;
}

- (NSInteger)indexOfFooterData:(nonnull id)data {
    NSArray *footerData = [self.sectionDataMetrics valueForKey:@"dataForFooter"];
    if ([footerData containsObject:data]) {
        return [footerData indexOfObjectIdenticalTo:data];
    }
    
    return -1;
}

- (nullable id)dataForHeader {
    return _dataForHeader;
}

- (nullable id)dataForFooter {
    return _dataForFooter;
}

- (nullable id)dataForSupplementaryHeaderAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if ([self.sectionDataMetrics count] <= section) {
        return nil;
    }
    
    return [self.sectionDataMetrics[section] dataForSupplementaryHeaderAtIndex:indexPath.item];
}

- (nullable id)dataForSupplementaryFooterAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if ([self.sectionDataMetrics count] <= section) {
        return nil;
    }
    
    return [self.sectionDataMetrics[section] dataForSupplementaryFooterAtIndex:indexPath.item];
}

- (nullable id)dataForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self dataForSupplementaryHeaderAtIndexPath:indexPath];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [self dataForSupplementaryFooterAtIndexPath:indexPath];
    }
    
    return nil;
}

- (nullable NSArray<NSString *> *)sectionIndexTitles {
    NSMutableArray *indexTitles = [NSMutableArray new];
    for (TCSectionDataMetric *sectionDataMetric in self.sectionDataMetrics) {
        NSString *indexTitle = sectionDataMetric.indexTitle;
        if (indexTitle) {
            [indexTitles addObject:indexTitle];
        }
    }
    
    if (indexTitles.count <= 0) {
        return nil;
    }
    
    return indexTitles;
}

#pragma mark - Modify

- (void)append:(nonnull TCSectionDataMetric *)sectionDataMetric {
    [_sectionDataMetrics addObject:sectionDataMetric];
}

- (void)appendSectionDataMetric:(TCSectionDataMetric *)sectionDataMetric {
    [self append:sectionDataMetric];
}

- (void)appendContentsOf:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics {
    [_sectionDataMetrics addObjectsFromArray:sectionDataMetrics];
}

- (void)insert:(nonnull TCSectionDataMetric *)sectionDataMetric atIndex:(NSInteger)index {
    [self insertContentsOf:@[sectionDataMetric] atIndex:index];
}

- (void)insertContentsOf:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics atIndex:(NSInteger)index {
    validateInsertElementArgumentIndex(_sectionDataMetrics, index, __FILE__, __LINE__, __FUNCTION__);
    [_sectionDataMetrics insertObjects:sectionDataMetrics atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sectionDataMetrics.count)]];
}

- (void)insertSectionDataMetric:(TCSectionDataMetric *)sectionDataMetric atIndex:(NSInteger)index {
    [self insert:sectionDataMetric atIndex:index];
}

- (void)appendLastSection:(nonnull id )data {
    [_sectionDataMetrics.lastObject append:data];
}

- (void)appendLastSectionContentsOf:(nonnull NSArray *)data {
    [_sectionDataMetrics.lastObject appendContentsOf:data];
}

- (void)appendLastSectionData:(nonnull NSArray *)data {
    [self appendLastSectionContentsOf:data];
}

- (void)append:(nullable id)data inSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] append:data];
}

- (void)appendContentsOf:(nullable NSArray *)data inSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] appendContentsOf:data];
}

- (void)appendData:(NSArray *)data inSection:(NSInteger)section {
    [self appendContentsOf:data inSection:section];
}

- (void)insert:(nonnull id)data atIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] insert:data atIndex:indexPath.item];
}

- (void)insertContentsOf:(nonnull NSArray *)data atIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] insertContentsOf:data atIndex:indexPath.item];
}

- (void)insertData:(NSArray *)data atIndexPath:(NSIndexPath *)indexPath {
    [self insertContentsOf:data atIndexPath:indexPath];
}

- (void)replaceWith:(nonnull id)data atIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] replaceWith:data atIndex:indexPath.item];
}

- (void)replaceWithContentsOf:(nonnull NSArray *)data atIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] replaceWithContentsOf:data atIndex:indexPath.item];
}

- (void)replaceData:(NSArray *)data atIndexPath:(NSIndexPath *)indexPath {
    [self replaceWithContentsOf:data atIndexPath:indexPath];
}

- (nullable TCSectionDataMetric *)removeFirst {
    if (self.sectionDataMetrics.count <= 0) {
        return nil;
    }

    TCSectionDataMetric *first = self.sectionDataMetrics.firstObject;
    [_sectionDataMetrics removeObjectAtIndex:0];
    return first;
}

- (nullable TCSectionDataMetric *)removeLast {
    if (self.sectionDataMetrics.count <= 0) {
        return nil;
    }
    
    TCSectionDataMetric *last = self.sectionDataMetrics.lastObject;
    [_sectionDataMetrics removeLastObject];

    return last;
}

- (nullable TCSectionDataMetric *)removeAtIndex:(NSInteger)index {
    if (self.sectionDataMetrics.count <= index) {
        return nil;
    }
    
    TCSectionDataMetric *removed = [self.sectionDataMetrics objectAtIndex:index];
    [_sectionDataMetrics removeObjectAtIndex:index];
    
    return removed;
}

- (nullable id)removeAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (self.sectionDataMetrics.count <= section) {
        return nil;
    }
    
    return [self.sectionDataMetrics[section] removeAtIndex:indexPath.item];
}

- (nullable NSArray<id> *)removeAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths {
    if (!indexPaths.count) {
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray new];
    NSMutableArray<NSNumber *> *indexs = [NSMutableArray new];
    void (^performRemove)() = ^(NSInteger section){
        NSArray<id> *removed = [self.sectionDataMetrics[section] removeAtIndexs:indexs];
        if (removed) {
            [result addObjectsFromArray:removed];
        }
        [indexs removeAllObjects];
    };
    
    NSArray<NSIndexPath *> *arr = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    NSInteger section = arr.firstObject.section;
    for (NSIndexPath *indexPath in arr) {
        if (indexPath.section != section) {
            performRemove(section);
        }
        [indexs addObject:@(indexPath.item)];
        section = indexPath.section;
    }
    performRemove(section);

    return result;
}

- (nullable NSArray *)removeAll {
    NSArray *all = [[NSArray alloc] initWithArray:self.sectionDataMetrics];
    [_sectionDataMetrics removeAllObjects];
    
    return all;
}

- (nullable TCSectionDataMetric *)removeLastSectionDataMetric {
    return [self removeLast];
}

- (nullable TCSectionDataMetric *)removeSectionDataMetricAtIndex:(NSInteger)index {
    return [self removeAtIndex:index];
}

- (nullable id)removeDataAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self removeAtIndexPath:indexPath];
}

- (void)exchageAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath withIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    NSInteger sourceSection = sourceIndexPath.section;
    NSInteger sourceItem = sourceIndexPath.item;
    NSInteger destinationSection = destinationIndexPath.section;
    NSInteger destinationItem = destinationIndexPath.item;
    
    if (sourceSection == destinationSection) {
        [self.sectionDataMetrics[sourceSection] exchangeElementAtIndex:sourceItem withElementAtIndex:destinationItem];
    }
    else {
        // Take out the source data.
        id sourceData = [self.sectionDataMetrics[sourceSection] removeAtIndex:sourceItem];
        id destinationData = [self.sectionDataMetrics[destinationSection] removeAtIndex:destinationItem];
        if (sourceData && destinationData) {
            [self.sectionDataMetrics[destinationSection] insert:sourceData atIndex:destinationItem];
            [self.sectionDataMetrics[sourceSection] insert:destinationData atIndex:sourceItem];
        }
        else {
            [NSException raise:@"FatalError: take out data faild." format:@""];
        }
    }
}

- (void)moveAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    NSInteger sourceSection = sourceIndexPath.section;
    NSInteger sourceItem = sourceIndexPath.item;
    NSInteger destinationSection = destinationIndexPath.section;
    NSInteger destinationItem = destinationIndexPath.item;
    
    if (sourceSection == destinationSection) {
        [self.sectionDataMetrics[sourceSection] moveElementAtIndex:sourceItem toIndex:destinationItem];
    }
    else {
        // Take out the source data.
        id sourceData = [self.sectionDataMetrics[sourceSection] removeAtIndex:sourceItem];
        if (sourceData) {
            // Insert to desitination position.
            [self.sectionDataMetrics[destinationSection] insert:sourceData atIndex:destinationItem];
        } else {
            [NSException raise:@"FatalError: take out data faild." format:@""];
        }
    }
}


#pragma mark - Cache Size & Height

- (void)cacheHeight:(CGFloat)height forIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] cacheHeight:height forIndex:indexPath.item];
}

- (CGFloat)cachedHeightForIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    return [self.sectionDataMetrics[section] cachedHeightForIndex:indexPath.item];
}

- (void)cacheSize:(CGSize)size forIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] cacheSize:size forIndex:indexPath.item];
}

- (CGSize)cachedSizeForIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    return [self.sectionDataMetrics[section] cachedSizeForIndex:indexPath.item];
}

- (void)cacheHeight:(CGFloat)height forHeaderInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedHeightForHeader = height;
}

- (CGFloat)cachedHeightForHeaderInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    return self.sectionDataMetrics[section].cachedHeightForHeader;
}

- (void)cacheSize:(CGSize)size forHeaderInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedSizeForHeader = size;
}

- (CGSize)cachedSizeForHeaderInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    return self.sectionDataMetrics[section].cachedSizeForHeader;
}

- (void)cacheHeight:(CGFloat)height forFooterInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedHeightForFooter = height;
}

- (CGFloat)cachedHeightForFooterInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    return self.sectionDataMetrics[section].cachedHeightForFooter;
}

- (void)cacheSize:(CGSize)size forFooterInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedSizeForFooter = size;
}

- (CGSize)cachedSizeForFooterInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    return self.sectionDataMetrics[section].cachedSizeForFooter;
}

- (void)invalidateCachedCellHeightForIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] invalidateCachedCellHeightForIndex:indexPath.item];
}

- (void)invalidateCachedCellSizeForIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    [self.sectionDataMetrics[section] invalidateCachedCellSizeForIndex:indexPath.item];
}

- (void)invalidateCachedHeightForHeaderInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedHeightForHeader = UITableViewAutomaticDimension;
}

- (void)invalidateCachedHeightForFooterInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedHeightForFooter = UITableViewAutomaticDimension;
}

- (void)invalidateCachedSizeForHeaderInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedSizeForHeader = CGSizeZero;
}

- (void)invalidateCachedSizeForFooterInSection:(NSInteger)section {
    validateNoneInsertElementArgumentIndex(self.sectionDataMetrics, section, __FILE__, __LINE__, __FUNCTION__);
    self.sectionDataMetrics[section].cachedSizeForFooter = CGSizeZero;
}


#pragma mark - Description

- (NSString *)description {
    return [self _description_];
}

- (NSString *)debugDescription {
    return [self _description_];
}

- (NSString *)_description_ {
    NSMutableString *desc = [[NSMutableString alloc] initWithString:@"sectionDataMetrics: (\n"];
    for (id item in _sectionDataMetrics) {
        [desc appendFormat:@"%@\n", item];
    }
    [desc appendFormat:@")\nsection count :%@", @(_sectionDataMetrics.count)];
    [desc appendFormat:@"\naddress :%p", self];
    return [NSString stringWithString:desc];
}

@end
