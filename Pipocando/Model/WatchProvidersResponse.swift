import Foundation

public struct WatchProvidersResponse: Decodable {
  let results: [String: CountryWatchProvider]
}

struct CountryWatchProvider: Decodable {
  let flatrate: [ProviderItem]?
  let rent: [ProviderItem]?
  let buy: [ProviderItem]?
}

struct ProviderItem: Decodable {
  let providerName: String

  enum CodingKeys: String, CodingKey {
    case providerName = "provider_name"
  }
}
