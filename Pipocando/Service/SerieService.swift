//
//  SerieService.swift
//  Pipocando
//
//  Created by Andre  Haas on 19/02/26.
//

import Foundation

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

  func fetchSeriesAiring(on date: String, completion: @escaping (Result<[Serie], any Error>) -> Void) {
    let request = APISerieRequest(
      path: .discover,
      paramenters: [
        "air_date.gte": date,
        "air_date.lte": date
      ]
    )
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
      let response: Cover<Serie> = try await fetchAllPages(request: request)
      completion(.success(response.results))
    } catch {
      completion (.failure(error))
    }
  }

  private func fetchAllPages(request: APISerieRequest) async throws -> Cover<Serie> {
    var page = 1
    var allResults: [Serie] = []
    var totalPages = 1
    var totalResults = 0

    repeat {
      let pageRequest = request.with(page: page)
      let response: Cover<Serie> = try await service.request(pageRequest)
      allResults.append(contentsOf: response.results)
      totalPages = response.totalPages
      totalResults = response.totalResults
      page += 1
    } while page <= totalPages

    return Cover(page: totalPages, results: allResults, totalPages: totalPages, totalResults: totalResults)
  }
}
