//
//  PokemonView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-07-01.
//

import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var pokemonVM : PokemonViewModel
    var body: some View {
        ZStack {
            if let pokemon = pokemonVM.pokemon {
                VStack {
                    AsyncImage(url: pokemon.sprites.frontDefault) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 300)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text(pokemon.name.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    PokemonView()
        .environmentObject(PokemonViewModel())
}
