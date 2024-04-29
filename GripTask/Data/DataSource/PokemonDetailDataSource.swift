//
//  PokemonDetailDataSource.swift
//  GripTask
//
//  Created by Shraddha on 24/04/24.
//

import Foundation

class PokemonDetailDataSource: GetPokemonDetailUseCase {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPokemonDetail(url: String, completion: @escaping (Result<PokemonDetailResponse, ErrorResponse>) -> Void) {
        let request = PokemonDetailRequestData(url: APIEndpoint.getPokemonDetail(url: url).url, httpMethod: .get)
        networkService.get(request: request, type: PokemonDetailResponse.self) { result in
            completion(result)
        }
    }
}

struct PokemonDetailRequestData: NetworkRequest {
    
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
