//
//  RequestExecuting.swift

//
//    on 10.02.2021.
//

import Foundation

protocol RequestExecuting {
  
  @discardableResult
  func execute<T>(_ request: Request<T>) -> DataTask<T>?
  
}
