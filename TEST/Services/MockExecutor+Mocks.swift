//
//  MockExecutor+Mocks.swift

//
//    on 21.10.2021.
//

import Foundation

extension MockRequestExecutor {
  
  func setupMocks() {
//    mockAuth()
//    mockVideos()
//    mockFeedback()
//    mockSayHello()
  }
  
}

private extension MockRequestExecutor {
 
  func mockAuth() {
    forRequest(.signIn(email: "", passcode: ""),
               mock: .success(.init(accessToken: "mocked_token", deviceKey: "111", refreshToken: "111")))
  }
  
  func mockVideos() {
    let author = Creator(id: "1234", name:  "Austin Hankwitz", tiktokId: "234", imageUrl: "", tiktokUrl: "", externalUrl: "213")
    
    let video = Video(id: "1231231", fileName: "123", creator: author, downloadUrl: "123123")
    
    forRequest(.videos(date: ""), mock: .success([video]))
  }
  
  func mockFeedback() {
    forRequest(.sendFeedback(.init(rating: 0, reason: "", message: "", email: "")), mock: .success(ServerConfirmation()))
  }
  
  func mockSayHello() {
    forRequest(.sendMessage("", email: ""), mock: .success(ServerConfirmation()))
  }
  
}
