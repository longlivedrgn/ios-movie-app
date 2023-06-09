//
//  NetworkDispatcher.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct NetworkDispatcher {

    typealias NetworkResult = Result<Data, NetworkError>

    func performRequest(_ urlRequest: URLRequest?) async throws -> NetworkResult {
        let session = URLSession.shared

        guard let urlRequest else { return .failure(.invalidURL) }

        let (data, response) = try await session.data(for: urlRequest)
        guard response.isValidResponse else { return .failure(.outOfResponseCode) }

        return .success(data)
    }

}
