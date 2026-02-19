//
//  NetworkServiceProtocol.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//

protocol NetworkServiceProtocol {
  func request<T: Decodable>(_ request: APIMovieRequest) async throws -> T
}

protocol NetworkSerieServiceProtocol {
  func request<T: Decodable>(_ request: APISerieRequest) async throws -> T
}

