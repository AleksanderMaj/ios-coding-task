//
//  DonkeyBikeApp.swift
//  DonkeyBike
//
//  Created by Aleksander Maj on 29/12/2022.
//

import SwiftUI

@main
struct DonkeyBikeApp: App {
    let model = MapModel(region: .cph)

    var body: some Scene {
        WindowGroup {
            MapView(model: self.model)
            .onOpenURL { url in
                self.model.open(url: url)
            }
        }
    }
}

extension URL {
    var destination: MapModel.Destination? {
        guard self.scheme == "donkeybike" else { return nil }
        switch self.host() {
        case "hub": return .hubDetails(.init(hub: .mock))
        default: return nil
        }
    }
}
