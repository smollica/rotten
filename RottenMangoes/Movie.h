//
//  Movie.h
//  RottenMangoes
//
//  Created by Monica Mollica on 2016-03-28.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSString *poster;
@property (nonatomic) NSString *reviewURL;
@property (nonatomic) NSString *review;
@property (nonatomic) UIImage *posterImage;

@end
