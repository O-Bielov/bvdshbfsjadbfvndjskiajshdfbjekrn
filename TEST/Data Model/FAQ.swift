//
//  FAQ.swift

//
//    on 28.10.2021.
//

import Foundation

protocol FAQItem {
  
}

struct FAQ {
  
  let chapters: [Chapter]
  
}

extension FAQ {
  
  struct Chapter: FAQItem, Equatable, Hashable {
    
    static func == (lhs: FAQ.Chapter, rhs: FAQ.Chapter) -> Bool {
      lhs.uid == rhs.uid
    }
    
    let uid = UUID()
    let title: String
    let questions: [Question]
    
    func hash(into hasher: inout Hasher) {
      uid.hash(into: &hasher)
    }
  }
  
  struct Question: FAQItem, Hashable, Equatable {
    
    static func == (lhs: FAQ.Question, rhs: FAQ.Question) -> Bool {
      lhs.uid == rhs.uid
    }
    let uid = UUID()
    let title: String
    let answer: String
    let moreInfoLink: String
    
    func hash(into hasher: inout Hasher) {
      uid.hash(into: &hasher)
    }
  }
  
  static func buildFAQ() -> FAQ {
    let q1 = Question(title: "How I share the video", answer: lorem, moreInfoLink: "www.google.com")
    let q2 = Question(title: "How does the app work?", answer: lorem, moreInfoLink: "")
    let c1 = Chapter(title: "How it works?", questions: [q1, q2])
        
    let q3 = Question(title: "Is my phone supported?", answer: lorem, moreInfoLink: "")
    let q4 = Question(title: "Is the Mobile App secure?", answer: lorem, moreInfoLink: "")
    let q5 = Question(title: "What features does the Mobile App have?", answer: lorem, moreInfoLink: "")
    let c2 = Chapter(title: "System related questions", questions: [q3, q4, q5])
        
    let q6 = Question(title: "Do I have to buy the Mobile App?", answer: lorem, moreInfoLink: "")
    let q7 = Question(title: "I have multiple accounts. Can I see them all in the Mobile App and the Mobile Website?", answer: lorem, moreInfoLink: "")
    let c3 = Chapter(title: "Support related questions", questions: [q6, q7])
    
    
    return .init(chapters: [c1, c2, c3])
  }
  
}

private let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam odio dolor, lacinia quis ligula vel, finibus lobortis eros. Sed eget orci quam. Aenean metus est, faucibus vitae erat id, tempor aliquam diam."


