//
//  MapView.swift
//  Enroute
//
//  Created by Valerie 👩🏼‍💻 on 07/01/2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    let annotations: [MKAnnotation]
    @Binding var selection: MKAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        mkMapView.addAnnotations(self.annotations)
        return mkMapView
    }
    
    // updating a SwiftUI view by changes
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = selection {
            
            /// span is how much to "zoom"
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: town), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selection: $selection)
    }
    
    // must to be class
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selection: MKAnnotation?
        
        init(selection: Binding<MKAnnotation?>) {
            self._selection = selection
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MyMapViewAnnotation") ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MyMapViewAnnotation")
            view.canShowCallout = true
            return view
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                selection = annotation
            }
        }
    }
}
