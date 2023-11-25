//
//  ApiService.swift
//  LunchTime
//
//  Created by Josh Leung on 11/17/23.
//

import Foundation

class ApiService {
    private let searchNearbyURL = "https://places.googleapis.com/v1/places:searchNearby"
    private let textSearchURL = "https://places.googleapis.com/v1/places:textSearch"

    private let network: Network

    init(network: Network = .init()) {
        self.network = network
    }

    private func getApiKey(from key: String) -> String? {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            print("Unable to retrieve key from infoDict. Please check key passed.")
            return nil
        }

        return value
    }

    private func setHTTPHeaders(maskTypes: [Constants.FieldMasks], from request: inout URLRequest) {
        if let apiKey = getApiKey(from: Constants.apiKey) {

            request.setValue(Constants.appJson,
                             forHTTPHeaderField: Constants.contentType)
            request.setValue(apiKey,
                             forHTTPHeaderField: Constants.XGoogApiKey)
            request.setValue(setFieldMasks(types: maskTypes),
                             forHTTPHeaderField: Constants.XGoogFieldMask)
        }
    }

    private func setFieldMasks(types: [Constants.FieldMasks]) -> String {
        var fieldMask = ""
        for mask in types {
            if mask == types.first {
                fieldMask.append("\(mask.rawValue)")
            }
            fieldMask.append(",\(mask.rawValue)")
        }
        return fieldMask
    }

    private func setQueryParams(for url: URL,
                                items: [URLQueryItem]) -> URL? {
        var component = URLComponents(url: url, resolvingAgainstBaseURL: true)
        component?.queryItems = items

        guard let returnUrl = component?.url else {
            debugPrint("Unable to set query params to url. Please check url.")
            return nil
        }
        return returnUrl
    }

    private func buildRequest(with data: Data,
                              method: HTTPMethod,
                              url: URL) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data

        let masks: [Constants.FieldMasks] = [
            .id,
            .displayName,
            .formattedAddress,
            .shortFormattedAddress,
            .googleMapsUri,
            .location,
            .rating,
            .userRatingCount,
            .editorialSummary]
        setHTTPHeaders(maskTypes: masks,from: &request)

        debugPrint(request.description)

        return request
    }

    func getNearbySearchRequest(locale: Center) async throws -> [Place] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes

        let encodedData = try encoder.encode(SearchNearbyRequest(maxResultCount: 10,
                                                                locationRestriction: LocationRestriction(circle: Circle(center: locale, radius: 1000))))

        guard let url = URL(string: placesURL) else { throw APIError.badURL }
        let request = buildRequest(with: encodedData, method: .post, url: url)

        let data = try await network.data(request: request)

        let model = try? decode(data: data, model: Places.self)
        debugPrint(model)
        return model?.places ?? []
    }

    enum APIError: Error {
        case badURL
    }

    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    struct Constants {
        static let XGoogFieldMask = "X-Goog-FieldMask"
        static let XGoogApiKey = "X-Goog-Api-Key"
        static let contentType = "Content-Type"
        static let appJson = "application/json"
        static let bearer = "Bearer"
        static let apiKey = "API_KEY"
        static let term = "term"
        static let limit = "limit"
        static let limitValue = "15"
        static let sortBy = "sort_by"
        static let bestMatch = "best_match"
        static let location = "location"
        static let locationValue = "Los Angeles"


        enum FieldMasks:String {
            case accessibilityOptions = "places.accessibilityOptions"
            case addressComponents = "places.addressComponents"
            case businessStatus = "places.businessStatus"
            case displayName = "places.displayName"
            case formattedAddress = "places.formattedAddress"
            case shortFormattedAddress = "places.shortFormattedAddress"
            case googleMapsUri = "places.googleMapsUri"
            case id = "places.id"
            case location = "places.location"
            case photos = "places.photos"
            case priceLevel = "places.priceLevel"
            case rating = "places.rating"
            case userRatingCount = "places.userRatingCount"
            case regularOpeningHours = "places.regularOpeningHours"
            case currentOpeningHours = "places.currentOpeningHours"
            case editorialSummary = "places.editorialSummary"
//            places.viewport
        }
    }
}

public func decode< T: Decodable >(data: Data, model: T.Type) throws -> T? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(model.self, from: data)
    } catch {
        debugPrint("\(error)")
    }
    return nil
}
