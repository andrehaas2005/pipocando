//
//  NetworkLogConfig.swift
//  Pipocando
//
//  Created by Andre  Haas on 20/02/26.
//


//
//  File.swift
//  ModuloServiceMovie
//
//  Created by Andre  Haas on 09/02/26.
//

import Foundation

enum NetworkLogConfig {
  static let isEnabled = true
}
enum NetworkLogger {
  
  static func logRequest(_ request: URLRequest) {
    guard NetworkLogConfig.isEnabled else { return }
    
    print("""
        🔵 ===============================
        🔵 REQUEST
        🔵 URL: \(request.url?.absoluteString ?? "nil")
        🔵 METHOD: \(request.httpMethod ?? "nil")
        🔵 HEADERS: \(request.allHTTPHeaderFields ?? [:])
        🔵 BODY: \(request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? "nil")
        🔵 ===============================
        """)
  }
  
  static func logResponse(
    data: Data?,
    response: URLResponse?,
    duration: TimeInterval
  ) {
    guard NetworkLogConfig.isEnabled else { return }
    
    let httpResponse = response as? HTTPURLResponse
    let statusCode = httpResponse?.statusCode ?? -1
    let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? "nil"
    
    print("""
        🟢 ===============================
        🟢 RESPONSE
        🟢 STATUS CODE: \(statusCode)
        🟢 TIME: \(String(format: "%.2f", duration))s
        🟢 BODY: \(body)
        🟢 ===============================
        """)
  }
  
  static func logError(_ error: Error, duration: TimeInterval) {
    guard NetworkLogConfig.isEnabled else { return }
    
    let nsError = error as NSError
    
    print("""
        🔴 ===============================
        🔴 ERROR
        🔴 CODE: \(nsError.code)
        🔴 DOMAIN: \(nsError.domain)
        🔴 DESCRIPTION: \(nsError.localizedDescription)
        🔴 TIME: \(String(format: "%.2f", duration))s
        🔴 ===============================
        """)
  }
}
