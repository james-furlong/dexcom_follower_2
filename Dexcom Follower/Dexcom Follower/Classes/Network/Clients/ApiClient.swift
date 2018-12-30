//
//  ApiClient.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift

protocol ApiClientType: EnvironmentInjected {
    
    // Login
    func loginToken(authenticationCode: String) -> Single<TokenResponse>
    
}

extension Network {
    struct ApiClient: ApiClientType {
        private static let timeoutInterval: TimeInterval = 10
        
        // Login
        
        func loginToken(authenticationCode: String) -> Single<TokenResponse> {
            let headers = [
                "content-type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"
            ]
            
            let postData = NSMutableData(data: "client_secret=\(Credentials.clientSecret)".data(using: String.Encoding.utf8)!)
            postData.append("&client_id=\(Credentials.clientId)".data(using: String.Encoding.utf8)!)
            postData.append("&code=\(authenticationCode)".data(using: String.Encoding.utf8)!)
            postData.append("&grant_type=authorization_code".data(using: String.Encoding.utf8)!)
            postData.append("&redirect_uri=\(Credentials.returnUri)".data(using: String.Encoding.utf8)!)
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.dexcom.com/v2/oauth2/token")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            var decoded: TokenResponse = TokenResponse.defaultResponse()
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                guard let unwrappedData = data else { return }
                do {
                    let decoder: JSONDecoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoded = try decoder.decode(TokenResponse.self, from: unwrappedData)
                    return
                } catch {
                    return
                }
            })
            dataTask.resume()
            return Single.just(decoded)
        }
    }
}
// MARK: - Request Construction

extension ApiClientType {
    fileprivate func urlForEndpoint(_ endpoint: Endpoint) -> String {
        return "\(httpProtocol)://\(baseUrl)/\(endpoint.path)"
    }
}

// MARK: - URLRequest

extension URLRequest {
    fileprivate func addingHeaders(_ headers: HTTPHeaders) -> URLRequest {
        var updatedRequest: URLRequest = self
        var updatedHeaders: HTTPHeaders = (self.allHTTPHeaderFields ?? [:])
        
        for (key, value) in headers {
            updatedHeaders[key] = value
        }
        
        updatedRequest.allHTTPHeaderFields = updatedHeaders
        
        return updatedRequest
    }
}
