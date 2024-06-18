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
        viewContent
            .edgesIgnoringSafeArea(.top)
            .fullScreenCover(isPresented: $vm.showLocationPermissionSheet) {
                LocationPermissionView(closePermissionSheet: { vm.showLocationPermissionSheet = false })
            }
            .sheet(isPresented: $vm.showFavouriteSheet) {
                favouriteSheet
                    .presentationDetents([.medium])
            }
    }
    
    var viewContent: some View {
        Group {
            VStack(alignment: .center, spacing: 0) {
                Button(action: { vm.showFavouriteSheet = true }, label: {
                    HStack(alignment: .center, spacing: 8) {
                        Text("Favourites")
                            .font(.body16SemiBold)
                            .foregroundStyle(Color.cloudy)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.cloudy)
                    }
                    .frame(maxWidth: .infinity)
                })
                .buttonStyle(SecondaryButtonStyle())
                .padding(.top, 68)
                .padding([.horizontal, .bottom], 16)
                
                Map(coordinateRegion: $vm.region, annotationItems: vm.annotations) {
                    MapPin(coordinate: $0.coordinate)
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
                ForEach(vm.annotations, id: \.id) { annotation in
                    Button(action: { print(annotation.name) }, label: {
                        Text(annotation.name)
                            .font(.body16)
                            .foregroundStyle(Color.cloudy)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                }
            }
        }
        .padding(.all, 16)
    }
}

struct AnnotationData: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
