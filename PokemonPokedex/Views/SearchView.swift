//
//  SearchView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-30.
//

import SwiftUI

struct SearchView: View {
    @State private var name: String = ""
    @State private var errorMessage: String?
    @EnvironmentObject private var pokemonViewModel : PokemonViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(height: 150)
                    .foregroundStyle(.red)
                    .ignoresSafeArea()
                    .overlay {
                        TextField("Search Pokémon", text: $name, onCommit: {
                            Task {
                                await searchPokemon()
                            }
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom,40)
                        .padding(.horizontal, 30)
                    }
                Spacer()
                NavigationLink {
                    if let pokemon = pokemonViewModel.searchedPokemon {
                        PokemonDetailView (
                            pokemon: pokemon,
                            evolutions: pokemonViewModel.searchedPokemonEvolutions
                        )
                    }
                } label: {
                    PokemonView()
                }
                Spacer()
            }
        }
    }
    
    private func searchPokemon() async {
        await pokemonViewModel.fetchSearchedPokemon(with: name)
    }
}

#Preview {
    SearchView()
        .environmentObject(PokemonViewModel())
}
