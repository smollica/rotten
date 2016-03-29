//
//  ViewController.m
//  RottenMangoes
//
//  Created by Monica Mollica on 2016-03-28.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "DetailViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic) NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger totalMovies;
@property (nonatomic) NSString *nextPageURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.movies = [NSMutableArray new];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=55gey28y6ygcr8fjy4ty87ek"];
    
    NSURLSessionTask *task =[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError = nil;
        
        NSDictionary *moviesDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *moviesJSON = moviesDictionary[@"movies"];
        
        self.totalMovies = [moviesDictionary[@"total"] integerValue];
        
        self.nextPageURL = [moviesDictionary[@"links"][@"next"] stringByAppendingString:@"&apikey=55gey28y6ygcr8fjy4ty87ek"];
        
        for (NSDictionary *eachMovie in moviesJSON) {
            Movie *movie = [Movie new];
            movie.title = eachMovie[@"title"];
            movie.rating = eachMovie[@"ratings"][@"critics_score"];
            movie.poster = eachMovie[@"posters"][@"thumbnail"];
            NSString *reviewURL = eachMovie[@"links"][@"reviews"];
            movie.reviewURL = [reviewURL stringByAppendingString:@"?apikey=55gey28y6ygcr8fjy4ty87ek"];
            movie.webURL =  eachMovie[@"links"][@"alternate"];
            
            [self.movies addObject:movie];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
            
        });

    }];
    
    [task resume];
    
}

//Collection View Data Source

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = self.view.frame.size.width/2;
    return CGSizeMake(width, width * 1.25);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *movieCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieItem" forIndexPath:indexPath];
    
    Movie *movie = [self.movies objectAtIndex:indexPath.item];
    
    movieCell.titleLabel.text = movie.title;
    movieCell.ratingLabel.text = movie.rating.stringValue;
    
    if (movie.posterImage) {
        movieCell.posterView.image = movie.posterImage;
    } else {
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURL *url = [NSURL URLWithString:movie.poster];
        
        NSURLSessionTask *task =[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            UIImage *tempImage = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                movie.posterImage = tempImage;
                movieCell.posterView.image = tempImage;
                
            });
            
        }];
        
        [task resume];
    }
    return movieCell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    DetailViewController *dvc = (DetailViewController *)[segue destinationViewController];
    dvc.movie = self.movies[indexPath.item];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if(self.nextPageURL==nil) {
        return;
    }
    
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURL *url = [NSURL URLWithString:self.nextPageURL];
        
        NSURLSessionTask *task =[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSError *jsonError = nil;
            
            NSDictionary *moviesDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSArray *moviesJSON = moviesDictionary[@"movies"];
            
            self.totalMovies = [moviesDictionary[@"total"] integerValue];
            
            self.nextPageURL = [moviesDictionary[@"links"][@"next"] stringByAppendingString:@"&apikey=55gey28y6ygcr8fjy4ty87ek"];
            
            //[self.movies removeAllObjects];
            
            for (NSDictionary *eachMovie in moviesJSON) {
                Movie *movie = [Movie new];
                movie.title = eachMovie[@"title"];
                movie.rating = eachMovie[@"ratings"][@"critics_score"];
                movie.poster = eachMovie[@"posters"][@"thumbnail"];
                NSString *reviewURL = eachMovie[@"links"][@"reviews"];
                movie.reviewURL = [reviewURL stringByAppendingString:@"?apikey=55gey28y6ygcr8fjy4ty87ek"];
                movie.webURL =  eachMovie[@"links"][@"alternate"];
                
                [self.movies addObject:movie];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
            });
            
        }];
        
        [task resume];
    }
}

@end