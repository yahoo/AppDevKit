//
//  AutoLayoutSupportTestView.h
//  AppDevKit
//
//  Created by Jeff Lin on 3/13/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

@interface AutoLayoutSupportTestView : UIView
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end
