//
//  PokemonModel.swift
//  PokemonPokedex
//
//  Created by Vincent Palma on 2024-06-28.
//

import Foundation
struct Pokemon: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [PokemonType]?
    let species: Species?
    let moves: [Move]
    
    struct Sprites: Codable {
        let frontDefault: URL?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    struct PokemonType: Codable {
        let type: TypeName
        
        struct TypeName: Codable {
            let name: String
        }
    }
    
    struct Species: Codable {
        let url: URL
    }
    
    struct Move: Codable {
        let move: MoveData
        
        struct MoveData: Codable {
            let name: String
        }
    }
}

struct PokemonSpecies: Codable {
    let evolutionChain: EvolutionChain
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
    
    struct EvolutionChain: Codable {
        let url: URL
    }
}

struct EvolutionChain: Codable {
    let chain: Chain
    
    struct Chain: Codable {
        let species: EvolutionSpecies
        let evolvesTo: [Chain]
        
        
        enum CodingKeys: String, CodingKey {
            case species
            case evolvesTo = "evolves_to"
        }
        
        struct EvolutionSpecies: Codable {
            let name: String
            let url: URL
        }
    }
}

struct PokemonListModel: Codable {
    let results: [Pokemons]
    
    struct Pokemons: Codable {
        let name: String
        let url: URL
    }
}

extension Pokemon {
    
    static func mockedPokemon() -> Pokemon {
        let id = 1
        let name = "Pikachu"
        let sprites = Sprites(frontDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"))
        let species = Species(url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/25/")!)
        
        return Pokemon(id: id, name: name, sprites: sprites, types: nil, species: species, moves: [Move(move: Move.MoveData(name: ""))])
    }
}
