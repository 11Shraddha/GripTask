

import Foundation

struct PokemonDetailModel {
    let stats: [Stat]
    let types: [TypeElement]
    let name: String
    let id: String
}

// MARK: - PokemonDetailResponseModel
struct PokemonDetailResponse: Codable {
    let abilities: [Ability]?
    let baseExperience: Int?
    let height: Int?
    let id: Int?
    let isDefault: Bool?
    let name: String?
    let order: Int?
    let stats: [Stat]?
    let types: [TypeElement]?
    let weight: Int?
}

// MARK: - Ability
struct Ability: Codable {
    let ability: Species?
    let isHidden: Bool?
    let slot: Int?

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - Species
struct Species: Codable {
    let name: String?
    let url: String?
}

// MARK: - Stat
struct Stat: Codable {
    let baseStat, effort: Int?
    let stat: Species?
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int?
    let type: Species?
}
