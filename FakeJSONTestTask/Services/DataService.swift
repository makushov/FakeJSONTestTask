//
//  DataService.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import Foundation

protocol DataServiceProtocol {
    
    func loadData() -> [String]?
}

final class DataService: DataServiceProtocol {
    
    func loadData() -> [String]? {
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([String].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
