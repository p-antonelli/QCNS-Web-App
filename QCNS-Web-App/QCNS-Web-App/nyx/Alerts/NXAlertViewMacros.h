//
//  NXAlertViewMacros.h
//  NXFramework
//
//  Created by Paul Antonelli on 23/05/14.
//  Copyright (c) 2014 NYX Info. All rights reserved.
//

#define ALERT_OK(aTitle, aMessage)                              [NXAlertViewFactory alertWithTitle:(aTitle) message:(aMessage)]
#define ALERT_YES(aTitle, aMessage, aYesBlock)                  [NXAlertViewFactory alertWithTitle:(aTitle) message:(aMessage) yesCaption:@"Oui" noCaption:nil yesBlock:aYesBlock noBlock:nil]
#define ALERT_YES_NO(aTitle, aMessage, aYesBlock, aNoBlock)     [NXAlertViewFactory alertWithTitle:(aTitle) message:(aMessage) yesCaption:@"Oui" noCaption:@"No" yesBlock:aYesBlock noBlock:aNoBlock]