import Alamofire
import Foundation

enum AlamofireSessionProvider {
  static func makeSession() -> Session {
    let config = URLSessionConfiguration.af.default
    config.timeoutIntervalForRequest = 30
    config.timeoutIntervalForResource = 30
    return Session(configuration: config)
  }
}
