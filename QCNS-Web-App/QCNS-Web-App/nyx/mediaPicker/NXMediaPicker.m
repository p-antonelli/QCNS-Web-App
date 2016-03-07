//
//  NXMediaPicker.m
//  Feezly
//
//  Created by Paul Antonelli on 25/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import "NXMediaPicker.h"
#import "NXMediaPickerCell.h"

@import MobileCoreServices;

@interface NXMediaPicker () <UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>



@end

@implementation NXMediaPicker

+ (instancetype)sharedInstance
{
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initInternal];
    });
}

#pragma mark - Public Setters

- (void)setSourceType:(NXMediaPickerSourceType)sourceType
{
    _sourceType = sourceType;
    if (sourceType != NXMediaPickerSourceTypeGallery)
    {
        self.pickerController.sourceType = (UIImagePickerControllerSourceType)_sourceType;
    }
}
- (void)setVideoMaximumDuration:(NSTimeInterval)videoMaximumDuration
{
    _videoMaximumDuration = videoMaximumDuration;
    self.pickerController.videoMaximumDuration = videoMaximumDuration;
}
- (void)setAllowsEditing:(BOOL)allowsEditing
{
    _allowsEditing = allowsEditing;
    self.pickerController.allowsEditing = allowsEditing;
}
- (void)setMediaTypes:(NSArray<NSString *> *)mediaTypes
{
    _mediaTypes = [mediaTypes copy];
    self.pickerController.mediaTypes = mediaTypes;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogDebug(@"");
    
    NXMediaPickerCell *cell = (NXMediaPickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = cell.imageView.image;
    if ([self.delegate respondsToSelector:@selector(mediaPicker:didFinishPickingImage:atIndex:)])
    {
        [self.delegate mediaPicker:self didFinishPickingImage:image atIndex:indexPath.item];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.galleryDataSource respondsToSelector:@selector(numberOfImagesInGalleryForMediaPicker:)])
    {
        return [self.galleryDataSource numberOfImagesInGalleryForMediaPicker:self];
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NXMediaPickerCell <NXCollectionCells> *cell = nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NXMediaPickerCell class]) forIndexPath:indexPath];
    
    UIImage *image = nil;
    if ([self.galleryDataSource respondsToSelector:@selector(mediaPicker:galleryImageAtIndex:)])
    {
        image = [self.galleryDataSource mediaPicker:self galleryImageAtIndex:indexPath.item];
    }
    
    [cell setItem:image value:indexPath delegate:self];
    
    return cell;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController == self.pickerController && navigationController.viewControllers.count == 1)
    {
        // When showing the ImagePicker update the status bar and nav bar properties.
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        if (self.galleryTitle)
        {
            navigationController.topViewController.title = self.galleryTitle ;
        }
        
        navigationController.navigationBar.translucent = NO;
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
    else if (viewController == _galleryVC)
    {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        if (self.galleryTitle)
        {
            navigationController.topViewController.title = self.galleryTitle ;
        }
        
        navigationController.navigationBar.translucent = NO;
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString *selectedMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([selectedMediaType isEqualToString:(NSString *)kUTTypeMovie] ||
        [selectedMediaType isEqualToString:(NSString *)kUTTypeVideo])
    {
        
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];

//        NSLog(@"################# MEDIA URL : %@",
//
//        NSData *videoData = [NSData dataWithContentsOfURL:videoFileUrl];
//        BOOL success = [videoData writeToFile:self.tmpVideoPath atomically:NO];
//
//        NSLog(@"did write to disk : %d", success);
        
        
        if ([self.delegate respondsToSelector:@selector(mediaPicker:didFinishPickingVideoAtURL:)])
        {
            [self.delegate mediaPicker:self didFinishPickingVideoAtURL:mediaURL];
        }
        
    }
    else if ([selectedMediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = nil;
        if (self.pickerController.allowsEditing)
        {
            image = [info objectForKey:UIImagePickerControllerEditedImage];

        }
        else
        {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if ([self.delegate respondsToSelector:@selector(mediaPicker:didFinishPickingImage:atIndex:)])
        {
            [self.delegate mediaPicker:self didFinishPickingImage:image atIndex:NSNotFound];
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self.delegate respondsToSelector:@selector(mediaPickerDidCancel:)])
    {
        [self.delegate mediaPickerDidCancel:self];
    }
}


#pragma mark - Private

- (instancetype)initInternal
{
    self = [super init];
    if (self)
    {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;        
        _pickerController.delegate = self;
        
        _galleryLayout = [[UICollectionViewFlowLayout alloc] init];
        _galleryLayout.sectionInset = UIEdgeInsetsMake(2, 0, 0, 0);
        _galleryLayout.itemSize = [NXMediaPickerCell cellSizeWithItem:nil value:nil];
        _galleryLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _galleryLayout.minimumInteritemSpacing = PADDING;
        _galleryLayout.minimumLineSpacing = PADDING;
        
        _galleryVC = [[UICollectionViewController alloc] initWithCollectionViewLayout:_galleryLayout];
        
        [_galleryVC.collectionView registerNib:NIB_NAMED(NXMediaPickerCell)
                    forCellWithReuseIdentifier:NSStringFromClass([NXMediaPickerCell class])];
        _galleryVC.collectionView.delegate = self;
        _galleryVC.collectionView.dataSource = self;
        
        _galleryVC.collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
