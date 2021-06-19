//
//  Movie.swift
//  Devrank_Exercise
//
//  Created by Leonardo Cid on 6/18/21.
//  Copyright © 2021 Leonardo Cid. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieDetail : Mappable {
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
    var genres: [Genre]?
    var backdropPath: String?
    var productionCompanies: [Company]?
    var status: String?
    var tagline: String?
    var runtime: Int?
    
    init?(map: Map){
        
    }
    
    var imageUrl : String {
        get {
            guard posterPath != nil else {
                return ""
            }
            return "https://image.tmdb.org/t/p/w185" + posterPath!
        }
    }
    
    var backdropUrl : String {
        get {
            guard backdropPath != nil else {
                return ""
            }
            return "https://image.tmdb.org/t/p/w500" + backdropPath!
        }
    }
        
    mutating func mapping(map: Map) {
        backdropPath <- map["backdrop_path"]
        forAdults <- map["adult"]
        genres <- map["genres"]
        id  <- map["id"]
        originalLanguage <- map["original_language"]
        originalTitle <- map["original_title"]
        overView <- map["overview"]
        popularity <- map["popularity"]
        posterPath <- map["poster_path"]
        productionCompanies <- map["production_companies"]
        releaseDate <- map["release_date"]
        status <- map["status"]
        tagline <- map["tagline"]
        title <- map["title"]
        isVideo <- map["video"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
        runtime <- map["runtime"]
    }
}

struct Genre : Mappable {
    var id: Int?
    var name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
    var description: String {
        return name!
    }
}

struct Company : Mappable {
    var id: Int?
    var name: String?
    var originCountry: String?
    var logoPath: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        logoPath <- map["logo_path"]
        originCountry <- map["origin_country"]
    }
}

