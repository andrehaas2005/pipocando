//
//  NetworkMovieError.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//

enum NetworkMovieError: Error {
  case invalidURL
  case networkError
  case notfoundUrlBase
  case notfoundApiKey
}

enum AppError: Error {
  case network
  case invalidConfiguration
  case invalidResponse
  case unknown(message: String)

  var userMessage: String {
    switch self {
    case .network:
      return "Não foi possível carregar os dados. Verifique sua conexão."
    case .invalidConfiguration:
      return "Configuração inválida do aplicativo."
    case .invalidResponse:
      return "Resposta inválida do servidor."
    case .unknown(let message):
      return message
    }
  }
}

extension AppError {
  static func map(_ error: Error) -> AppError {
    if let error = error as? AppError {
      return error
    }

    if let networkError = error as? NetworkMovieError {
      switch networkError {
      case .networkError:
        return .network
      case .notfoundApiKey, .notfoundUrlBase:
        return .invalidConfiguration
      case .invalidURL:
        return .invalidResponse
      }
    }

    return .unknown(message: error.localizedDescription)
  }
}
