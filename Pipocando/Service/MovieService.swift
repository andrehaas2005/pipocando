//
//  MovieService.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import Foundation
import Alamofire

final class MovieService: MovieServiceProtocol {
  let service = NetworkMovieService.shared
  public static let shared = MovieService()
  
  func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
    Task { [weak self] in
      await self?.fetchNowPlayingMoviesWithTask{ completion($0) }
    }
  }
  
  func fetchNowPlayingMoviesWithTask(completion: @escaping (Result<[Movie], any Error>) -> Void) async {
    let request = APIMovieRequest(path: .nowPlaying, method: .get)
    do {
      let response: Cover<Movie> = try await service.request(request)
      completion(.success(response.results))
    } catch {
      completion(.failure(error))
    }
  }
}
