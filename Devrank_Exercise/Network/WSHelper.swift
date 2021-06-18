//
//  WSHelper.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 7/29/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

public enum MoviesType : String  {
    case Popular = "movie/popular"
    case TopRated = "movie/top_rated"
    case MovieDetail = "movie/"
}


class WSHelper {
    
    
    
    let kAPIKey = "9660e09bc51564013f36b33514250a3f"
    
    
    /// Indicates if the application is pointing to prod or dev env
    static let devEnv = false
    /// Configurable base URL, it can be either prod or dev
    private static var baseURL = "http://api.themoviedb.org/3/"
    /// If set to true it will let the application to show the requests and responses
    static let logEverything = false
    
    static let USE_AFNETWORKING = false
    
    /// Singleton instance
    static let sharedInstance = WSHelper()
    
    typealias ResultBlockForMovies = (_ response: DataResponse<MoviesResponse>?, _ error: Error?)-> Void
    

    typealias ResultBlock = (_ response: Any?, _ error: Error?)-> Void
    
    var language: String = ""
    
    init() {
        language = Locale.current.languageCode!
    }
    
    static func setBaseURL(_ url: String) {
        baseURL = url
    }
    
    static func getBaseURL() -> String! {
        return WSHelper.baseURL
    }
    
    
    func getMovies(type: MoviesType, page: Int, result: @escaping ResultBlockForMovies) {
        let url = WSHelper.getBaseURL() + type.rawValue
        
        let parameters = ["api_key" : kAPIKey, "page":page, "language": language] as [String : Any]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseObject(completionHandler: {  (response: DataResponse<MoviesResponse>) in
            switch response.result {
            case .success:
                if (WSHelper.logEverything) {
                    let data = response.data as Data?
                    let jsonString = String(data: data!, encoding: .utf8)
                    print(jsonString!)
                }
                result(response, nil)
                break;
            case .failure(let error):
                if (WSHelper.logEverything) {
                    print(error)
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(String(describing: json))")
                    }
                }
                result(nil, error)
            }
        })
    }
    
    
    
//    func send
    func printJson(_ anyobj: Any?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: anyobj!, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString!)
            // here "decoded" is of type `Any`, decoded from JSON data
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
