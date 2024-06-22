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
    
    var searchService: SearchService { get set }
    var query: String { get set }
    var searchResults: [AnnotationData] { get set }
    var selectedLocation: AnnotationData? { get set }
    var position: MapCameraPosition { get set }
    var scene: MKLookAroundScene? { get set }
    
    var showLocationPermissionSheet: Bool { get set }
    var showSearchSheet: Bool { get set }
    
    func addLocation(name: String, subtitle: String, coordinate: CLLocationCoordinate2D)
    
    func search()
    func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene?
    func onChangeSelectedLocation()
}

class MapViewModel: ObservableObject, MapViewModelType {
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -29.85, longitude: 31.02), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var location: CLLocation?
    
    @Published var searchService: SearchService = SearchService(completer: .init())
    @Published var query: String = ""
    @Published var searchResults: [AnnotationData] = []
    @Published var selectedLocation: AnnotationData?
    @Published var position: MapCameraPosition = MapCameraPosition.automatic
    @Published var scene: MKLookAroundScene?
    
    @Published var showLocationPermissionSheet: Bool = false
    @Published var showSearchSheet: Bool = true
    
    let services: Services
    let locationManager: LocationManager
    let firebaseManager: FirebaseManager
    
    weak var coordinator: MapCoordinator?
    
    var annotations: [AnnotationData] {
        var allAnnotations: [AnnotationData] = firebaseManager.locations.map {
            AnnotationData(name: $0.name, subtitle: $0.subTitle, coordinate: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long))
        }
        if let location = self.location {
            allAnnotations.insert(AnnotationData(name: "Current Location", subtitle: "", coordinate: location.coordinate), at: 0)
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
    
    func addLocation(name: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        firebaseManager.addLocation(name: name, subtitle: subtitle, lat: coordinate.latitude, long: coordinate.longitude)
    }
    
    func search() {
        Task {
            let searchResponse = try await searchService.search(with: query)
            
            await MainActor.run {
                self.searchResults = searchResponse
            }
        }
    }
    
    private func didTapOnCompletion(_ completion: AnnotationData) {
        Task {
            if let singleLocation = try? await searchService.search(with: "\(completion.name) \(completion.subtitle)").first {
                searchResults = [singleLocation]
            }
        }
    }
    
    func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
    
    func onChangeSelectedLocation() {
        if let selectedLocation, let coordinate = selectedLocation.coordinate {
            Task {
                let response = try? await fetchScene(for: coordinate)
                
                await MainActor.run {
                    self.scene = response
                }
            }
        }
        showSearchSheet = selectedLocation == nil
    }
}
