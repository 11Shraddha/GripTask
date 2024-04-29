//
//  PokemonDetailViewModelTests.swift
//  GripTaskTests
//
//  Created by Shraddha on 27/04/24.
//

import XCTest
@testable import GripTask

final class PokemonDetailViewModelTests: XCTestCase {
    
    var pokemonDetailViewModel: PokemonDetailViewModel!
    var getPokemonDetailUseCase: GetPokemonDetailUseCase!
    var networkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
    }
    
    func helperInit(testScenario: TestScenario) {
        networkService = MockNetworkService(fileName: "PokemonDetailResponseMock", testScenario: testScenario)
        getPokemonDetailUseCase = MockPokemonDetailDataSource(networkService: networkService)
        pokemonDetailViewModel = PokemonDetailViewModel(getPokemonDetailUseCase: getPokemonDetailUseCase)
    }
    
    func testViewmodelInitialization() {
        helperInit(testScenario: .success)
        XCTAssertEqual(pokemonDetailViewModel.errorMessage, "")
    }
    
    func testPokemonDetailSuccess() {
        helperInit(testScenario: .success)
        let loadingExpectation = expectation(description: "Pokemon Detail loaded successfully")
        pokemonDetailViewModel.getPokemonDetail(url: "https://pokeapi.co/api/v2/pokemon/3/")
        XCTAssertNotNil(pokemonDetailViewModel.pokemonDetail)
        loadingExpectation.fulfill()
        waitForExpectations(timeout: 5)
    }
    
    func testPokemonDetailFailure() {
        helperInit(testScenario: .failure)
        let loadingExpectation = expectation(description: "Pokemon Detail failed to load")
        pokemonDetailViewModel.getPokemonDetail(url: "https://pokeapi.co/api/v2/pokemon/3/")
        XCTAssertFalse(pokemonDetailViewModel.errorMessage.isEmpty)
        loadingExpectation.fulfill()
        waitForExpectations(timeout: 5)
    }
        
    override func tearDown() {
        networkService = nil
        getPokemonDetailUseCase = nil
        pokemonDetailViewModel = nil
        super.tearDown()
    }
}

