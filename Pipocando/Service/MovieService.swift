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

  func fetchPopularMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
    
  }
  
  func fetchTopRatedMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
    
  }
  
  func fetchUpcomingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
    
  }
  
  func fetchMovieDetails(_ movie_id: Int, completion: @escaping (Result<MovieDetails, any Error>) -> Void) {
    let request = APIMovieRequest(path: .details(movie_id))
    Task { [weak self] in
      await self?.fetchWithDetailsAsync(request){ completion($0) }
    }
  }
  
  func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
    let request = APIMovieRequest(path: .nowPlaying)
    Task { [weak self] in
      await self?.fetchWithAsync(request){ completion($0) }
    }
  }
  
  
  //MARK: - CAll With Async
  func fetchWithAsync(_ request: APIMovieRequest, completion: @escaping (Result<[Movie], any Error>) -> Void) async {
    do {
      let response: Cover<Movie> = try await service.request(request)
      completion(.success(response.results))
    } catch {
      completion(.failure(error))
    }
  }
  
  func fetchWithDetailsAsync(_ request: APIMovieRequest, completion: @escaping (Result<MovieDetails, any Error>) -> Void) async {
    do {
      let response: MovieDetails = try await service.request(request)
      completion(.success(response))
    } catch {
      completion(.failure(error))
    }
  }
}
