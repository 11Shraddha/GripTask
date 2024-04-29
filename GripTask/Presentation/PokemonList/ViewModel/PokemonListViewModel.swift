import Foundation

protocol PokemonListViewModelDelegate: AnyObject {
    func didUpdatePokemons()
    func didEncounterError()
    func showLoader(show: Bool)
}

class PokemonListViewModel {
    let getPokemonsUseCase: GetPokemonsUseCase
    weak var delegate: PokemonListViewModelDelegate?
    
    var pokemons: [PokemonModel] = []
    var errorMessage: String = ""
    
    init(getPokemonsUseCase: GetPokemonsUseCase){
        self.getPokemonsUseCase = getPokemonsUseCase
    }
    
    func getPokemons() {
        delegate?.showLoader(show: true)
        getPokemonsUseCase.getPokemons { result in
            self.delegate?.showLoader(show: false)
            switch result {
            case .success(let response):
                self.pokemons = response.results?.map({ response in
                    return PokemonModel(name: response.name ?? "name", url: response.url ?? "url")
                }) ?? []
                self.delegate?.didUpdatePokemons()
            case .failure(let error):
                self.errorMessage = error.message
                self.delegate?.didEncounterError()
            }
        }
    }
}
