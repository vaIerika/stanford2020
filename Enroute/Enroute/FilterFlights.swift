//
//  FilterFlights.swift
//  Enroute
//
//  Created by Valerie 👩🏼‍💻 on 03/01/2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    
    // MARK: - Lecture 11
    // @ObservedObject var allAirports = Airports.all
    // @ObservedObject var allAirlines = Airports.all
    
    // MARK: - Lecture 12
    @FetchRequest(fetchRequest: Airport.fetchRequest(.all)) var airports: FetchedResults<Airport>
    @FetchRequest(fetchRequest: Airline.fetchRequest(.all)) var airlines: FetchedResults<Airline>
    
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
                    ForEach(airports.sorted(), id: \.self) { airport in
                        Text("\(airport.friendlyName)").tag(airport)
                    }
                }
                Picker("Origin", selection: $draft.origin) {
                    Text("Any").tag(Airport?.none)
                    ForEach(airports.sorted(), id: \.self) { (airport: Airport?) in
                        Text("\(airport?.friendlyName ?? "Any")").tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(Airline?.none)
                    ForEach(airlines.sorted(), id: \.self) { (airline: Airline?) in
                        Text("\(airline?.friendlyName ?? "Any")").tag(airline)
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
            if draft.destination != flightSearch.destination {
                draft.destination.fetchIncomingFlights()
            }
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
