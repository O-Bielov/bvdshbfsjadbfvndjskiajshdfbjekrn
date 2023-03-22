import Foundation

struct Constants {
  
  static let serverUrlPath = "www.google.com"
  static let appId = "123456789" // TODO: actual identifer
  static var appUrlString: String { "https://apps.apple.com/app/\(appId)" }
  
  static let passcodeLength = 6
  
  struct Feedback {
    static var experienceDescriptors: [Int: [String]] {
      let lowRate = ["feedback.low_rate_reason.poor_experience",
                     "feedback.low_rate_reason.inappropriate_content",
                     "feedback.low_rate_reason.content_issues",
                     "feedback.low_rate_reason.tech_issues"]
        .map(get(\.localized))
      
      let midRate = ["feedback.mid_rate_reason.num_of_creators",
                     "feedback.mid_rate_reason.better_content",
                     "feedback.mid_rate_reason.better_experience",
                     "feedback.mid_rate_reason.more_videos"]
        .map(get(\.localized))
      
      let highRate = ["feedback.high_rate_reason.user_experience",
                      "feedback.high_rate_reason.content",
                      "feedback.high_rate_reason.idea"]
        .map(get(\.localized))
      
      return [1: lowRate,
              2: lowRate,
              3: lowRate,
              4: midRate,
              5: highRate]
    }
  }

}
    
