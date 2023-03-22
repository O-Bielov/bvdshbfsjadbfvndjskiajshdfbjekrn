//
//  MockRequestExecutor.swift

//
//    on 21.10.2021.
//

import Foundation

final class MockRequestExecutor: RequestExecuting {
  
  private var tasks = Set<AnyDataTask>()
  
  private let rng = TrueRandomNumberGenerator()
  
  @discardableResult
  func execute<T>(_ request: Request<T>) -> DataTask<T>? {
    guard let gen = mockedResponseMap[getHash(from: request)],
          let result = gen.run(rng) as? Result<T, Error> else { return nil }
    
    let task = DataTask<T>()
    
    let after = After(delay: 1.2) {
      task.completion.send(result)
    }
    
    task.cancelAction = { after.cancel() }

    tasks.insert(task.asAnyTask())

    return task
  }
  
  private var mockedResponseMap = [Int: Gen<Any>]()
  
  func forRequest<T>(_ request: Request<T>,
                     _ responseGen: Gen<Any>) {
    mockedResponseMap[getHash(from: request)] = responseGen
  }
  
  func forRequest<T>(_ request: Request<T>, mock: Result<T, Error>) {
    mockedResponseMap[getHash(from: request)] = .always(mock)
  }
  
}

private extension MockRequestExecutor {

  func getHash<T>(from request: Request<T>) -> Int {
    normalizedPath(from: request).hash
//      &+ request.params.keys.sorted().joined().hash
    &+ String(describing: request.method).hash
  }
    
  func normalizedPath<T>(from request: Request<T>) -> String {
    let comps = request.path.components(separatedBy: "/")
    let compsExcludingIds = comps.filter {
      $0.filter { $0 == "-" }.count != 4
    }
    return compsExcludingIds.joined()
  }
  
}
