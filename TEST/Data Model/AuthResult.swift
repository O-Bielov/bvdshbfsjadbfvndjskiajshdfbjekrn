//
//  AuthResult.swift

//
//    on 27.10.2021.
//

import Foundation

typealias AuthToken = String

struct AuthResponse: Decodable {
  
  let accessToken: AuthToken
  let deviceKey: String
  let refreshToken: String
  
}


struct AuthResult {
  
  let accessToken: AuthToken
  let email: String
  let deviceKey: String
  
}
