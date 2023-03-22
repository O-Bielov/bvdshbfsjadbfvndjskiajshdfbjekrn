//
//  CredentialStore.swift

//
//    on 19.10.2021.
//

import Foundation

final class CredentialStore {
        
  private let defaults = UserDefaults.standard
  
  init() {
    credentials = unarchiveCredentials()
  }
  
  private(set) var credentials: SessionCredentials? {
    didSet {
      archiveCredentials(credentials)
    }
  }
    
  func updateRefreshToken(with newRefreshToken: String) {
    credentials?.refreshToken = newRefreshToken
  }
  
  func receiveCredentials(_ newCredentials: SessionCredentials) {
    credentials = newCredentials
  }
  
  func clearCredentials() {
    credentials = nil
  }
  
}

private extension CredentialStore {
  
  func unarchiveCredentials() -> SessionCredentials? {
    guard let data = defaults.data(forKey: String(describing: SessionCredentials.self)),
          let credentials = try? JSONDecoder().decode(SessionCredentials.self, from: data) else {
            return nil
          }
    return credentials
  }
  
  func archiveCredentials(_ newCredentials: SessionCredentials?) {
    if let data = try? JSONEncoder().encode(newCredentials) {
      defaults.setValue(data, forKey: String(describing: SessionCredentials.self))
    }
  }
  
}
