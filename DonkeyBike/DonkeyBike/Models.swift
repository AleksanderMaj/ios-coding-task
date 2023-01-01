//
//  Models.swift
//  DonkeyBike
//
//  Created by Aleksander Maj on 29/12/2022.
//

import Foundation
import CoreLocation
import MapKit

struct Nearby: Decodable {
    var hubs: [Hub]
}

struct Hub: Decodable, Identifiable, Equatable {
    internal init(id: Int, coordinate: CLLocationCoordinate2D,name: String, availableVehicles: [VehicleType : Int]) {
        self.id = id
        self.coordinate = coordinate
        self.name = name
        self.availableVehicles = availableVehicles
    }

    var id: Int
    var coordinate: CLLocationCoordinate2D
    var name: String
    private var availableVehicles: [VehicleType: Int]

    enum CodingKeys: CodingKey {
        case id
        case latitude
        case longitude
        case name
        case availableVehicles
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let latitude = CLLocationDegrees(try container.decode(String.self, forKey: .latitude)) ?? .zero
        let longitude = CLLocationDegrees(try container.decode(String.self, forKey: .longitude)) ?? .zero
        self.coordinate = .init(latitude: latitude, longitude: longitude)
        self.name = try container.decode(String.self, forKey: .name)
        let availableVehicles = try container.decode([String: Int].self, forKey: .availableVehicles)
        self.availableVehicles = availableVehicles.reduce(into: [:]) { result, x in
            VehicleType(rawValue: x.key).map { result[$0] = x.value }
        }
    }

    func availableCount(for vehicleType: VehicleType) -> Int {
        self.availableVehicles[vehicleType] ?? 0
    }

    var availableVehiclesCount: Int {
        availableVehicles.values.reduce(0,+)
    }
}

enum VehicleType: String, Decodable, CaseIterable {
    case bike, ebike, trailer, escooter
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Hub {
    static let mock = Self(
        id: 1,
        coordinate: .cph,
        name: "Donkey Republic HQ",
        availableVehicles: [.bike : 3, .ebike : 3, .escooter: 2]
    )
}
