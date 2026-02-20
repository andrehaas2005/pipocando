//
//  MovieServiceProtocol.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//

public protocol MovieServiceProtocol {
  func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
  func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
  func fetchTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
  func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
  
  func fetchMovieDetails(_ movie_id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void)
}
