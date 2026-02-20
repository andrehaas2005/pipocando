//
//  NetworkMovieService.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Foundation
import Alamofire

final class NetworkMovieService: NetworkServiceProtocol {
  private let session: Session
  public static let shared = NetworkMovieService()
  
  public init(session: Session = AlamofireSessionProvider.shared) {
    self.session = session
  }
  
  func request<T>(_ request: APIMovieRequest) async throws -> T where T : Decodable {
    guard let baseUrl = Configuration.baseAPIURL else {
      throw NetworkMovieError.notfoundUrlBase
    }
    
    guard let apiKey = Configuration.apiKey else {
      throw NetworkMovieError.notfoundApiKey
    }
    
    let url = baseUrl + request.path.path()
    
    let headers: HTTPHeaders = [ "Accept" : "application/json",
                                 "Authorization" : "Bearer \(apiKey)"]
    
    
    return try await withCheckedThrowingContinuation { continuation in
      
      session.request(url,
                      method: request.method,
                      parameters: request.paramenters,
                      encoding: URLEncoding.default,
                      headers: headers)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: T.self) { response in
        
        switch response.result {
        case .success(let value):
          continuation.resume(returning: value)
        case .failure(let error):
          print("""
              🔴 ===============================
              🔴 ERROR
              🔴 CODE: \(String(describing: error.destinationURL?.absoluteString))
              🔴 DOMAIN: \(String(describing: error.responseCode))
              🔴 DESCRIPTION: \(error.localizedDescription)
              🔴 ===============================
              """)
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

