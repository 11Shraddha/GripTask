//
//  RemoteDataSoureProtocol.swift
//  GripTask
//
//  Created by Shraddha on 22/04/24.
//

import Foundation

class PokemonDataSource: GetPokemonsUseCase {
        
    private let networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPokemons(completion: @escaping (Result<PokemonResponse, ErrorResponse>) -> Void) {
        let request = PokemonRequestData(url: APIEndpoint.getPokemonList.url, httpMethod: .get)
        networkService.get(request: request, type: PokemonResponse.self) { result in
            completion(result)
        }
    }
}

struct PokemonRequestData: NetworkRequest {
    
    let url: String
    let httpMethod: HTTPMethodType
    let body: Encodable?
    var headers: [String: Any]
    
    init(url: String, httpMethod: HTTPMethodType, body: Encodable? = nil) {
        self.url = url
        self.httpMethod = httpMethod
        self.body = body
        self.headers = ["Content-Type": "application/json"]
    }
}
