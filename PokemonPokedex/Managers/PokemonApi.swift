//
//  PokemonApi.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-28.
//

import Foundation

import Foundation

class PokemonAPI {
    static let baseURL = "https://pokeapi.co/api/v2"
    
    static func fetchRandomPokemon() async throws -> Pokemon {
        let url = URL(string: "\(baseURL)/pokemon/\(Int.random(in: 1...3))")!
        return try await NetworkManager.shared.fetch(url: url.absoluteString)
    }
    
    static func fetchPokemon(by name: String) async throws -> Pokemon {
        let url = "\(baseURL)/pokemon/\(name.lowercased())"
        return try await NetworkManager.shared.fetch(url: url)
    }
    
    static func fetchEvolutionChain(from url: URL) async throws -> EvolutionChain {
        return try await NetworkManager.shared.fetch(url: url.absoluteString)
    }
    
    static func fetchPokemonSpecies(from url: URL) async throws -> PokemonSpecies {
        return try await NetworkManager.shared.fetch(url: url.absoluteString)
    }
}
