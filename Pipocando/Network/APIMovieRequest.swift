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
  let method: HTTPMethod
  let body: Data?
  
  public init(path: RouterMovie, method: HTTPMethod, body: Data? = nil) {
    self.path = path
    self.method = method
    self.body = body
  }
}
