//
//  HubView.swift
//  DonkeyBike
//
//  Created by Aleksander Maj on 30/12/2022.
//

import SwiftUI

struct HubView: View {
    @ObservedObject var model: HubModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Available vehicles:")
                    .font(.title3)

                Divider()

                ForEach(VehicleType.allCases, id: \.rawValue) { vehicleType in
                    Text("\(vehicleType.rawValue): \(self.model.hub.availableCount(for: vehicleType))")
                        .font(.body)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(self.model.hub.name)
    }
}

class HubModel: ObservableObject {
    @Published var hub: Hub

    init(hub: Hub) {
        self.hub = hub
    }

    func fetchHubData(id: Int) async {
        do {
            let hub = try await HubResource(id: id).fetch()
            self.hub = hub
        } catch {
            print("Error:", error)
        }
    }
}

struct HubView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HubView(model: .init(hub: .mock))
        }
    }
}
