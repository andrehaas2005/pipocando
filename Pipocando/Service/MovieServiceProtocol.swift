//
//  MovieServiceProtocol.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//

public protocol MovieServiceProtocol {
  func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
}
