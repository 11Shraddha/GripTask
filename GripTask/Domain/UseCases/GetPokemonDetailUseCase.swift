//
//  GetPokemonDetailUseCase.swift
//  GripTask
//
//  Created by Shraddha on 24/04/24.
//

import Foundation

protocol GetPokemonDetailUseCase {
    func getPokemonDetail(url: String, completion: @escaping (Result<PokemonDetailResponse, ErrorResponse>) -> Void)
}
