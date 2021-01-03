//
//  FilterFlights.swift
//  Enroute
//
//  Created by Valerie 👩🏼‍💻 on 03/01/2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    @ObservedObject var allAirports = Airports.all
    @ObservedObject var allAirlines = Airports.all
    
    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool
    
    @State private var draft: FlightSearch
    
    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Destination", selection: $draft.destination) {
                    ForEach(allAirports.codes, id: \.self) { airport in
                        Text("\(allAirports[airport]?.friendlyName ?? airport)").tag(airport)
                    }
                }
                Picker("Origin", selection: $draft.origin) {
                    Text("Any").tag(String?.none)
                    ForEach(allAirports.codes, id: \.self) { (airport: String?) in
                        Text("\(allAirports[airport]?.friendlyName ?? airport ?? "Any")").tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(String?.none)
                    ForEach(allAirports.codes, id: \.self) { (airline: String?) in
                        Text("\(allAirlines[airline]?.friendlyName ?? airline ?? "Any")").tag(airline)
                    }
                }
                Toggle(isOn: $draft.inTheAir) { Text("Enroute Only") }
            }
            .navigationBarTitle("Filter Flights")
            .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
    var done: some View {
        Button("Done") {
            flightSearch = draft
            isPresented = false
        }
    }
}

//struct FilterFlights_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterFlights()
//    }
//}
