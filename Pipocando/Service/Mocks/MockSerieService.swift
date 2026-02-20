//
//  MockSerieService.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/MockSerieService.swift
import Foundation

class MockSerieService: SerieServiceProtocol {
  func fetchSerieOnTheAir(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    
  }
  
  func fetchSeriePopular(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    
  }
  
  func fetchSerieAiringToday(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    
  }
  
  func fetchSerieDetails(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    
  }
  
  func fetchSerieTopReted(completion: @escaping (Result<[Serie], any Error>) -> Void) {
    
  }
  
    func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], Error>) -> Void) {
        DispatchQueue(label: "Mock").asyncAfter(deadline: .now() + 1.1, execute: {
            completion(.success(Utilits.getObject("ListaSeriesPopular")))
        })
    }
}
