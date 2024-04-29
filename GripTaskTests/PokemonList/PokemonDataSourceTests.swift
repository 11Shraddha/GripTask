//
//  PokemonDataSourceTests.swift
//  GripTaskTests
//
//  Created by Shraddha on 25/04/24.
//

import XCTest
@testable import GripTask

final class PokemonDataSourceTests: XCTestCase {
    
    var networkService: MockNetworkService!
    var pokemonDataSource: MockPokemonDataSource!
    
    override func setUp() {
    }
    
    func helperInit(mockDataFileName: String, testScenario: TestScenario) {
        networkService = MockNetworkService(fileName: mockDataFileName, testScenario: testScenario)
        pokemonDataSource = MockPokemonDataSource(networkService: networkService)
    }
    
    func testGetPokemonforSuccess() {
        helperInit(mockDataFileName: "PokemonListResponseMock", testScenario: .success)
        let expectation = XCTestExpectation(description: "Successful response")
        pokemonDataSource.getPokemons(completion: { response in
            switch response {
            case .success(let response):
                XCTAssertTrue((response.results ?? []).count > 0)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        })
    }
    
    func testGetPokemonFailure() {
        helperInit(mockDataFileName: "PokemonListResponseMock", testScenario: .failure)
        
        let expectation = XCTestExpectation(description: "Failure response")
        pokemonDataSource.getPokemons(completion: { response in
            switch response {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.message, "Mock Error Message")
                expectation.fulfill()
            }
        })
    }
    
    func testGetPokemonEmpty() {
        helperInit(mockDataFileName: "PokemonListResponseMock", testScenario: .emptyArray)
        let expectation = XCTestExpectation(description: "Failure response")
        pokemonDataSource.getPokemons(completion: { response in
            switch response {
            case .success(let responseData):
                XCTAssertTrue(responseData.results?.count ?? 0 == 0)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        })
        wait(for: [expectation], timeout: 5)
    }
}

class MockPokemonDataSource: GetPokemonsUseCase {
    
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
}

