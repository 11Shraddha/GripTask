import Foundation

public enum HTTPMethodType: String {
    case get     = "GET"
    case post    = "POST"
}

protocol NetworkRequest {
    var url: String { get }
    var httpMethod: HTTPMethodType { get }
    var body: Encodable? { get }
    var headers: [String: Any] { get }
}

let baseUrl = "https://pokeapi.co/api/v2/"

enum APIEndpoint {
    case getPokemonList
    case getPokemonDetail(url: String)
    case createTransaction
    
    var url: String {
        switch self {
        case .getPokemonList:
            return baseUrl + "pokemon?limit=100000&offset=0"
        case .getPokemonDetail(let url):
            return url
        default:
            return baseUrl
        }
    }
}

