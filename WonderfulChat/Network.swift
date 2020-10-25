//
//  Network.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import Foundation

enum NetworkError: Error {
    case noData
}

class Network {

    private let decoder = JSONDecoder()

    func get<T: Decodable>(from url: URL, _ type: T.Type, completion: @escaping (Result<T, Error>)->()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard let data = data else { return completion(.failure(NetworkError.noData)) }
            do {
                let model = try self.decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
