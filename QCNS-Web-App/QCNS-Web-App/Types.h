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

// QCNS Clients types

typedef NS_ENUM(NSInteger, QCNSBrandType)
{
    QCNSBrandTypeCosta = 2,
    QCNSBrandTypeMSC = 5
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
