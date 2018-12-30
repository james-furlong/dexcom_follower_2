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
        
        // Devices
        func getDevices(token: String) {
            let headers = ["authorization": "Bearer \(token)"]
            let endpointString: String = "\(httpProtocol)\(Endpoint.devices)"
            let df: ISO8601DateFormatter = ISO8601DateFormatter()
            let endDate: String = df.string(from: Date())
            let startDate: String = df.string(from: .init(timeIntervalSinceNow: -3600))
            guard let url: URL = URL(string: "\(endpointString)?startDate=\(startDate)&endDate=\(endDate)") else { return }
            
            let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    if data != nil {
                        
                    }
                }
            })
            
            dataTask.resume()
        }
        
        // Estimated Glucose Values
        func getEgvs(token: String) {
            let headers = ["authorization": "Bearer \(token)"]
            let endpointString: String = "\(httpProtocol)\(Endpoint.egvs)"
            let df: ISO8601DateFormatter = ISO8601DateFormatter()
            let endDate: String = df.string(from: Date())
            let startDate: String = df.string(from: .init(timeIntervalSinceNow: -3600))
            guard let url: URL = URL(string: "\(endpointString)?startDate=\(startDate)&endDate=\(endDate)") else { return }
    
            let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                guard error == nil else {
                    print(error)
                    return
                }
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                if data != nil {
                    let responseData:String! = String(data: data!, encoding: String.Encoding.utf8)
                    print(responseData)
                }
            })
            
            dataTask.resume()
        }
    }
    
//    struct MockApiClient: ApiClientType {
//        // Login
//        func loginToken(authenticationCode: String) -> Single<TokenResponse> {
//            let headers = [
//                "content-type": "application/x-www-form-urlencoded",
//                "cache-control": "no-cache"
//            ]
//
//            let postData = NSMutableData(data: "client_secret=\(Credentials.clientSecret)".data(using: String.Encoding.utf8)!)
//            postData.append("&client_id=\(Credentials.clientId)".data(using: String.Encoding.utf8)!)
//            postData.append("&code=\(authenticationCode)".data(using: String.Encoding.utf8)!)
//            postData.append("&grant_type=authorization_code".data(using: String.Encoding.utf8)!)
//            postData.append("&redirect_uri=\(Credentials.returnUri)".data(using: String.Encoding.utf8)!)
//
//            let request = NSMutableURLRequest(url: NSURL(string: "https://api.dexcom.com/v2/oauth2/token")! as URL,
//                                              cachePolicy: .useProtocolCachePolicy,
//                                              timeoutInterval: 10.0)
//            request.httpMethod = "POST"
//            request.allHTTPHeaderFields = headers
//            request.httpBody = postData as Data
//
//            let session = URLSession.shared
//            var decoded: TokenResponse = TokenResponse.defaultResponse()
//
//            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//
//                guard let unwrappedData = data else { return }
//                do {
//                    let decoder: JSONDecoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    decoded = try decoder.decode(TokenResponse.self, from: unwrappedData)
//                    return
//                } catch {
//                    return
//                }
//            })
//            dataTask.resume()
//            return Single.just(decoded)
//        }
//    }
//
//    struct SandboxApiClient: ApiClientType {
//        // Login
//        func loginToken(authenticationCode: String) -> Single<TokenResponse> {
//            let headers = [
//                "content-type": "application/x-www-form-urlencoded",
//                "cache-control": "no-cache"
//            ]
//
//            let postData = NSMutableData(data: "client_secret=\(Credentials.clientSecret)".data(using: String.Encoding.utf8)!)
//            postData.append("&client_id=\(Credentials.clientId)".data(using: String.Encoding.utf8)!)
//            postData.append("&code=\(authenticationCode)".data(using: String.Encoding.utf8)!)
//            postData.append("&grant_type=authorization_code".data(using: String.Encoding.utf8)!)
//            postData.append("&redirect_uri=\(Credentials.returnUri)".data(using: String.Encoding.utf8)!)
//
//            let request = NSMutableURLRequest(url: NSURL(string: "https://api.dexcom.com/v2/oauth2/token")! as URL,
//                                              cachePolicy: .useProtocolCachePolicy,
//                                              timeoutInterval: 10.0)
//            request.httpMethod = "POST"
//            request.allHTTPHeaderFields = headers
//            request.httpBody = postData as Data
//
//            let session = URLSession.shared
//            var decoded: TokenResponse = TokenResponse.defaultResponse()
//
//            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//
//                guard let unwrappedData = data else { return }
//                do {
//                    let decoder: JSONDecoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    decoded = try decoder.decode(TokenResponse.self, from: unwrappedData)
//                    return
//                } catch {
//                    return
//                }
//            })
//            dataTask.resume()
//            return Single.just(decoded)
//        }
//    }
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
