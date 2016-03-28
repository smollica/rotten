//
//  DetailViewController.m
//  RottenMangoes
//
//  Created by Monica Mollica on 2016-03-28.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.movie.title;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *reviewTask =[session dataTaskWithURL:[NSURL URLWithString:self.movie.reviewURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *newJsonError = nil;
        
        NSArray *movieReviews = [NSJSONSerialization JSONObjectWithData:data options:0 error:&newJsonError][@"reviews"];
        
        if(movieReviews.count == 0) {
            
            self.reviewLabel.text = @"No Reviews Found";
            
        } else {
        
            int randomReview = arc4random_uniform((u_int32_t)movieReviews.count);
            
            self.movie.review = movieReviews[randomReview][@"quote"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.reviewLabel.text = self.movie.review;
                
            });
            
        }
        
    }];
    
    [reviewTask resume];
}

@end
