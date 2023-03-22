//
//  NetworkRequests.swift

//
//    on 21.10.2021.
//

import Foundation

extension Request {
  
  static func signIn(email: String, passcode: String) -> Request<AuthResponse> {
    with(.init(path: "login", parser: .default)) {
      $0.method = .post
      $0["email"] = email
      $0["loginCode"] = passcode
    }
  }
  
  static func videos(date: String) -> Request<[Video]> {
    with(.init(path: "videos",
               parser: .default)) {
      $0.method = .get
      $0["date"] = date
    }
  }
  
  static func sendFeedback(_ feedback: Feedback) -> Request<ServerConfirmation> {
    with(.init(path: "feedbacks", parser: .default)) {
      $0.method = .post
      $0["rate"] = feedback.rating
      $0["description"] = feedback.message
      $0["category"] = feedback.reason
      $0["userEmail"] = feedback.email
    }
  }
  
  static func sendMessage(_ message: String, email: String) -> Request<ServerConfirmation> {
    with(.init(path: "feedbacks", parser: .default)) {
      $0.method = .post
      $0["description"] = message
      $0["userEmail"] = email
    }
  }
  
  static func registerPushToken(_ token: String, deviceKey: String) -> Request<ServerConfirmation> {
    with(.init(path: "pushTokens", parser: .default)) {
      $0.method = .post
      $0["notificationToken"] = token
      $0["deviceKey"] = deviceKey
    }
  }
  
  static func logout(refreshToken: String, deviceKey: String) -> Request<ServerConfirmation> {
    with(.init(path: "logout", parser: .default)) {
      $0.method = .post
      $0["refreshToken"] = refreshToken
      $0["deviceKey"] = deviceKey
    }
  }
  
}
