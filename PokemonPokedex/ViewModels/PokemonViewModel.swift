//
//  PokemonDetailViewModel.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-30.
//

import SwiftUI
import Combine

class PokemonViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    @Published var searchedPokemon: Pokemon?
    @Published var detailPokemon: Pokemon?
    
    @Published var evolutions: [Pokemon] = []
    @Published var searchedPokemonEvolutions: [Pokemon] = []
    @Published var detailPokemonEvolutions: [Pokemon] = []
    
    @Published var errorMessage: String?
    
    @Published var isSaved: Bool = false
    @Published var savedPokemons: [Pokemon] = []
    
    @Published var allPokemons: [PokemonListModel.Pokemons]?
    @Published var chosenPokemon: Pokemon?
    
    
    func savePokemon(pokemon: Pokemon) {
        DispatchQueue.main.async {
            self.savedPokemons.append(pokemon)
        }
    }
    
    func fetchRandomPokemon() async {
        
        do {
            DispatchQueue.main.async {
                self.isSaved = false
                self.evolutions.removeAll()
            }
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
    
    func fetchSearchedPokemon(with name: String) async -> Pokemon? {
        do {
            DispatchQueue.main.async {
                self.evolutions.removeAll()
            }
            let pokemon = try await PokemonAPI.fetchPokemon(with: name)
            
            await fetchEvolutionChain(for: pokemon)
            return pokemon
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
        return nil
    }
    
    private func fetchEvolutionChain(for pokemon: Pokemon) async {
        do {
            guard let speciesUrl = pokemon.species?.url else { return }
            let species = try await PokemonAPI.fetchPokemonSpecies(from: speciesUrl)
            let evolutionChain = try await PokemonAPI.fetchEvolutionChain(from: species.evolutionChain.url)
            await fetchEvolutions(from: evolutionChain.chain)
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch evolution chain: \(error.localizedDescription)"
                print(self.errorMessage as Any)
            }
        }
    }
    
    @MainActor
    private func fetchEvolutions(from chain: EvolutionChain.Chain) async {
        do {
            var evolutionPokemons: [Pokemon] = []
            var currentChain: EvolutionChain.Chain? = chain
            
            while let current = currentChain {
                let evolutionName = current.species.name
                let evolutionPokemon = try await PokemonAPI.fetchPokemon(with: evolutionName)
                DispatchQueue.main.async {
                    evolutionPokemons.append(evolutionPokemon)
                }
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
    
    func fetchAllPokemons() async {
        do {
            if allPokemons != nil { return }
            let listOfPokemons = try await PokemonAPI.fetchPokemonlist()
            DispatchQueue.main.async {
                self.allPokemons = listOfPokemons.results
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch all pokemons: \(error.localizedDescription)"
                print(self.errorMessage as Any)
            }
        }
    }

}
