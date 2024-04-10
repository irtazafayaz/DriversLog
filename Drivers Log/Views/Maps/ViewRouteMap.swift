//
//  ViewRouteMap.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 11/04/2024.
//

import Foundation
import GoogleMaps
import SwiftUI

struct ViewRouteMap: View {
    
    @State private var mapView: GoogleMapsView

    init(coordinates: [CLLocationCoordinate2D]) {
        self.mapView = GoogleMapsView(coordinates: coordinates)
    }
    
    var body: some View {
        mapView
            .edgesIgnoringSafeArea(.all)
    }
}

