//
//  APISerieRequest.swift
//  Pipocando
//
//  Created by Andre  Haas on 14/02/26.
//
import Foundation
import Alamofire

public struct APISerieRequest {
  let path: RouterSerie
  let method: HTTPMethod
  let body: Data?
  var paramenters: Parameters
  
  public init(path: RouterSerie, method: HTTPMethod, body: Data? = nil, paramenters: Parameters = Parameters() ) {
    self.path = path
    self.method = method
    self.body = body
    self.paramenters = APISerieRequest.defaultParameters(for: path).merging(paramenters) { (_, new) in new }
  }
  
  private static func defaultParameters(for path: RouterSerie) -> Parameters {
    var base: Parameters = [ "language": "pt-BR",
                             "page": "1"]
    switch path {
    case .airingToday, .onTheAir:
      base["timezone"] = "America/Sao_Paulo"
    
    case .popular, .topRated:
     break
    }
    return base
  }
}
