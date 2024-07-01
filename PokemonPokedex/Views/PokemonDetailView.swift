//
//  PokemonDetailView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-30.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject private var detailViewModel : PokemonDetailViewModel
    
    var body: some View {
        VStack {
            if let pokemon = detailViewModel.pokemon {
                VStack {
                    AsyncImage(url: pokemon.sprites.frontDefault) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text(pokemon.name.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if !detailViewModel.evolutions.isEmpty {
                        Text("Evolutions:")
                        ForEach(detailViewModel.evolutions, id: \.id) { evolution in
                            VStack {
                                AsyncImage(url: evolution.sprites.frontDefault) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                    case .failure:
                                        Image(systemName: "exclamationmark.triangle")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                Text(evolution.name.capitalized)
                                    .font(.headline)
                            }
                        }
                    }
                }
            } else if let errorMessage = detailViewModel.errorMessage {
                Text(errorMessage)
            } else {
                Text("Loading...")
            }
        }
        .task {
            await detailViewModel.fetchRandomPokemon()
        }
    }
}

#Preview {
    
    PokemonDetailView()
        .environmentObject(PokemonDetailViewModel())
}
