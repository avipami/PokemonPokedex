//
//  SavedPokemonsView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-07-01.
//

import SwiftUI

struct SavedPokemonsView: View {
    @EnvironmentObject var pokemonVM : PokemonViewModel
    var body: some View {
        NavigationView {
            List(pokemonVM.savedPokemons, id: \.id) { pokemon in
                HStack {
                    if let imageURL = pokemon.sprites.frontDefault {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                NavigationLink {
                                    PokemonDetailView(pokemon: pokemon, evolutions: pokemonVM.evolutions)
                                        .task {
                                            await pokemonVM.fetchSearchedPokemon(with: pokemon.name)
                                        }
                                } label: {
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                }
                            case .failure:
                                Image(systemName: "exclamationmark.triangle")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    Text(pokemon.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Saved Pokémon")
        }
    }
}

#Preview {
    SavedPokemonsView()
        .environmentObject(PokemonViewModel())
}
