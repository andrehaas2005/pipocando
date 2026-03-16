import Foundation
import FirebaseFirestore
import UIKit

struct MoviePreference: Codable {
  let movieID: Int
  let movieTitle: String
  var isFavorite: Bool
  var wantToWatch: Bool
  var isWatched: Bool
  var whereToWatch: [String: Bool]
  let userKey: String
  let updatedAt: TimeInterval

  var asDictionary: [String: Any] {
    [
      "movieID": movieID,
      "movieTitle": movieTitle,
      "isFavorite": isFavorite,
      "wantToWatch": wantToWatch,
      "isWatched": isWatched,
      "whereToWatch": whereToWatch,
      "userKey": userKey,
      "updatedAt": updatedAt
    ]
  }

  static func fromDictionary(_ dict: [String: Any], movieID: Int, movieTitle: String, userKey: String) -> MoviePreference {
    MoviePreference(
      movieID: dict["movieID"] as? Int ?? movieID,
      movieTitle: dict["movieTitle"] as? String ?? movieTitle,
      isFavorite: dict["isFavorite"] as? Bool ?? false,
      wantToWatch: dict["wantToWatch"] as? Bool ?? false,
      isWatched: dict["isWatched"] as? Bool ?? false,
      whereToWatch: dict["whereToWatch"] as? [String: Bool] ?? [:],
      userKey: dict["userKey"] as? String ?? userKey,
      updatedAt: dict["updatedAt"] as? TimeInterval ?? Date().timeIntervalSince1970
    )
  }
}

final class MoviePreferenceStore {
  static let shared = MoviePreferenceStore()

  private let db = Firestore.firestore()
  private let collectionName = "moviePreferences"
  private let userKey: String

  private init() {
    let defaultsKey = "pipocando.device.userKey"
    let defaults = UserDefaults.standard
    if let existing = defaults.string(forKey: defaultsKey), !existing.isEmpty {
      userKey = existing
    } else {
      let generated = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
      userKey = generated
      defaults.set(generated, forKey: defaultsKey)
    }
  }

  private func documentID(for movieID: Int) -> String {
    "\(userKey)_\(movieID)"
  }

  func fetch(movieID: Int, movieTitle: String, completion: @escaping (MoviePreference) -> Void) {
    db.collection(collectionName).document(documentID(for: movieID)).getDocument { [userKey] snapshot, _ in
      guard let data = snapshot?.data() else {
        let empty = MoviePreference(
          movieID: movieID,
          movieTitle: movieTitle,
          isFavorite: false,
          wantToWatch: false,
          isWatched: false,
          whereToWatch: [:],
          userKey: userKey,
          updatedAt: Date().timeIntervalSince1970
        )
        completion(empty)
        return
      }

      completion(MoviePreference.fromDictionary(data, movieID: movieID, movieTitle: movieTitle, userKey: userKey))
    }
  }

  func save(_ preference: MoviePreference, completion: ((Error?) -> Void)? = nil) {
    db.collection(collectionName)
      .document(documentID(for: preference.movieID))
      .setData(preference.asDictionary, merge: true) { error in
        completion?(error)
      }
  }
}
