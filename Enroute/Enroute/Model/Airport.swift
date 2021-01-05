//
//  Airport.swift
//  Enroute
//
//  Created by Valerie 👩🏼‍💻 on 05/01/2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Combine

extension Airport {
    static func withICAO(_ icao: String, context: NSManagedObjectContext) -> Airport {
    
        // look up icao in Core Data
//        let request = NSFetchRequest<Airport>(entityName: "Airport")
//        request.predicate = NSPredicate(format: "icao = %@", icao)
//        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        let request = fetchRequest(NSPredicate(format: "icao_ = %@", icao))
        let airports = (try? context.fetch(request)) ?? []
        
        if let airport = airports.first {
            // return found airport
            return airport
        } else {
            // if not, create one and fetch from FlightAware
            let airport = Airport(context: context)
            airport.icao = icao
            AirportInfoRequest.fetch(icao) { airportInfo in
                update(from: airportInfo, context: context)
            }
            return airport
        }
    }
    
    static func update(from info: AirportInfo, context: NSManagedObjectContext) {
        if let icao = info.icao {
            let airport = withICAO(icao, context: context)
            airport.latitude = info.latitude
            airport.location = info.location
            airport.longitude = info.longitude
            airport.timezone = info.timezone
            airport.name = info.name
            airport.objectWillChange.send()
            airport.flightsTo.forEach { $0.objectWillChange.send() }
            airport.flightsFrom.forEach { $0.objectWillChange.send() }

            try? context.save()
        }
    }
    
    var flightsTo: Set<Flight> {
        get { (flightsTo_ as? Set<Flight>) ?? [] }
        set { flightsTo_ = newValue as NSSet }
    }
    
    var flightsFrom: Set<Flight> {
        get { (flightsFrom_ as? Set<Flight>) ?? [] }
        set { flightsFrom_ = newValue as NSSet }
    }
}

extension Airport: Comparable {
    public var id: String { icao }
    public static func < (lhs: Airport, rhs: Airport) -> Bool {
        lhs.location ?? lhs.friendlyName < rhs.location ?? rhs.friendlyName
    }
    var icao: String {
        get { icao_! }  // should be better solution than forced unwrapping 
        set { icao_ = newValue }
    }
    var friendlyName: String {
        let friendly = AirportInfo.friendlyName(name: name ?? "", location: location ?? "")
        return friendly.isEmpty ? icao : friendly
    }
}

extension Airport {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Airport> {
        let request = NSFetchRequest<Airport>(entityName: "Airport")
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        request.predicate = predicate
        return request
    }
}

extension Airport {
    func fetchIncomingFlights() {
        Self.flightAwareRequest?.stopFetching()
        if let context = managedObjectContext {
            Self.flightAwareRequest = EnrouteRequest.create(airport: icao, howMany: 120)
            Self.flightAwareRequest?.fetch(andRepeatEvery: 10)
            Self.flightAwareResultsCancellable = Self.flightAwareRequest?.results.sink { results in
                for faflight in results {
                    Flight.update(from: faflight, context: context)
                }
                do {
                    try context.save()
                } catch (let error) {
                    print("Coudn't save flight update to Core Data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private static var flightAwareRequest: EnrouteRequest!
    private static var flightAwareResultsCancellable: AnyCancellable?
}
