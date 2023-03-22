//
//  CredentialStoreProviding.swift

//
//    on 15.11.2021.
//

import Foundation

protocol CredentialStoreProviding {
  
  var credentialStore: CredentialStore { get }
  
}

extension CredentialStoreProviding {
  
  
  var sessionCredentials: SessionCredentials? {
    credentialStore.credentials
  }
  
  func updateRefreshToken(with newRefreshToken: String) {
    credentialStore.updateRefreshToken(with: newRefreshToken)
  }
 
}

extension Module {
  
  var credentialStoreProvider: CredentialStoreProviding? {
    firstPredecessor(ofType: CredentialStoreProviding.self)
  }
  
}
