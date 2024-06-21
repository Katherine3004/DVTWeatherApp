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
    
    @State private var searchService = SearchService(completer: .init())
    @State private var selectedLocation: AnnotationData?
    @State private var position = MapCameraPosition.automatic
    
    var body: some View {
        viewContent
            .edgesIgnoringSafeArea(.top)
            .fullScreenCover(isPresented: $vm.showLocationPermissionSheet) {
                LocationPermissionView(closePermissionSheet: { vm.showLocationPermissionSheet = false })
            }
            .sheet(isPresented: $vm.showFavouriteSheet) {
                favouriteSheet
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $vm.showSearchSheet) {
                searchSheet
            }
//            .overlay(alignment: .bottom) {
//                if selectedLocation != nil {
//                    LookAroundPreview(scene: $scene, allowsNavigation: false, badgePosition: .bottomTrailing)
//                        .frame(height: 150)
//                        .clipShape(RoundedRectangle(cornerRadius: 12))
//                        .safeAreaPadding(.bottom, 40)
//                        .padding(.horizontal, 20)
//                }
//            }
//            .onChange(of: selectedLocation) {
//                if let selectedLocation {
//                    Task {
//                        scene = try? await fetchScene(for: selectedLocation.location)
//                    }
//                }
//                isSheetPresented = selectedLocation == nil
//            }
//            .onChange(of: searchResults) {
//                if let firstResult = searchResults.first, searchResults.count == 1 {
//                    selectedLocation = firstResult
//                }
//            }
    }
    
    var viewContent: some View {
        Group {
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    //search bar will go here
                    Spacer()
                    Button(action: { vm.showFavouriteSheet = true }, label: {
                        Image(systemName: "star")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.cloudy)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 100)
                    .padding([.horizontal, .bottom], 16)
                }
//                Map(position: $position, selection: $selectedLocation) {
//                    ForEach(vm.searchResults) { result in
//                        Marker(coordinate: result.location) {
//                            Image(systemName: "mappin")
//                        }
//                        .tag(result)
//                    }
//                }
//                .ignoresSafeArea()
                Map(coordinateRegion: $vm.region, annotationItems: vm.annotations) {
                    MapPin(coordinate: $0.coordinate ?? CLLocationCoordinate2D())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var favouriteSheet: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 0) {
                Text("Favourite Locations")
                    .font(.body18SemiBold)
                    .foregroundStyle(Color.darkCloudy)
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.darkCloudy)
                    .onTapGesture {
                        vm.showFavouriteSheet = false
                    }
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.annotations, id: \.id) { annotation in
                        Button(action: { print(annotation.name) }, label: {
                            HStack(alignment: .center, spacing: 0) {
                                Text(annotation.name ?? "")
                                    .font(.body16)
                                    .foregroundStyle(Color.cloudy)
                                Spacer()
                                if annotation.name != "Current Location" {
                                    Button(action: { vm.deleteFavourite(name: annotation.name ?? "") }, label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16))
                                            .foregroundStyle(Color.darkCloudy)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .contentShape(Rectangle())
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(.all, 16)
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
                        Task {
                            vm.searchResults = try await searchService.search(with: vm.query)
                        }
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
                ForEach(searchService.completions) { item in
                    Button(action: {
                        vm.addLocation(name: item.title, coordinate: item.coordinates)
                    }, label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.body18)
                                .foregroundStyle(Color.darkCloudy)
                                .multilineTextAlignment(.leading)
                            Text(item.subTitle)
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
        .onChange(of: vm.query) {
            searchService.update(queryFragment: vm.query)
        }
        .interactiveDismissDisabled()
        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}

struct AnnotationData: Identifiable, Hashable {
   
    let id = UUID()
    let name: String?
    let coordinate: CLLocationCoordinate2D?
    
    static func == (lhs: AnnotationData, rhs: AnnotationData) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
