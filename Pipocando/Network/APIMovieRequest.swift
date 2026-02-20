//
//  APIMovieRequest.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//

import Alamofire
import Foundation

public struct APIMovieRequest {
  let path: RouterMovie
  var method: HTTPMethod {
    get {
      APIMovieRequest.defaultMethod(for: path)
    }
  }
  let body: Data?
  var paramenters: Parameters
  
  public init(path: RouterMovie, body: Data? = nil, paramenters: Parameters = Parameters() ) {
    self.path = path
    self.body = body
    self.paramenters = APIMovieRequest.defaultParameters(for: path).merging(paramenters) { (_, new) in new }
  }
  
  private static func defaultParameters(for path: RouterMovie) -> Parameters {
    var base: Parameters = [ "language": "pt-BR",
                             "page": "1"]
    switch path {
    case .topRated, .nowPlaying, .popular, .upcoming:
      base["region"] = "BR"
    case .details:
      base["append_to_response"] = "videos,credits"
    }
    
    
    
    
    
    return base
  }
  
  private static func defaultMethod(for path: RouterMovie) -> HTTPMethod {
    switch path {
    case .topRated, .nowPlaying, .popular, .upcoming, .details:
      return .get
    }
  }
}
