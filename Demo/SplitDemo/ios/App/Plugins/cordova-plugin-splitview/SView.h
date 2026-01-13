//
//  SView.h
//  splitios
//
//  Created by jerry on 6/2/20.
//

#ifndef SView_h
#define SView_h

#import <Cordova/CDV.h>

@interface CDVViewControllerI : CDVViewController {
    
}

@property (nonatomic, readwrite, strong) UIView* launchView;
@end

#endif /* SView_h */
