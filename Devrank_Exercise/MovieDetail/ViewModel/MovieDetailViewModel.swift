//
//  MovieDetailViewModel.swift
//  iOS_Exercise
//
//  Created by Leonardo Cid on 4/11/19.
//  Copyright © 2019 iTexico. All rights reserved.
//

import Foundation

class MovieDetailViewModel {
    private var movieId: Int = 0
    
    func setMovie(id: Int) {
        movieId = id
        WSHelper.sharedInstance.getMovieDetail(id: movieId) { (response, error) in
            guard error == nil else {
                self.onError?(error!)
                return
            }
            self.movieDetailFetched?(response!.value!)
        }
    }
    
    var movieDetailFetched: ((_ movie: MovieDetail) -> ())?
    var onError: ((_ error: Error) -> ())?
}
