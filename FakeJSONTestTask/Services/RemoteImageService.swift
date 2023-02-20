//
//  RemoteImageService.swift
//  FakeJSONTestTask
//
//  Created by Stanislav Makushov on 19.02.2023.
//

import UIKit

typealias DownloadImageCompletion = (Result<UIImage, Error>) -> Void

protocol RemoteImageServiceProtocol {
    
    func image(for url: URL, completion: @escaping DownloadImageCompletion)
}

enum DownloadImageError: Error {
    
    case dataCorrupted
}

final class RemoteImageService: RemoteImageServiceProtocol {
    
    private var cache: [String: UIImage] = [:]
    private let writeSemaphore = DispatchSemaphore(value: 1)
    private let queue = DispatchQueue(label: "com.fakejsontesttask.queue", attributes: .concurrent)
    
    func image(for url: URL, completion: @escaping DownloadImageCompletion) {
        queue.async { [weak self] in
            if let image = self?.cache[url.absoluteString] {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        self?.saveToCache(image, for: url)
                        DispatchQueue.main.async {
                            completion(.success(image))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(DownloadImageError.dataCorrupted))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func saveToCache(_ image: UIImage, for url: URL) {
        writeSemaphore.wait()
        cache.updateValue(image, forKey: url.absoluteString)
        writeSemaphore.signal()
    }
}
