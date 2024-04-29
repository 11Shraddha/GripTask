//
//  PokemonDetailViewModel.swift
//  GripTask
//
//  Created by Shraddha on 24/04/24.
//

import Foundation

protocol PokemonDetailViewModelDelegate: AnyObject {
    func didUpdatePokemonDetail()
    func didEncounterError()
    func showLoader(show: Bool)
}

class PokemonDetailViewModel {
    let getPokemonDetailUseCase: GetPokemonDetailUseCase
    weak var delegate: PokemonDetailViewModelDelegate?
    
    var pokemonDetail: PokemonDetailModel?
    var errorMessage: String = ""
    
    init(getPokemonDetailUseCase: GetPokemonDetailUseCase){
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
    }
    
    func getPokemonDetail(url: String) {
        delegate?.showLoader(show: true)
        getPokemonDetailUseCase.getPokemonDetail(url: url) { result in
            self.delegate?.showLoader(show: false)
            switch result {
            case .success(let response):
                self.pokemonDetail = PokemonDetailModel(stats: response.stats ?? [], types: response.types ?? [], name: response.name ?? "name", id: "\(response.id ?? 0)")
                self.delegate?.didUpdatePokemonDetail()
            case .failure(let error):
                self.errorMessage = error.message
                self.delegate?.didEncounterError()
            }
        }
    }
}
