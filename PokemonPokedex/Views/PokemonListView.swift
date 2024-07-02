//
//  PokemonListView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-07-01.
//

import SwiftUI

struct PokemonListView: View {
    @EnvironmentObject var pokemonVM: PokemonViewModel
    @State var showdetails: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if let pokemonsPopulated = pokemonVM.allPokemons, let chosenPokemon = pokemonVM.pokemon {
                    List(pokemonsPopulated, id: \.name) { pokemon in
                        NavigationLink {
                            PokemonDetailView(pokemon: chosenPokemon, evolutions: pokemonVM.evolutions).onAppear {
                                Task {
                                    await pokemonVM.fetchSearchedPokemon(with: pokemon.name)
                                }
                            }
                        } label: {
                            Text("\(pokemon.name.capitalized)")
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await pokemonVM.fetchAllPokemons()
                }
            }
        }
    }
}

#Preview {
    PokemonListView()
        .environmentObject(PokemonViewModel())
}
