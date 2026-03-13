//
//  MovieDetailsRepository.swift
//  Pipocando
//

import Foundation

protocol MovieDetailsRepository {
  func fetchMovieDetails(_ movieID: Int) async throws -> MovieDetails
}
