//
//  MapView.swift
//  DonkeyBike
//
//  Created by Aleksander Maj on 29/12/2022.
//

import Combine
import MapKit
import SwiftUI
import SwiftUINavigation

// Debounce map region updates
// Move as much processing as possible to a non-main thread
// Implement clustering

struct MapView: View {
    @ObservedObject var model: MapModel

    var body: some View {
        Map(
            coordinateRegion: self.$model.region,
            annotationItems: self.model.hubs,
            annotationContent: { hub in
                MapAnnotation(coordinate: hub.coordinate) {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                            .background(Circle().fill(.orange))
                        Text(String(hub.availableVehiclesCount))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        withAnimation {
                            self.model.onHubSelected(hub)
                        }
                    }
                }
            }
        )
        .ignoresSafeArea()
        .sheet(
            unwrapping: self.$model.destination,
            case: /MapModel.Destination.hubDetails
        ) {
            $hubModel in
            NavigationStack {
                HubView(model: hubModel)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(model: MapModel(region: .cph))
    }
}

class MapModel: ObservableObject {
    @Published var region: MKCoordinateRegion {
        didSet {
            Task {
                await self.fetchHubs(region: self.region)
            }
        }
    }
    @Published var hubs: [Hub]
    @Published var destination: Destination?

    init(region: MKCoordinateRegion, hubs: [Hub] = [], destination: Destination? = nil) {
        self.region = region
        self.hubs = hubs
        self.destination = destination
    }
    
    @MainActor func onHubSelected(_ hub: Hub) {
        self.destination = .hubDetails(.init(hub: hub))
    }

    func fetchHubs(region: MKCoordinateRegion) async {
        do {
            let nearby = try await NearbyResource(region: region).fetch()
            self.hubs = nearby.hubs
        } catch {
            print("Error:", error)
        }
    }

    func open(url: URL) {
        if let destination = url.destination {
            self.destination = destination
        }
    }

    enum Destination {
        case hubDetails(HubModel)
    }
}

extension MKCoordinateRegion {
    static let cph = Self(center: .cph, latitudinalMeters: 200, longitudinalMeters: 200)
}

extension CLLocationCoordinate2D {
    static let cph = Self(latitude: 55.6761, longitude: 12.5683)
}

extension MKCoordinateRegion {
    var radius: CLLocationDistance {
        let corner = MKMapPoint(
            .init(
                latitude: maxLatitude,
                longitude: maxLongitude
            )
        )
        return MKMapPoint(self.center).distance(to: corner)
    }

    var minLatitude: CLLocationDegrees {
        self.center.latitude - 0.5 * self.span.latitudeDelta
    }

    var maxLatitude: CLLocationDegrees {
        self.center.latitude + 0.5 * self.span.latitudeDelta
    }

    var minLongitude: CLLocationDegrees {
        self.center.longitude - 0.5 * self.span.longitudeDelta
    }

    var maxLongitude: CLLocationDegrees {
        self.center.longitude + 0.5 * self.span.longitudeDelta
    }
}

extension MKCoordinateRegion {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        return cos((self.center.latitude - coordinate.latitude) * Double.pi / 180) > cos(self.span.latitudeDelta / 2.0 * Double.pi / 180)
        && cos((self.center.longitude - coordinate.longitude) * Double.pi / 180) > cos(self.span.longitudeDelta / 2.0 * Double.pi / 180)
    }

    func subregionsByDividingInto(rows: Int, columns: Int) -> [MKCoordinateRegion] {
        var subregions = [MKCoordinateRegion]()
        for row in 0..<rows {
            for column in 0..<columns {
                subregions.append(
                    MKCoordinateRegion(
                        center: .init(
                            latitude: self.minLatitude + ((Double(row) + 0.5)/Double(rows)) * self.span.latitudeDelta,
                            longitude: self.minLongitude + ((Double(column) + 0.5)/Double(columns)) * self.span.longitudeDelta
                        ),
                        span: .init(
                            latitudeDelta: self.span.latitudeDelta / Double(rows),
                            longitudeDelta: self.span.longitudeDelta / Double(columns)
                        )
                    )
                )
            }
        }
        return subregions
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude
        && lhs.center.longitude == rhs.center.longitude
        && lhs.span.latitudeDelta == rhs.span.latitudeDelta
        && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
