//
//  Networking.swift
//  DonkeyBike
//
//  Created by Aleksander Maj on 30/12/2022.
//

import Foundation
import MapKit

protocol WebResource {
    associatedtype A: Decodable

    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension WebResource {
    var urlRequest: URLRequest {
        var urlComponents = Current.baseURLComponents
        urlComponents.path = self.path
        urlComponents.queryItems = self.queryItems

        var request = URLRequest(url: urlComponents.url!)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/com.donkeyrepublic.v4", forHTTPHeaderField: "Accept")

        return request
    }

    func fetch() async throws -> A {
        let (data, response) = try await URLSession.shared.data(for: self.urlRequest)
        let httpResponse = response as! HTTPURLResponse
        guard 200..<300 ~= httpResponse.statusCode else {
            throw HTTPError(response: httpResponse)
        }

        let result = try Current.jsonDecoder.decode(A.self, from: data)
        return result
    }
}

struct HTTPError: Error {
    let response: HTTPURLResponse
}

struct NearbyResource: WebResource {
    let region: MKCoordinateRegion

    typealias A = Nearby

    let path = "/api/public/nearby"

    var queryItems: [URLQueryItem] {
        [
            .init(name: "filter_type", value: "radius"),
            .init(name: "radius", value: String(Int(region.radius))),
            .init(name: "location", value: region.center.urlEncoded)
        ]
    }
}

struct HubResource: WebResource {
    let id: Int

    typealias A = Hub

    var path: String {
        "/api/public/hubs/\(id)/bike"
    }

    let queryItems = [URLQueryItem]()
}

extension CLLocationCoordinate2D {
    var urlEncoded: String {
        String(format: "%.7f,%.7f", latitude, longitude)
    }
}
