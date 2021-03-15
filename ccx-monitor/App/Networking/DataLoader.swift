//
//  DataLoader.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import Foundation
import Combine

class DataLoader<E> where E: Endpoint {
        
    func request<T: Decodable>(_ type: T.Type, from endpoint: E) -> AnyPublisher<T, NetworkError> {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.urlRequest()!)
            .mapError { error -> NetworkError in
                return NetworkError.invalidURL(message: error.localizedDescription)
            }
            .map { $0.data }
            .mapError { error -> NetworkError in
                return NetworkError.unknown(message: "Error getting network data: \(error.localizedDescription)")
            }
            .tryMap { try decoder.decode(type, from: $0) }
            .mapError { error -> NetworkError in
                return NetworkError.decoding(message: "Failed to decode: \(error.localizedDescription)")
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
