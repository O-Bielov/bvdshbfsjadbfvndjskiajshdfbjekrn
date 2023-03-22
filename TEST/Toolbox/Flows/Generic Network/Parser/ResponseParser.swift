//
//  ResponseParser.swift

//
//    on 09.02.2021.
//

import Foundation

typealias JSON = Dictionary<String, Any>

extension JSON {
  
  func get<T>(_ key: String) throws -> T {
    if let value = self[key] as? T {
      return value
    }
    
    throw ParserError()
  }
  
}

struct ResponseParser<T> {
  fileprivate var parser: (Data) throws -> T
  
  func parse(data: Data) throws -> T {
    try parser(data)
  }
}

extension ResponseParser {
  
  static func custom<T>(_ parser: @escaping (Data) throws -> T) -> ResponseParser<T> {
    ResponseParser<T>(parser: parser)
  }
  
}

extension ResponseParser where T: AirtableObject {
  
  static var collection: ResponseParser<[T]> {
    ResponseParser<[T]> {
      do {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withFullTime, .withTimeZone, .withFractionalSeconds]
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
          let container = try decoder.singleValueContainer()
                  let dateStr = try container.decode(String.self)
          let date = formatter.date(from: dateStr)
          guard let d = date else {
            throw ParserError()
          }
          return d
        }
        let json = try ResponseParser.rawDictionary.parse(data: $0)
        let records: [JSON] = json["records"]! as! [JSON]
        
        let recordContents: [JSON] = records.map {
          var fields = $0["fields"] as! JSON
          fields["uid"] = $0["id"]
          return fields
        }
        
        return try recordContents.map(T.init)
      } catch {
        throw ParserError()
      }
    }
  }
}

extension ResponseParser where T: Decodable {
  static var `default`: ResponseParser<T> {
    ResponseParser<T> {
      do {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withFullTime, .withTimeZone, .withFractionalSeconds]
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
          let container = try decoder.singleValueContainer()
                  let dateStr = try container.decode(String.self)
          let date = formatter.date(from: dateStr)
          guard let d = date else {
            throw ParserError()
          }
          return d
        }
        let result = try decoder.decode(T.self, from: $0, keyPath: "payload")
        return result
      } catch {
        throw ParserError()
      }
    }
  }
}

extension ResponseParser {
  static var rawDictionary: ResponseParser<JSON> {
    .init {
      do {
        if let json = try JSONSerialization.jsonObject(
            with: $0,
            options: .mutableContainers) as? JSON {
          return json
        } else {
          throw ParserError()
        }
      } catch {
        throw ParserError()
      }
    }
  }
    
  static var binary: ResponseParser<Data> {
    .init(parser: id)
  }
  
  static func field<T>(_ key: String) throws -> ResponseParser<T> {
    return ResponseParser<T> {
      let jsonParser = ResponseParser.rawDictionary
      let json = try jsonParser.parse(data: $0)
      if let result = json[key] as? T {
        return result
      } else {
        throw ParserError()
      }
    }
  }
  
  static func keyPath<T>(_ keyPath: String...) -> ResponseParser<T> {
    return ResponseParser<T> {
      let jsonParser = ResponseParser.rawDictionary
      var json = try jsonParser.parse(data: $0)
      for key in keyPath {
        if let nextContainer = json[key] as? JSON, key != keyPath.last {
          json = nextContainer
        } else if let result = json[key] as? T {
          return result
        }
      }
      throw ParserError()
    }
  }
}

struct ParserError: Error {}
struct ServerConfirmation: Decodable {}
