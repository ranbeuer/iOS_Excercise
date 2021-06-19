//
//  Genre.swift
//  Devrank_Exercise
//
//  Created by Jose Leonardo Cid Fabila on 18/06/21.
//

import Foundation
import ObjectMapper

var allGenres:[Genre]?

struct GenreResponse: Mappable {
    var genres: [Genre]?
    init?(map: Map){
        
    }
    mutating func mapping(map: Map) {
        genres <- map["genres"]
    }
    
}
