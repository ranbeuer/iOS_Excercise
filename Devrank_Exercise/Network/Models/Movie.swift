//
//  Movie.swift
//  iOS_Exercise
//
//  Created by Leonardo Cid on 4/5/19.
//  Copyright © 2019 iTexico. All rights reserved.
//

import Foundation
import ObjectMapper

class Movie : Mappable {
    var voteCount: Int?
    var id: Int?
    var isVideo: Bool?
    var voteAverage: Float?
    var title: String?
    var popularity: Float?
    var posterPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overView: String?
    var releaseDate: String?
    var forAdults: Bool?
    var genreIds: [Int]?
    
    required init?(map: Map){
        
    }
    
    var imageUrl : String {
        get {
            return "https://image.tmdb.org/t/p/w185" + posterPath!
        }
    }
    
    func mapping(map: Map) {
        voteCount <- map["vote_count"]
        id  <- map["id"]
        isVideo <- map["video"]
        voteAverage <- map["vote_average"]
        title <- map["title"]
        popularity <- map["popularity"]
        posterPath <- map["poster_path"]
        originalLanguage <- map["original_language"]
        originalTitle <- map["original_title"]
        genreIds <- map["genre_ids"]
        forAdults <- map["adult"]
        overView <- map["overview"]
        releaseDate <- map["release_date"]
    }
}
