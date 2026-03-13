//
//  SerieService.swift
//  Pipocando
//
//  Created by Andre  Haas on 19/02/26.
//

import Foundation
import Alamofire

protocol SerieRequesting {
  func request<T: Decodable>(_ request: APISerieRequest) async throws -> T
}

extension NetworkSerieService: SerieRequesting {}

class SerieService: SerieServiceProtocol {
  let service: SerieRequesting

  init(service: SerieRequesting) {
    self.service = service
  }
  
  
  func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    
  }
  
  func fetchSerieOnTheAir(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    let request = APISerieRequest(path: .onTheAir)
    Task { [weak self] in
      await self?.fetchWithAsync(request) { completion($0) }
    }
  }
  
  func fetchSeriePopular(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    let request = APISerieRequest(path: .popular)
    Task { [weak self] in
      await self?.fetchWithAsync(request) { completion($0) }
    }
  }
  
  func fetchSerieAiringToday(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    let request = APISerieRequest(path: .airingToday)
    Task { [weak self] in
      await self?.fetchWithAsync(request) { completion($0) }
    }
  }
  
  func fetchSerieDetails(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    let request = APISerieRequest(path: .topRated)
    Task { [weak self] in
      await self?.fetchWithAsync(request) { completion($0) }
    }
  }
  
  
  func fetchSerieTopReted(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    let request = APISerieRequest(path: .topRated)
    Task { [weak self] in
      await self?.fetchWithAsync(request) { completion($0) }
    }
  }
  
  //MARK: - Call with async
  private func fetchWithAsync(_ request: APISerieRequest, completion: @escaping (Result<[Serie], any Error>) -> Void) async {
    do {
      let response: Cover<Serie> = try await service.request(request)
      completion(.success(response.results))
    } catch {
      completion (.failure(error))
    }
  }
}
