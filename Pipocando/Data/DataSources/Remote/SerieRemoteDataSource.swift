import Foundation

protocol SerieRemoteDataSource {
  func fetchTopRatedSeries() async throws -> [Serie]
}

final class DefaultSerieRemoteDataSource: SerieRemoteDataSource {
  private let serieService: any SerieServiceProtocol

  init(serieService: any SerieServiceProtocol) {
    self.serieService = serieService
  }

  func fetchTopRatedSeries() async throws -> [Serie] {
    try await withCheckedThrowingContinuation { continuation in
      serieService.fetchSerieTopReted { result in
        switch result {
        case .success(let series):
          continuation.resume(returning: series)
        case .failure(let error):
          continuation.resume(throwing: AppError.map(error))
        }
      }
    }
  }
}
