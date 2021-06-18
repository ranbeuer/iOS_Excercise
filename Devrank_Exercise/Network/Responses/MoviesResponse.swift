//
//  EventsResponse.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/29/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import ObjectMapper

class MoviesResponse : Mappable {
    var results : Array<Movie>?
    var page : Int?
    var totalPages : Int?
    var totalResults : Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        results <- map["results"]
        page <- map["page"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
    }
}
