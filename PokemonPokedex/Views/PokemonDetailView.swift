//
//  PokemonDetailView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-30.
//

import SwiftUI

struct PokemonDetailView: View {
    
    let pokemon: Pokemon
    let evolutions: [Pokemon]?
    
    var body: some View {
        ScrollView {
            LazyVStack {
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
                            .padding()
                        
                        Text("Possible Attacks and Moves :")
                            .font(.headline)
                            .padding(.top, 20)
                        Text("\(formattedMoves(moves: pokemon.moves))")
                            .padding()
                        
                        if let evolutions = evolutions {
                            Text("Evolutions:")
                                .font(.largeTitle)
                            ForEach(evolutions, id: \.id) { evolution in
                                VStack {
                                    AsyncImage(url: evolution.sprites.frontDefault) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80, height: 80)
                                            
                                            Text(evolution.name.capitalized)
                                                .font(.headline)
                                            
                                        case .failure:
                                            Image(systemName: "exclamationmark.triangle")
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    private func formattedMoves(moves: [Pokemon.Move]) -> String {
        let moveNames = moves.map { $0.move.name.capitalized }
        let limitedMoves = moveNames.prefix(3) // Limit to 3 moves
        return limitedMoves.joined(separator: ", ")
    }
}

#Preview {
    
    PokemonDetailView(pokemon: Pokemon.mockedPokemon(), evolutions: nil)
        .environmentObject(PokemonViewModel())
}
