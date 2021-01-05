//
//  FlightsEnrouteView.swift
//  Enroute
//
//  Created by CS193p Instructor.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import CoreData

// MARK: - Lecture 11
//struct FlightSearch {
//    var destination: String
//    var origin: String?
//    var airline: String?
//    var inTheAir: Bool = true
//}

// MARK: - Lecture 12
struct FlightSearch {
    var destination: Airport
    var origin: Airport?
    var airline: Airline?
    var inTheAir: Bool = true
}

struct FlightsEnrouteView: View {
    @Environment(\.managedObjectContext) var context
    @State var flightSearch: FlightSearch
    
    var body: some View {
        NavigationView {
            FlightList(flightSearch)
                .navigationBarItems(leading: simulation, trailing: filter)
        }
    }
    
    @State private var showFilter = false
    
    var filter: some View {
        Button("Filter") {
            self.showFilter = true
        }
        .sheet(isPresented: $showFilter) {
            FilterFlights(flightSearch: self.$flightSearch, isPresented: self.$showFilter)
                .environment(\.managedObjectContext, context)
        }
    }
    
    // if no FlightAware credentials exist in Info.plist
    // then we simulate data from KSFO and KLAS (Las Vegas, NV)
    // the simulation time must match the times in the simulation data
    // so, to orient the UI, this simulation View shows the time we are simulating
    var simulation: some View {
        let isSimulating = Date.currentFlightTime.timeIntervalSince(Date()) < -1
        return Text(isSimulating ? DateFormatter.shortTime.string(from: Date.currentFlightTime) : "")
    }
}

struct FlightList: View {
    
    // MARK: - Lecture 11
//    @ObservedObject var flightFetcher: FlightFetcher
//
//    init(_ flightSearch: FlightSearch) {
//        self.flightFetcher = FlightFetcher(flightSearch: flightSearch)
//    }
//
//    var flights: [FAFlight] { flightFetcher.latest }
    
    // MARK: - Lecture 12
    @FetchRequest var flights: FetchedResults<Flight>
    
    init(_ flightSearch: FlightSearch) {
        let request = Flight.fetchRequest(flightSearch.predicate)
        _flights = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        List {
            ForEach(flights, id: \.ident) { flight in
                FlightListEntry(flight: flight)
            }
        }
        .navigationBarTitle(title)
    }
    
    private var title: String {
        let title = "Flights"
        if let destination = flights.first?.destination.icao {
            return title + " to \(destination)"
        } else {
            return title
        }
    }
}

struct FlightListEntry: View {
    @ObservedObject var flight: Flight

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
            Text(arrives).font(.caption)
            Text(origin).font(.caption)
        }
            .lineLimit(1)
    }
    
    var name: String {
        return "\(flight.airline.friendlyName)"
    }

    var arrives: String {
        let time = DateFormatter.stringRelativeToToday(Date.currentFlightTime, from: flight.arrival)
        if flight.departure == nil {
            return "scheduled to arrive \(time) (not departed)"
        } else if flight.arrival < Date.currentFlightTime {
            return "arrived \(time)"
        } else {
            return "arrives \(time)"
        }
    }

    var origin: String {
        return "from " + (flight.origin.friendlyName)
    }
}

extension FlightSearch {
    var predicate: NSPredicate {
        var format = "destination_ = %@"
        var args: [NSManagedObject] = [destination]
        if origin != nil {
            format += " and origin_ = %@"
            args.append(origin!)
        }
        if airline != nil {
            format += " and airline_ = %@"
            args.append(airline!)
        }
        if inTheAir { format += " and departure != nil" }
        return NSPredicate(format: format, argumentArray: args)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightsEnrouteView(flightSearch: FlightSearch(destination: "KSFO"))
//    }
//}
