//
//  ContentView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            SavedPokemonsView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Saved")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
