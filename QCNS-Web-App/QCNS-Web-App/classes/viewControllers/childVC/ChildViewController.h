//
//  ChildViewController.h
//  QCNS-Web-App
//
//  Created by Paul Antonelli on 31/05/2016.
//  Copyright © 2016 Paul Antonelli | NYX INFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildViewController : UIViewController

@property (nonatomic, readwrite) NSURL *urlToLoad;
@property (nonatomic, readwrite) BOOL isPresentedModally;

@end
