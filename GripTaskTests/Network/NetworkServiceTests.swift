//
//  NetworkServiceTests.swift
//  GripTaskTests
//
//  Created by Shraddha on 24/04/24.
//

import Foundation
import XCTest
@testable import GripTask

final class NetworkServiceTests: XCTestCase {
    
    func testGetSuccess() {
        let expectation = XCTestExpectation(description: "Successful response")
        
        let api = MockNetworkService(fileName: "PokemonListResponseMock", testScenario: .success)
        let requestData = PokemonRequestData(url: APIEndpoint.getPokemonList.url, httpMethod: .get)
        api.get(request: requestData, type: PokemonResponse.self) { response in
            switch response {
            case .success(let response):
                XCTAssertTrue((response.results ?? []).count > 0)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetFailure() {
        let expectation = XCTestExpectation(description: "Failure response")
        let api = MockNetworkService(testScenario: .failure)
        let requestData = PokemonRequestData(url: APIEndpoint.getPokemonList.url, httpMethod: .get)
        api.get(request: requestData, type: PokemonResponse.self) { response in
            switch response {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.message, "Mock Error Message")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testUnreachableURLAccessThrowsAnError() {
        let api = MockNetworkService(testScenario: .invalidUrl)
        let requestData = PokemonRequestData(url: "invalidURL", httpMethod: .get)
        let expectation = XCTestExpectation(description: "Invalid URL response")
        api.get(request: requestData, type: PokemonResponse.self) { response in
            switch response {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.message, URLError(.badURL).localizedDescription)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testUnauthorizedRequest() {
        let api = MockNetworkService(testScenario: .unauthorised)
        var requestData = PokemonRequestData(url: APIEndpoint.getPokemonList.url, httpMethod: .get)
        requestData.headers = [:]
        let expectation = XCTestExpectation(description: "Unauthorized response")
        api.get(request: requestData, type: PokemonResponse.self) { response in
            switch response {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.message, "Unauthorized access")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testInvalidJSONResponse() {
        let api = MockNetworkService(testScenario: .invalidJson)
        var requestData = PokemonRequestData(url: "https://example.com", httpMethod: .get)

        let invalidJSONURL = URL(string: "https://example.com")!
        let expectation = self.expectation(description: "Invalid JSON response")
        api.get(request: requestData, type: PokemonResponse.self) { result in
            switch result {
            case .success:
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertEqual(error.message, "Failed to decode response")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}

enum TestScenario {
    case success
    case failure
    case emptyArray
    case unauthorised
    case invalidUrl
    case invalidJson
}

class MockNetworkService: NetworkService {
    private var fileName: String = "ErrorResponseMock"
    private let testScenario: TestScenario
    
    init(fileName: String? = nil, testScenario: TestScenario = .success) {
        self.fileName = fileName ?? "ErrorResponseMock"
        self.testScenario = testScenario
    }
    
    func get<T>(request: NetworkRequest, type: T.Type, completion: @escaping (Result<T, ErrorResponse>) -> Void) where T: Decodable {
        
        switch testScenario {
        case .success:
            if let mockData: T = loadJsonFiles() {
                completion(.success(mockData))
                return
            }
        case .failure:
            self.fileName = "ErrorResponseMock"
            if let mockData: ErrorResponse = loadJsonFiles() {
                completion(.failure(mockData))
                return
            }
            return
        case .emptyArray:
            self.fileName = "EmptyPokemonListResponseMock"
            if let mockData: T = loadJsonFiles() {
                completion(.success(mockData))
                return
            }
            return
        case .unauthorised:
            let errorMessage = "Unauthorized access"
            completion(.failure(ErrorResponse(message: errorMessage)))
            return
        case .invalidJson:
            let invalidJSONData = Data("Invalid JSON".utf8)
            let errorMessage = "Failed to decode response"
            completion(.failure(ErrorResponse(message: errorMessage)))
            return
        case .invalidUrl:
            let errorMessage = URLError(.badURL).localizedDescription
            completion(.failure(ErrorResponse(message: errorMessage)))
            return
        }
        let defaultErrorMessage = "Error in API call"
        completion(.failure(ErrorResponse(message: defaultErrorMessage)))
    }
    
    private func loadJsonFiles<T: Decodable>() -> T? {
        let bundle = Bundle(for: type(of: self))
        print("json file name \(fileName)")
        if let fileURL = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: fileURL))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("Error reading JSON file:", error)
                return nil
            }
        } else {
            print("File not found or path incorrect")
            return nil
        }
    }
}
