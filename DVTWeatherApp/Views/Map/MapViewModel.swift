//
//  MapViewModel.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI
import MapKit

protocol MapViewModelType: ObservableObject {
    
    var region: MKCoordinateRegion { get set }
    var location: CLLocation? { get set }
    
    var annotations: [AnnotationData] { get }
    
    var showLocationPermissionSheet: Bool { get set }
    var showFavouriteSheet: Bool { get set }
    
    func deleteFavourite(name: String)
    
}

class MapViewModel: ObservableObject, MapViewModelType {
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -29.85, longitude: 31.02), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var location: CLLocation?
    
    @Published var showLocationPermissionSheet: Bool = false
    @Published var showFavouriteSheet: Bool = false
    
    let services: Services
    let locationManager: LocationManager
    let firebaseManager: FirebaseManager
    
    weak var coordinator: MapCoordinator?
    
    var annotations: [AnnotationData] {
        var allAnnotations: [AnnotationData] = firebaseManager.locations.map {
            AnnotationData(name: $0.name, coordinate: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long))
        }
        if let location = self.location {
            allAnnotations.insert(AnnotationData(name: "Current Location", coordinate: location.coordinate), at: 0)
        }
        return allAnnotations
 }
    
    init(services: Services, locationManager: LocationManager, coordinator: MapCoordinator? = nil) {
        self.services = services
        self.coordinator = coordinator
        self.locationManager = locationManager
        
        self.firebaseManager = FirebaseManager()
        
        load()
    }
    
    
    func load() {
        Task {
            await fetchLocations()
            await checkLocationPermission()
            await getCurrentLocation()
        }
    }
    
    func fetchLocations() async {
        firebaseManager.fetchLocations()
    }
    
    
    func getCurrentLocation() async {
        do {
            let location = try await LocationManager.shared.getCurrentLocation()

            let newRegion = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            await MainActor.run {
                self.region = newRegion
                self.location = location
            }
        }
        catch {
            print("DEBUG getCurrentLocation: \(error.localizedDescription)")
        }
    }
    
    func checkLocationPermission() async {
        let status = locationManager.locationStatus
        
        switch status {
        case .notDetermined:
            LocationManager.shared.requestAuthorisation()
        case .denied, .restricted:
            showLocationPermissionSheet = true
        case .authorizedAlways, .authorizedWhenInUse:
            await getCurrentLocation()
        default: break
        }
    }
    
    func deleteFavourite(name: String) {
        firebaseManager.deleteLocation(name: name)
    }
}
