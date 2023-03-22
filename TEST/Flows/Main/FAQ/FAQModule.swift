//
//  FAQModule.swift

//
//    on 28.10.2021.
//

import Foundation

final class FAQModule: Module {
  
  private var unfoldedChapters = Set<FAQ.Chapter>()
  private var unfoldedQuestions = Set<FAQ.Question>()
  
  let faq = FAQ.buildFAQ()
  
  private var itemCount: Int { allItems.count }
  
  private var allItems = [FAQItem]()
  
  override func didMoveToParent() {
    super.didMoveToParent()
        
    refreshItems()
  }
  
  func isChapterFolded(_ chapter: FAQ.Chapter) -> Bool {
    !unfoldedChapters.contains(chapter)
  }
  
  func isQuestionUnfold(_ question: FAQ.Question) -> Bool {
    unfoldedQuestions.contains(question)
  }
  
  func numberOfItems() -> Int {
    return itemCount
  }
  
  func isChapter(at indexPath: IndexPath) -> Bool {
    allItems[indexPath.item] is FAQ.Chapter
  }
  
  func item(at indexPath: IndexPath) -> FAQItem {
    allItems[indexPath.item]
  }
  
  func toggleFoldState(for chapter: FAQ.Chapter) -> FAQStateUpdate {
    if unfoldedChapters.contains(chapter) {
      unfoldedChapters.remove(chapter)
      
      let indexOfChapterItem = allItems.firstIndex {
        if let otherChapter = $0 as? FAQ.Chapter, otherChapter == chapter {
          return true
        }
        return false
      }!
      let firstIndex = indexOfChapterItem + 1
      refreshItems()
      return .init(inserts: [], deletions: Array(firstIndex..<(firstIndex + chapter.questions.count)))
    } else {
      unfoldedChapters.insert(chapter)
      
      let indexOfChapterItem = allItems.firstIndex {
        if let otherChapter = $0 as? FAQ.Chapter, otherChapter == chapter {
          return true
        }
        return false
      }!
      let firstIndex = indexOfChapterItem + 1
      refreshItems()
      return .init(inserts: Array(firstIndex..<firstIndex + chapter.questions.count), deletions: [])
    }
  }
  
  func toggleFoldStateForQuestion(_ question: FAQ.Question) {
    if unfoldedQuestions.contains(question) {
      unfoldedQuestions.remove(question)
    } else {
      unfoldedQuestions.insert(question)
    }
  }
  
}

private extension FAQModule {
  
  func refreshItems() {
    allItems = []
    faq.chapters.forEach {
      allItems.append($0)
        if unfoldedChapters.contains($0) {
          allItems.append(contentsOf: $0.questions)
        }
    }
  }
}


