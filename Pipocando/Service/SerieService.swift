//
//  SerieService.swift
//  Pipocando
//
//  Created by Andre  Haas on 19/02/26.
//

import Foundation
import Alamofire

class SerieService: SerieServiceProtocol {

  
  let service: NetworkSerieService
  public static var shared: SerieService = .init()
  
  init(service: NetworkSerieService = .shared) {
    self.service = service
  }
  
  func fetchSerieTopReted(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    Task { [weak self] in
      await self?.fetchSerieTopRetedWithAsync { completion($0) }
    }
  }
  
 private func fetchSerieTopRetedWithAsync(completion: @escaping (Result<[Serie], any Error>) -> Void) async {
    let request = APISerieRequest(path: .topRated, method: .get)
    do {
      let response: Cover<Serie> = try await service.request(request)
      completion(.success(response.results))
    } catch {
      completion (.failure(error))
    }
  }
  
  func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    
  }
  
}
