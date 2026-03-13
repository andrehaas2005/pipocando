//
//  AppLogger.swift
//  Pipocando
//

import Foundation

enum LogCategory: String {
  case network = "network"
  case navigation = "navigation"
  case uiState = "ui-state"
}

enum AppLogger {
  static func debug(_ message: String, category: LogCategory) {
    print("🟦 [\(category.rawValue)] \(message)")
  }

  static func error(_ message: String, category: LogCategory) {
    print("🟥 [\(category.rawValue)] \(message)")
  }
}
