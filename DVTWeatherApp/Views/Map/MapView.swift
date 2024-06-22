//
//  MapView.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI
import MapKit

struct MapView<ViewModel: MapViewModelType>: View {
    
    @StateObject var vm: ViewModel    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $vm.position, selection: $vm.selectedLocation) {
                ForEach(vm.annotations, id: \.id) { result in
                    if let coordinates = result.coordinate {
                        Marker(coordinate: coordinates) {
                            Image(systemName: "mappin")
                                .onTapGesture {
                                    vm.selectedLocation = result
                                }
                        }
                        .tag(result)
                    }
                }
            }
            .onTapGesture {
                vm.selectedLocation = nil
                vm.showSearchSheet = true
            }
            
            if vm.selectedLocation != nil {
                LookAroundPreview(scene: $vm.scene,
                                  allowsNavigation: false,
                                  badgePosition: .bottomTrailing)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $vm.showSearchSheet) {
            searchSheet
        }
        .fullScreenCover(isPresented: $vm.showLocationPermissionSheet) {
            LocationPermissionView(closePermissionSheet: { vm.showLocationPermissionSheet = false })
        }
        
        .onChange(of: vm.selectedLocation) {
            vm.onChangeSelectedLocation()
        }
            
    }
    
    var searchSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.cloudy)
                
                TextField("Search", text: $vm.query)
                    .autocorrectionDisabled()
                    .onSubmit {
                        vm.search()
                    }
                .autocorrectionDisabled()
                .foregroundStyle(Color.cloudy)
                .font(.body18SemiBold)
                Spacer()
                Button(action: {
                    vm.query = ""
                    vm.searchResults = []
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.cloudy)
                })
            }
            .padding(.all, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.1))
            )
            .padding(.all, 16)
            Spacer()
            
            ScrollView(showsIndicators: false) {
                ForEach(vm.searchService.completions) { item in
                    Button(action: {
                        vm.addLocation(name: item.title, subtitle: item.subtitle, coordinate: item.coordinates)
                    }, label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.body18)
                                .foregroundStyle(Color.darkCloudy)
                                .multilineTextAlignment(.leading)
                            Text(item.subtitle)
                                .font(.body16)
                                .foregroundStyle(Color.cloudy)
                                .multilineTextAlignment(.leading)
                            if let url = item.url {
                                Link(url.absoluteString, destination: url)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                                    .font(.body14)
                                    .foregroundStyle(Color.cloudy)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    })
                }
            }
        }
        .interactiveDismissDisabled()
        .presentationDetents([.height(100), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}

struct AnnotationData: Identifiable, Hashable {
   
    let id = UUID()
    let name: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D?
    
    static func == (lhs: AnnotationData, rhs: AnnotationData) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
