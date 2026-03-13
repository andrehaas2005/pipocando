//
//  NetworkSerieService.swift
//  Pipocando
//
//  Created by Andre  Haas on 14/02/26.
//

import Alamofire
import Foundation


final class NetworkSerieService: NetworkSerieServiceProtocol {
  private let session: Session
  public static let shared = NetworkSerieService()

  public init(session: Session = AlamofireSessionProvider.shared) {
    self.session = session
  }

  func request<T>(_ request: APISerieRequest) async throws -> T where T: Decodable {
    guard let baseUrl = Configuration.baseAPIURL else {
      AppLogger.error("Missing BASE_URL configuration", category: .network)
      throw NetworkMovieError.notfoundUrlBase
    }

    guard let apiKey = Configuration.apiKey else {
      AppLogger.error("Missing API_KEY configuration", category: .network)
      throw NetworkMovieError.notfoundApiKey
    }

    let url = baseUrl + request.path.path()

    let headers: HTTPHeaders = ["Accept": "application/json",
                                "Authorization": "Bearer \(apiKey)"]

    AppLogger.debug("Request started: \(request.path.path())", category: .network)

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
          AppLogger.debug("Request succeeded: \(request.path.path())", category: .network)
          continuation.resume(returning: value)
        case .failure(let error):
          AppLogger.error(
            "Request failed: \(request.path.path()) code=\(String(describing: error.responseCode)) desc=\(error.localizedDescription)",
            category: .network
          )
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
