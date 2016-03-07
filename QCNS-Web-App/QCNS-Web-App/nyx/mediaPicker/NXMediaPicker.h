//
//  NXMediaPicker.h
//  Feezly
//
//  Created by Paul Antonelli on 25/01/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NXMediaPickerDelegate;
@protocol NXMediaPickerGalleryDataSource;

typedef NS_ENUM(NSInteger, NXMediaPickerSourceType)
{
    NXMediaPickerSourceTypePhotoLibrary = UIImagePickerControllerSourceTypePhotoLibrary,
    NXMediaPickerSourceTypePhotoCamera = UIImagePickerControllerSourceTypeCamera,
    NXMediaPickerSourceTypeSavedPhotosAlbum = UIImagePickerControllerSourceTypeSavedPhotosAlbum,
    NXMediaPickerSourceTypeGallery,
    NXMediaPickerSourceTypeFacebook,
    NXMediaPickerSourceTypeInstagram
};


#define PADDING_TOP     0
#define PADDING         0


#define COLS            4



@interface NXMediaPicker : NSObject <UINavigationControllerDelegate>

@property (nonatomic, readonly) UIImagePickerController *pickerController;

@property (nonatomic, readwrite) NSString *title;

@property (nonatomic, readonly) UICollectionViewController *galleryVC;
@property (nonatomic, readonly) UICollectionViewFlowLayout *galleryLayout;
@property (nonatomic, readwrite) NSString *galleryTitle;

@property (nonatomic, readwrite) NXMediaPickerSourceType sourceType;

@property (nonatomic, readwrite) NSTimeInterval videoMaximumDuration;
@property (nonatomic, readwrite) BOOL allowsEditing;
@property (nonatomic, readwrite) NSArray<NSString *> *mediaTypes;


@property (weak, nonatomic, readwrite) id<NXMediaPickerDelegate> delegate;
@property (weak, nonatomic, readwrite) id<NXMediaPickerGalleryDataSource> galleryDataSource;


+ (instancetype)sharedInstance;


@end

//

@protocol NXMediaPickerDelegate <NSObject>

@required

- (void)mediaPicker:(NXMediaPicker *)picker didFinishPickingVideoAtURL:(NSURL *)videoFileURL;
- (void)mediaPicker:(NXMediaPicker *)picker didFinishPickingImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)mediaPickerDidCancel:(NXMediaPicker *)picker;

@end

//

@protocol NXMediaPickerGalleryDataSource <NSObject>

@required

- (UIImage *)mediaPicker:(NXMediaPicker *)picker galleryImageAtIndex:(NSUInteger)index;
- (NSInteger)numberOfImagesInGalleryForMediaPicker:(NXMediaPicker *)picker;

@end