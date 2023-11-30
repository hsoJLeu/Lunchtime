//
//  Store.swift
//  LunchTime
//
//  Created by Josh Leung on 11/29/23.
//

import Foundation

@MainActor
class BookmarkStore: ObservableObject {
    @Published private var places: Set<String> = []

    init() {
        Task {
            try await load()
        }
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("places.data")
    }

    func contains(_ placeId: String) -> Bool {
        return places.contains { $0 == placeId }
    }

    func load() async throws {
        let task = Task<[String], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let places = try JSONDecoder().decode([String].self, from: data)
            return places
        }
        let places = try await task.value
        print(places)
        _ = places.map { item in
            self.places.insert(item)
        }
    }

    func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(places)
            let fileUrl = try Self.fileURL()
            try data.write(to: fileUrl)
        }

        try await task.value
    }

    func add(_ place: String) {
        objectWillChange.send()
        places.insert(place)
        Task {
            try await save()
        }
    }

    func remove(_ place: String) {
        objectWillChange.send()
        places.remove(place)
        Task {
            try await save()
        }
    }
}
