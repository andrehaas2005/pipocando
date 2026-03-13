import Foundation

final class SeriesRepositoryImpl: SeriesRepository {
  private let remoteDataSource: any SerieRemoteDataSource

  init(remoteDataSource: any SerieRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  func fetchTopRatedSeries() async throws -> [Serie] {
    try await remoteDataSource.fetchTopRatedSeries()
  }
}
