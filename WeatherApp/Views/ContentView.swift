//
//  ContentView.swift
//  WeatherApp
//
//  Created by KeJian Ooi on 6/28/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            if let location = locationManager.location { //If location is not null
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                }
            }
            else {
                if locationManager.isLoading {
                    LoadingView()
                }
                else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.675, saturation: 0.839, brightness: 0.618))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
