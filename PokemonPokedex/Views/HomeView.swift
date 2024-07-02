//
//  HomeView.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-07-01.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var detailViewModel: PokemonViewModel
    
    var body: some View {
        VStack {
            if let pokemon = detailViewModel.pokemon {
             
                    AsyncImage(url: pokemon.sprites.frontDefault) { phase in
                        switch phase {
                        case .empty:
                            
                            ProgressView()
                            
                        case .success(let image):
                            
                            VStack{
                                
                                Text(" NEW POKEMON FOUND !")
                                    .font(.headline)
                                
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, height: 250)
                                
                                Text(pokemon.name.capitalized)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Text("Catch Pokemon? : ")
                                    Image(systemName: detailViewModel.isSaved ? "star.fill" : "star")
                                        .resizable()
                                        .foregroundStyle(.yellow)
                                        .frame(width: 30, height: 30)
                                }
                                
                                .onTapGesture {
                                    detailViewModel.savePokemon(pokemon: pokemon)
                                    detailViewModel.isSaved = true
                                }
                            }
                            
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    
                .padding(.top, 30)
            }
                
            Spacer()
        }
        .padding(.top, 40)
        .onAppear {
            Task {
                await detailViewModel.fetchRandomPokemon()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PokemonViewModel())
}
