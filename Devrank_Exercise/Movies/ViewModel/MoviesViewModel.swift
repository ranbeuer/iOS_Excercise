//
//  MoviesViewModel.swift
//  iOS_Exercise
//
//  Created by Leonardo Cid on 4/6/19.
//  Copyright © 2019 iTexico. All rights reserved.
//

import Foundation

class MoviesViewModel {
    var popularMovies = [Movie]()
    var topMovies = [Movie]()
    var popularMoviesPage = 1
    var topMoviesPage = 1
    var moviesChanged: ((_ movies: [Movie]) -> ())?
    var onError: ((_ error: Error) -> ())?
    let getMoreThreshold = 1
    var lastType: MoviesType = .Popular
    private var gettingMore: Bool = false
    
    init() {
        
    }
    
    func getPopularMovies(_ more: Bool = false) {
        lastType = .Popular
        if (popularMovies.count == 0 || more) {
            if (more) {
                popularMoviesPage += 1
            }
            WSHelper.sharedInstance.getMovies(type: .Popular, page: popularMoviesPage) { (response, error) in
                self.gettingMore = false
                guard error != nil else {
                    let moviesResponse = response?.value
                    self.popularMovies.append(contentsOf: moviesResponse?.results! as! [Movie])
                    self.moviesChanged!(self.popularMovies)
                    return
                }
                self.onError!(error!)
            }
        } else {
            self.moviesChanged!(self.popularMovies)
        }
    }
    
    func getTopMovies(_ more: Bool = false) {
        lastType = .TopRated
        if (topMovies.count == 0 || more) {
            if (more) {
                topMoviesPage += 1
            }
            WSHelper.sharedInstance.getMovies(type: .TopRated, page: topMoviesPage) { (response, error) in
                self.gettingMore = false
                guard error != nil else {
                    let moviesResponse = response?.value
                    self.topMovies.append(contentsOf: moviesResponse?.results! as! [Movie])
                    self.moviesChanged!(self.topMovies)
                    return
                }
                self.onError!(error!)
            }
        } else {
            self.moviesChanged!(self.topMovies)
        }
    }
    
    func getGenres(result:@escaping () -> Void) {
        WSHelper.sharedInstance.getGenres { (response, error) in
            guard error != nil else {
                let genreResponse = response?.value
                allGenres = genreResponse?.genres
                result()
                return
            }
            
        }
    }
    
    func toggleMovies() {
        if (lastType == .Popular) {
            getTopMovies()
        } else {
            getPopularMovies()
    }
    }
    
    func checkForMore(movieIndex: NSInteger) -> Bool{
        guard gettingMore == true else {
            var movies = lastType == .Popular ? popularMovies : topMovies
            if (movieIndex >= movies.count - getMoreThreshold) {
                gettingMore = true
                if (lastType == .Popular) {
                    getPopularMovies(true)
                } else {
                    getTopMovies(true)
                }
            }
            return gettingMore
        }
        return gettingMore
    }
}
