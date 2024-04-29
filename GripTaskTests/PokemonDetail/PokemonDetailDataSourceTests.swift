//
//  PokemonDetailDataSource.swift
//  GripTaskTests
//
//  Created by Shraddha on 27/04/24.
//

import XCTest
@testable import GripTask

final class PokemonDetailDataSource: XCTestCase {
    
    var networkService: MockNetworkService!
    var pokemonDetailDataSource: MockPokemonDetailDataSource!
        
    func helperInit(mockDataFileName: String, testScenario: TestScenario) {
        networkService = MockNetworkService(fileName: mockDataFileName, testScenario: testScenario)
        pokemonDetailDataSource = MockPokemonDetailDataSource(networkService: networkService)
    }
    
    func testGetPokemonDetailforSuccess() {
        helperInit(mockDataFileName: "PokemonDetailResponseMock", testScenario: .success)
        let expectation = XCTestExpectation(description: "Successful response")
        pokemonDetailDataSource.getPokemonDetail(url: "https://pokeapi.co/api/v2/pokemon/3/", completion: { response in
            switch response {
            case .success(let response):
                XCTAssertTrue((response.stats ?? []).count > 0)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        })
    }
    
    func testGetPokemonDetailFailure() {
        helperInit(mockDataFileName: "PokemonDetailResponseMock", testScenario: .failure)
        
        let expectation = XCTestExpectation(description: "Failure response")
        pokemonDetailDataSource.getPokemonDetail(url: "https://pokeapi.co/api/v2/pokemon/3/", completion: { response in
            switch response {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.message, "Mock Error Message")
                expectation.fulfill()
            }
        })
    }
}

class MockPokemonDetailDataSource: GetPokemonDetailUseCase {
    
    private let networkService: MockNetworkService
    
    init(networkService: MockNetworkService) {
        self.networkService = networkService
    }
    
    func getPokemons(completion: @escaping (Result<PokemonResponse, ErrorResponse>) -> Void) {
        let requestData = PokemonRequestData(url: APIEndpoint.getPokemonList.url, httpMethod: .get)
        networkService.get(request: requestData, type: PokemonResponse.self) { response in
            completion(response)
        }
    }
    
    func getPokemonDetail(url: String, completion: @escaping (Result<GripTask.PokemonDetailResponse, GripTask.ErrorResponse>) -> Void) {
        let requestData = PokemonDetailRequestData(url: APIEndpoint.getPokemonDetail(url: url).url, httpMethod: .get)
        networkService.get(request: requestData, type: PokemonDetailResponse.self) { response in
            completion(response)
        }
    }
}

