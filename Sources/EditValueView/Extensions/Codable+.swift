//
//  Codable+.swift
//  
//
//  Created by p-x9 on 2022/10/22.
//  
//

import Foundation

extension Encodable {
    private static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
    
    var jsonString: String?  {
        guard let data = try? Self.jsonEncoder.encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

extension Decodable {
    private static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    static func value(from jsonString: String) -> Self? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        return try? Self.jsonDecoder.decode(Self.self, from: data)
    }
}
