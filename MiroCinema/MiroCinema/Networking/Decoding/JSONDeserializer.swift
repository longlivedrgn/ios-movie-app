//
//  JSONDeserializer.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

final class JSONDeserializer {

    private let decoder = JSONDecoder()

    func deserialize(type: Decodable.Type, data: Data) throws -> Decodable {
        try decoder.decode(type.self, from: data)
    }

}

