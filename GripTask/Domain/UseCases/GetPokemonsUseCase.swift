//
//  GetProductRepository.swift
//  GripTask
//
//  Created by Shraddha on 22/04/24.
//

import Foundation

protocol GetPokemonsUseCase {
    func getPokemons(completion: @escaping (Result<PokemonResponse, ErrorResponse>) -> Void)
}
