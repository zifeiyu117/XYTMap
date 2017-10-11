//
//  XYTTool.h
//  XYTOfo
//
//  Created by Farben on 2017/10/11.
//  Copyright © 2017年 Farben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface XYTTool : NSObject

- (NSArray *)polylinesForPath:(AMapPath *)path;

@end
