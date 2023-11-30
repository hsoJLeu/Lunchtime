//
//  Network.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import Foundation

class Network {
    private var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
        session.configuration.requestCachePolicy = .returnCacheDataElseLoad
    }

    func data(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)

        let urlResponse = response as! HTTPURLResponse

        if urlResponse.statusCode != 200 {
            if !data.isEmpty {
                if let errModel = try decode(data: data, model: ErrorModel.self) {
                    print("\(urlResponse.statusCode)\n\(errModel.error.message)")
                }
            }
            throw NetworkError.badStatusCode
        }

        return data
    }

    enum NetworkError: Error {
        case badStatusCode
    }

    struct ErrorModel: Decodable {
        var error: ErrorContent

        struct ErrorContent: Decodable {
            var code: Int
            var message: String
        }
    }

}
