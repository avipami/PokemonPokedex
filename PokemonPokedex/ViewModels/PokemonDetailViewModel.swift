//
//  PokemonDetailViewModel.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-30.
//

import SwiftUI
import Combine

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    @Published var evolutions: [Pokemon] = []
    @Published var errorMessage: String?
    
    func fetchRandomPokemon() async {
        do {
            let pokemon = try await PokemonAPI.fetchRandomPokemon()
            DispatchQueue.main.async {
                self.pokemon = pokemon
            }
            await fetchEvolutionChain(for: pokemon)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func fetchEvolutionChain(for pokemon: Pokemon) async {
        do {
            let species = try await PokemonAPI.fetchPokemonSpecies(from: pokemon.species.url)
            let evolutionChain = try await PokemonAPI.fetchEvolutionChain(from: species.evolutionChain.url)
            await fetchEvolutions(from: evolutionChain.chain)
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch evolution chain: \(error.localizedDescription)"
                print(self.errorMessage as Any)
            }
        }
    }
    
    private func fetchEvolutions(from chain: EvolutionChain.Chain) async {
        do {
            evolutions.removeAll()
            var evolutionPokemons: [Pokemon] = []
            var currentChain: EvolutionChain.Chain? = chain
            
            while let current = currentChain {
                let evolutionName = current.species.name
                let evolutionPokemon = try await PokemonAPI.fetchPokemon(by: evolutionName)
                evolutionPokemons.append(evolutionPokemon)
                currentChain = current.evolvesTo.first
            }
            
            DispatchQueue.main.async {
                self.evolutions = evolutionPokemons
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch evolutions: \(error.localizedDescription)"
                print(self.errorMessage as Any)
            }
        }
    }

}
