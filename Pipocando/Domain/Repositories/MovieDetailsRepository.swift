//
//  MovieDetailsRepository.swift
//  Pipocando
//

import Foundation

protocol MovieDetailsRepository {
  func fetchMovieDetails(_ movieID: Int, completion: @escaping (Result<MovieDetails, AppError>) -> Void)
}
