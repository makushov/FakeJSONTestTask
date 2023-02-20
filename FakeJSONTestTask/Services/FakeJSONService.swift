//
//  FakeJSONParsing.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import Foundation

protocol FakeJSONServiceProtocol {
    
    func parseFakeJSONData(_ data: [String]) -> [[String: String]]
}

final class FakeJSONService: FakeJSONServiceProtocol {
    
    /// without regular expression (faster)
    func parseFakeJSONData(_ data: [String]) -> [[String: String]] {
        var dictionaries = [[String: String]]()
        
        for string in data {
            let characters: [Character] = string.map { $0 }
            var dotsPointer: Int = -1
            var comaPointer: Int = -1
            var memoKey: String = ""
            var cache: [String: String] = [:]
            for (index, value) in characters.enumerated() {
                if value == "," {
                    comaPointer = index
                    continue
                }
                guard value == ":", comaPointer >= dotsPointer else { continue }
                if !memoKey.isEmpty {
                    cache[memoKey] = String(characters[dotsPointer + 1 ... comaPointer - 1])
                }
                memoKey = String(characters[comaPointer + 1 ... index - 1])
                dotsPointer = index
            }
            cache[memoKey] = String(characters[dotsPointer + 1 ... characters.count - 1])
            dictionaries.append(cache)
            
        }
        
        return dictionaries
    }

    /// using regular expression (slower)
//    func parseFakeJSONData(_ data: [String]) -> [[String: String]] {
//        var dictionaries = [[String: String]]()
//
//        for string in data {
//            let pattern = #"(^|,)[a-z]+:"#
//            let regex = try! NSRegularExpression(pattern: pattern)
//            let matches = regex.matches(
//                in: string,
//                range: .init(
//                    location: 0,
//                    length: string.utf16.count
//                )
//            )
//
//            var result: [String: String] = [:]
//            for (index, match) in matches.enumerated() {
//                let rangeKey = match.range
//                let locationValue = rangeKey.location + rangeKey.length
//                let lengthValue: Int
//                if index + 1 < matches.count {
//                    lengthValue = matches[index + 1].range.location - locationValue
//                } else {
//                    lengthValue = string.utf16.count - locationValue
//                }
//                let rangeValue = NSRange(location: locationValue, length: lengthValue)
//
//                if let key = Range(rangeKey, in: string),
//                   let value = Range(rangeValue, in: string) {
//                    let name = String(string[key])
//                        .replacingOccurrences(of: ":", with: "")
//                        .replacingOccurrences(of: ",", with: "")
//                    let value = String(string[value])
//                    result[name] = value
//                }
//            }
//
//            dictionaries.append(result)
//        }
//
//        return dictionaries
//    }
}
