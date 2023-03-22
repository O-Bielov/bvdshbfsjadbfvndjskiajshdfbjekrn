//
//  SlackLogger.swift

//
//    on 09.11.2021.
//

import Foundation

final class SlackLogger {
    
  var channel = InstallInfo.id
  
  func log(_ object: Any) {
    let url = URL(string: "https://slack.com/api/chat.postMessage")!
    var req = URLRequest(url: url)
    req.httpMethod = "POST"

    req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
    var comps = URLComponents()
    comps.queryItems = [URLQueryItem(name: "channel", value: channel),
                        URLQueryItem(name: "text", value: String(describing: object))
    ]

    req.httpBody = comps.query?.data(using: .utf8)

    URLSession.shared.dataTask(with: req) { data, response, error in }.resume()
  }
  
}
