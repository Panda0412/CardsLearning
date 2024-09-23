//
//  ContentView.swift
//  CardsLearning
//
//  Created by Anastasiia Bugaeva on 07.07.2024.
//

import SwiftUI

enum AppRoute: Hashable {
    case homeScreen
    case deckScreen
    case cardScreen
}

struct ContentView: View {

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            Text("Statistics")
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }

            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
