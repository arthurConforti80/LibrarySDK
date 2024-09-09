//
//  LibrarySDK.swift
//  LibrarySDK
//
//  Created by Arthur Conforti on 08/09/2024.
//

import Foundation

public class LibraryService {
    
    // Singleton instance for easy access
    public static let shared = LibraryService()

    private init() {}
    
    /**
     Public method to send a string to the backend API.
     
     - Parameters:
       - string: The string to be sent to the backend.
       - completion: A completion handler that returns a `Result<Bool, Error>`, indicating success or failure.
     */
    public func sendString(_ string: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !string.isEmpty else {
            return completion(.failure(NSError(domain: "Empty String", code: -3, userInfo: [NSLocalizedDescriptionKey: "String cannot be empty."])))
        }
        
        guard let url = URL(string: "https://us-central1-mobilesdklogging.cloudfunctions.net/saveString") else {
            return completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        }
        
        // Prepare the request with the given string
        let request = prepareRequest(with: url, body: ["myString": string], completion: completion)
        
        // Execute the request
        executeRequest(request, completion: completion)
    }
    
    /**
     Private method to prepare the URLRequest.
     
     - Parameters:
       - url: The URL to send the request to.
       - body: The body of the request in dictionary format.
       - completion: A completion handler that returns a `Result<Bool, Error>`, indicating success or failure.
     - Returns: A configured URLRequest object or calls the completion handler with an error if something goes wrong.
     */
    private func prepareRequest(with url: URL, body: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
        }
        
        return request
    }
    
    /**
     Private method to execute the URLRequest and handle the response.
     
     - Parameters:
       - request: The URLRequest to be executed.
       - completion: A completion handler that returns a `Result<Bool, Error>`, indicating success or failure.
     */
    private func executeRequest(_ request: URLRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            // Check the response status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: -2, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}

