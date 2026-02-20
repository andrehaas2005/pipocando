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
  var method: HTTPMethod {
    get {
      APISerieRequest.defaultMethod(for: path)
    }
  }
  let body: Data?
  var paramenters: Parameters
  
  public init(path: RouterSerie, body: Data? = nil, paramenters: Parameters = Parameters() ) {
    self.path = path
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
    case .details:
      base["append_to_response"] = ""
    }
    return base
  }
  
  private static func defaultMethod(for path: RouterSerie) -> HTTPMethod {
    switch path {
    case .airingToday, .onTheAir, .popular, .topRated, .details:
      return .get
    }
  }
}
