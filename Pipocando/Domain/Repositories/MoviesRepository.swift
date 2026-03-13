//
//  MoviesRepository.swift
//  Pipocando
//

import Foundation

protocol MoviesRepository {
  func fetchNowPlayingMovies() async throws -> [Movie]
}
