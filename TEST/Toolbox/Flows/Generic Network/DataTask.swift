//
//  DataTask.swift

//
//    on 10.02.2021.
//

import Foundation

final class DataTask<T>: Hashable {
  
  private(set) var isCompleted = false
  
  let completion = Pipe<Result<T, Error>>()
  
  let uuid = UUID()
  
  var cancelAction: (() -> Void)!
  var destructor: (() -> Void)?
  
  private var subscriptionForCompletion: Subscription?
  
  init() {
    subscriptionForCompletion = completion.observe { [weak self] _ in
      self?.isCompleted = true
    }
  }
  
  func cancel() {
    cancelAction()
  }
  
  func hash(into hasher: inout Hasher) {
    uuid.hash(into: &hasher)
  }
  
  func complete(with result: Result<T, Error>) {
    completion.send(result)
    destructor?()
  }
  
}

extension DataTask: Equatable {
  
  static func == (lhs: DataTask, rhs: DataTask) -> Bool {
    lhs.uuid == rhs.uuid
  }
  
}

struct AnyDataTask: Hashable {
  
  let task: Any
  let uuid: UUID
  
  var isCompleted: Bool {
    _isCompleted()
  }
  
  var destructor: (() -> Void)?
    
  private let _isCompleted: () -> Bool
  
  func hash(into hasher: inout Hasher) {
    uuid.hash(into: &hasher)
  }
  
  static func ==(lhs: AnyDataTask, rhs: AnyDataTask) -> Bool {
    lhs.uuid == rhs.uuid
  }
  
  fileprivate init(task: Any,
                   uid: UUID,
                   isCompleted: @escaping () -> Bool,
                   destructor: (() -> Void)?) {
    self.task = task
    self.uuid = uid
    _isCompleted = isCompleted
  }
  
}

extension DataTask {
  
  func asAnyTask() -> AnyDataTask {
    AnyDataTask(task: self,
                uid: uuid,
                isCompleted: { [weak self] in
      self?.isCompleted ?? true
    }, destructor: self.destructor)
  }
  
}



