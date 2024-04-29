import Foundation

protocol NetworkService {
    func get<T>(request: NetworkRequest, type: T.Type, completion: @escaping (Result<T, ErrorResponse>) -> Void) where T: Decodable
}

final class URLSessionNetworkService: NetworkService {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func get<T>(request: NetworkRequest, type: T.Type, completion: @escaping (Result<T, ErrorResponse>) -> Void) where T: Decodable {
        guard let urlRequest = prepareUrlRequest(requestData: request) else {
            completion(.failure(ErrorResponse(message: URLError(.badURL).localizedDescription)))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(ErrorResponse(message: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ErrorResponse(message: "Invalid Response")))
                return
            }
            
            guard (200..<300) ~= httpResponse.statusCode else {
                if let data = data {
                    do {
                        let errorResponse = try self.decoder.decode(ErrorResponse.self, from: data)
                        completion(.failure(errorResponse))
                    } catch {
                        completion(.failure(ErrorResponse(message: "Failed to decode error response")))
                    }
                } else {
                    completion(.failure(ErrorResponse(message: "Unknown error")))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(ErrorResponse(message: "No data")))
                return
            }
            
            do {
                let decodedData = try self.decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(ErrorResponse(message: "Failed to decode response")))
            }
        }.resume()
    }
    
    private func prepareUrlRequest(requestData: NetworkRequest) -> URLRequest? {
        guard let url = URL(string: requestData.url) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        if requestData.body != nil, let bodyData = encodeRequestData(request: requestData.body!) {
            urlRequest.httpBody = bodyData
        }
        urlRequest.httpMethod = requestData.httpMethod.rawValue
        requestData.headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        return urlRequest
    }
    
    private func encodeRequestData(request: Encodable) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let jsonData = try? encoder.encode(request) else {
            fatalError("Failed to encode request model into JSON data")
        }
        return jsonData
    }
}
