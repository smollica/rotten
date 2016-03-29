//
//  MovieCell.h
//  RottenMangoes
//
//  Created by Monica Mollica on 2016-03-28.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;


@end
