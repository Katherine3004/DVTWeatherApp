//
//  SearchService.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/21.
//

import Foundation
import MapKit

struct SearchCompletion: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let coordinates: CLLocationCoordinate2D
    var url: URL?
}

@Observable
class SearchService: NSObject, MKLocalSearchCompleterDelegate {
    
    private let completer: MKLocalSearchCompleter
    
    var completions = [SearchCompletion]()
    
    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }
    
    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { completion in
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem

            return .init(
                title: completion.title,
                subtitle: completion.subtitle, 
                coordinates: mapItem?.placemark.coordinate ?? CLLocationCoordinate2D(),
                url: mapItem?.url
            )
        }
    }
    
    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [AnnotationData] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.resultTypes = .pointOfInterest
        if let coordinate {
            mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
        }
        let search = MKLocalSearch(request: mapKitRequest)

        let response = try await search.start()

        return response.mapItems.compactMap { mapItem in
            guard let name = mapItem.placemark.title, let subtitle = mapItem.placemark.title, let location = mapItem.placemark.location?.coordinate else { return nil }

            return .init(name: name, subtitle: subtitle, coordinate: location)
        }
    }
}
