import Foundation

public class LibrarySDK {
    
    // Singleton instance
    public static let shared = LibrarySDK()

    private init() {}
    
    /**
     Public method to send a string to the backend API.
     
     - Parameters:
       - string: The string to be sent to the backend.
       - completion: A completion handler that returns a `Result<Bool, Error>`, indicating success or failure.
     */
    public func sendString(_ string: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://us-central1-mobilesdklogging.cloudfunctions.net/saveString") else {
            return completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        }
        
        let request = prepareRequest(with: url, body: ["myString": string], completion: completion)
        
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

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: -2, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}

