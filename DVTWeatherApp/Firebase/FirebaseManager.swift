//
//  FirebaseManager.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/21.
//

import Foundation
import Firebase
import Combine
import FirebaseDatabase
import CoreLocation


class FirebaseManager: ObservableObject {
    
    @Published var locations: [Location] = []
    @Published var location: CLLocation?
    
    private var ref: DatabaseReference = Database.database().reference()
    
    init() {
        fetchLocations()
    }
    
    func fetchLocations() {
        ref.child("locations").observeSingleEvent(of: .value) { snapShot in
            var newLocations: [Location] = []
            for child in snapShot.children {
                if let snapShot = child as? DataSnapshot,
                   let value = snapShot.value as? [String: Any],
                   let name = value["name"] as? String,
                   let subtitle = value["subtitle"] as? String,
                   let lat = value["lat"] as? Double,
                   let long = value["long"] as? Double {
                    let location = Location(name: name, subTitle: subtitle, lat: lat, long: long)
                    newLocations.append(location)  // Corrected line
                }
            }
            DispatchQueue.main.async {
                self.locations = newLocations
            }
        }
    }
    
    func addLocation(name: String, subtitle: String, lat: Double, long: Double) {
        let key = ref.child("locations").childByAutoId().key
        let newLocation = ["name": name, "subtitle": subtitle, "lat": lat, "long": long] as [String: Any]
        ref.child("locations").child(key ?? UUID().uuidString).setValue(newLocation) { error, _ in
            if let error = error {
                print("DEBGUG Error addLocation(): \(error.localizedDescription) ")
            }
            else {
                self.locations.append(Location(name: name, subTitle: subtitle, lat: lat, long: long))
            }
        }
    }
    
    func deleteLocation(name: String) {
        ref.child("locations").queryOrdered(byChild: "name").queryEqual(toValue: name).observeSingleEvent(of: .value) { snapShot in
            for child in snapShot.children {
                if let childSnapShot = child as? DataSnapshot {
                    childSnapShot.ref.removeValue { error, _ in
                        if let error = error {
                            print("DEBUG Error deleteLocation(): \(error.localizedDescription)")
                        }
                        else {
                            self.locations.removeAll { $0.name == name }
                        }
                    }
                }
            }
        }
    }
}
