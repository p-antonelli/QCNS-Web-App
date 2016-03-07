//
//  Types.h
//  Feezly
//
//  Created by Paul Antonelli on 12/11/2015.
//  Copyright © 2015 Paul Antonelli | NYX INFO. All rights reserved.
//

#ifndef Types_h
#define Types_h

@import Foundation;

#define FeezlyHobbyID   1

// User Data

typedef NS_ENUM(NSInteger, FZGender)
{
    FZGenderUnknown                = 0,
    FZGenderMale                   = 1,
    FZGenderFemale                 = 2
};

typedef NS_ENUM(NSInteger, FZCompatibilitySort)
{
    FZCompatibilityNoSort          = 0,
    FZCompatibilityFriendlySort    = 1,
    FZCompatibilityLoveSort        = 2,
    FZCompatibilitySexualSort      = 3
};

typedef NS_ENUM(NSInteger, FZCompatibilityType)
{
    FZCompatibilityTypeUnknown     = 0,
    FZCompatibilityTypeFriendly    = 1,
    FZCompatibilityTypeLove        = 2,
    FZCompatibilityTypeSexual      = 3
};

typedef NS_ENUM(NSInteger, FZMessageType)
{
    FZMessageTypeUnknown = 0,
    FZMessageTypeSent,
    FZMessageTypeReceived
};

typedef NS_ENUM(NSInteger, FZActionType)
{
    FZActionypeUnknown = 0,
    FZActionTypeVisit,
    FZActionTypeLike,
    FZActionTypeLiker,
    FZActionTypeDislike,
    FZActionTypeFeez,
    FZActionTypeSignal
};

typedef NS_ENUM(NSInteger, FZMediaType)
{
    FZMediaTypeUnknown = 0,
    FZMediaTypePicture = 1,
    FZMediaTypeVideo = 2,
};


typedef NS_ENUM(NSInteger, FZMarkActionType)
{
    FZMarkActionTypeUnknown = 0,
    FZMarkActionTypeLike,
    FZMarkActionTypeDislike,
    FZMarkActionTypeSignal,
};

typedef NS_ENUM(NSInteger, FZMarkItemType)
{
    FZMarkItemTypeUnknown = 0,
    FZMarkItemTypeLike,
    FZMarkItemTypeUnlike,
};


typedef NS_ENUM(NSInteger, FZItemType)
{
    FZItemTypeUnknown = 0,
    FZItemTypePhoto,
    FZItemTypeFriendly,
    FZItemTypeLove,
    FZItemTypeSexual,
    FZItemTypeDescription
};

typedef NS_ENUM(NSInteger, FZImageSize)
{
    FZImageSizeUnknown = 0,
    FZImageSizeThumb,                       // 80  x 80 px
    FZImageSizeThumbDetail,                 // 100 x 100 px
    FZImageSizeThumbMedium,                 // 160 x 160 px
    FZImageSizeCard,                        // 435 x 350 px
    FZImageSizeLarge,                       // 610 x 380 px
};

typedef NS_ENUM(NSInteger, FZNotificationType)
{
    FZNotificationTypeUnknown = 0,
    FZNotificationTypeUserLiked = 1,
    FZNotificationTypeItemLiked = 2,
    FZNotificationTypeFeez = 3,
    FZNotificationTypeChatMessage = 4,
};

typedef NS_ENUM(NSInteger, FZChatNotificationType)
{
    FZChatNotificationTypeUnknown = 0,
    FZChatNotificationTypeUserStateChanged,
    FZChatNotificationTypeUserNewFeez,
    FZChatNotificationTypeConnectionStateChanged,
    FZChatNotificationTypeInterlocutorStateChanged,
    FZChatNotificationTypeNewMessage,
};



typedef NS_ENUM(NSInteger, FZLikeState)
{
    FZLikeStateDefault = 0,
    FZLikeStateLiked,
    FZLikeStateDisliked,
    FZLikeStateFeez,
    FZLikeStateBlocked,
    FZLikeStateLiker
};

typedef NS_ENUM(NSInteger, FZProductType)
{
    FZProductTypeUnknown = 0,
    FZProductTypeSubscription,
    FZProductTypeAutoRenewSubscription,
};

typedef NS_ENUM(NSInteger, FZPlanType)
{
    FZPlanTypeUnknown = 0,
    FZPlanTypeFreemium,
    FZPlanTypePremium,
};



// Requests

typedef NS_ENUM(NSInteger, HTTPErrorCode)
{
    HTTPBadRequestErrorCode        = 400,
    HTTPBadParamsErrorCode         = 422,
    HTTPMissingParamErrorCode      = 404,

    HTTPInvalidAPITokenErrorCode   = 401,
    HTTPInvalidUserTokenErrorCode  = 403,

    HTTPAuthAPIErrorCode           = 422
};

typedef NS_ENUM(NSInteger, WSErrorCode)
{
    WSUnknownErrorCode             = 0,
    WSBadRequestErrorCode          = 1,
    WSBadParamsErrorCode           = 2,
    WSMissingParamErrorCode        = 3,

    WSInvalidAPITokenErrorCode     = 101,
    WSInvalidUserTokenErrorCode    = 102,

    WSInvalidLoginParamsErrorCode  = 103,
    WSAccountNotConfirmedErrorCode = 104,
    WSAccountBlockedErrorCode      = 105,
    WSUnknownEmailAddressErrorCode = 106,
    WSInvalidActionOnAccount       = 107,

    WSAuthGenericErrorCode         = 500
};


#endif /* Types_h */
