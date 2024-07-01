//
//  SearchView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-30.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var errorMessage: String?
    @EnvironmentObject private var detailViewModel : PokemonDetailViewModel
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 150)
                .foregroundStyle(.red)
                .ignoresSafeArea()
                .overlay {
                    TextField("Search Pokémon", text: $query, onCommit: {
                        Task {
                            print(query)
                            await searchPokemon()
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .padding(.bottom, 30)
                }
           
            
            if let pokemon = detailViewModel.pokemon {
                PokemonDetailView()
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
        Spacer()
    }
    
    private func searchPokemon() async {
        do {
            let pokemon = try await PokemonAPI.fetchPokemon(by: query)
            detailViewModel.pokemon = pokemon
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(PokemonDetailViewModel())
}
