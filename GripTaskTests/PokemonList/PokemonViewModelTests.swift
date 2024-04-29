//
//  PokemonViewModelTests.swift
//  GripTaskTests
//
//  Created by Shraddha on 25/04/24.
//

import XCTest
@testable import GripTask


final class PokemonViewModelTests: XCTestCase {
    
    var pokemonListViewModel: PokemonListViewModel!
    var fetchPokemonUseCase: GetPokemonsUseCase!
    var networkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
    }
    
    func helperInit(testScenario: TestScenario) {
        networkService = MockNetworkService(fileName: "PokemonListResponseMock", testScenario: testScenario)
        fetchPokemonUseCase = MockPokemonDataSource(networkService: networkService)
        pokemonListViewModel = PokemonListViewModel(getPokemonsUseCase: fetchPokemonUseCase)
    }
    
    func testViewmodelInitialization() {
        helperInit(testScenario: .success)
        XCTAssertEqual(pokemonListViewModel.pokemons.count, 0)
    }
    
    func testPokemonListSuccess() {
        helperInit(testScenario: .success)
        let loadingExpectation = expectation(description: "Pokemon list loaded successfully")
        pokemonListViewModel.getPokemons()
        XCTAssertTrue(self.pokemonListViewModel.pokemons.count > 0)
        loadingExpectation.fulfill()
        waitForExpectations(timeout: 5)
    }
    
    func testPokemonListFailure() {
        helperInit(testScenario: .failure)
        let loadingExpectation = expectation(description: "Pokemon list failed to load")
        pokemonListViewModel.getPokemons()
        XCTAssertFalse(self.pokemonListViewModel.errorMessage.isEmpty)
        loadingExpectation.fulfill()
        waitForExpectations(timeout: 5)
    }
    
    func testPokemonListEmpty() {
        helperInit(testScenario: .emptyArray)
        let loadingExpectation = expectation(description: "Pokemon list loaded successfully")
        pokemonListViewModel.getPokemons()
        XCTAssertTrue(pokemonListViewModel.pokemons.isEmpty)
        XCTAssertTrue(self.pokemonListViewModel.errorMessage.isEmpty)
        loadingExpectation.fulfill()
        waitForExpectations(timeout: 5)
    }
    
    override func tearDown() {
        networkService = nil
        fetchPokemonUseCase = nil
        pokemonListViewModel = nil
        super.tearDown()
    }
}

