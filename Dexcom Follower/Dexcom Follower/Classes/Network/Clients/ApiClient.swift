//
//  ApiClient.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift

protocol ApiClientType: EnvironmentInjected, AuthClientInjected {
    
    // Login
    func loginToken(authenticationCode: String, complete: @escaping(TokenResponse) -> ())
    
    // Devices
    func getDevices(token: String, complete: @escaping(DeviceResponse) -> ())
    
    // Estimated Glucose Values
    func getEgvs(token: String, complete: @escaping(EgvResponse) -> ())
    
}

extension Network {
    struct ApiClient: ApiClientType {
        private static let timeoutInterval: TimeInterval = 10
        
        // Login
        func loginToken(authenticationCode: String, complete: @escaping(TokenResponse) -> ()) {
            let headers = [
                "content-type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"
            ]
            
            let postData = NSMutableData(data: "client_secret=\(Credentials.clientSecret)".data(using: String.Encoding.utf8)!)
            postData.append("&client_id=\(Credentials.clientId)".data(using: String.Encoding.utf8)!)
            postData.append("&code=\(authenticationCode)".data(using: String.Encoding.utf8)!)
            postData.append("&grant_type=authorization_code".data(using: String.Encoding.utf8)!)
            postData.append("&redirect_uri=\(Credentials.returnUri)".data(using: String.Encoding.utf8)!)
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://sandbox-api.dexcom.com/v2/oauth2/token")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                guard let unwrappedData = data else { return }
                do {
                    let decoder: JSONDecoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decoded = try decoder.decode(TokenResponse.self, from: unwrappedData)
                    complete(decoded)
                } catch {
                    return
                }
            })
            dataTask.resume()
        }
        
        // Devices
        func getDevices(token: String, complete: @escaping(DeviceResponse) -> ()) {
            let headers = ["authorization": "Bearer \(token)"]
            let endpointString: String = "\(httpProtocol)\(Endpoint.domain.path)\(Endpoint.devices.path)"
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let endDate: String = df.string(from: Date())
            let startDate: String = df.string(from: .init(timeIntervalSinceNow: -86_400))
            var decoded: DeviceResponse = DeviceResponse.defaultResponse()
//            let urlString = "\(endpointString)?startDate=\(startDate)&endDate=\(endDate)"
            let urlString = "\(endpointString)?startDate=2017-06-01T08:00:00&endDate=2017-06-02T08:00:00"
            if let url: URL = URL(string: urlString) {
                let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        // TODO: Display error
                    } else {
                        guard data != nil else { return }
                        do {
                            var decoder: JSONDecoder {
                                let decoder: JSONDecoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .custom { decoder in
                                    let container = try decoder.singleValueContainer()
                                    let dateString = try container.decode(String.self)
                                    
                                    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    if let date = df.date(from: dateString) {
                                        return date
                                    }
                                    df.dateFormat = "HH:mm"
                                    if let date = df.date(from: dateString) {
                                        return date
                                    }
                                    throw DecodingError.dataCorruptedError(in: container,
                                                                           debugDescription: "Cannot decode date string \(dateString)")
                                }
                                return decoder
                            }
                            decoded = try decoder.decode(DeviceResponse.self, from: data!)
                            complete(decoded)
                        } catch {
                            print(error)
                            return
                        }
                    }
                })
                
                dataTask.resume()
            }
        }
        
        // Estimated Glucose Values
        func getEgvs(token: String, complete: @escaping(EgvResponse) -> ()) {
            let headers = ["authorization": "Bearer \(token)"]
            let endpointString: String = "\(httpProtocol)\(Endpoint.domain.path)\(Endpoint.egvs.path)"
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let endDate: String = df.string(from: Date())
            let startDate: String = df.string(from: .init(timeIntervalSinceNow: -86_400))
//            let urlString = "\(endpointString)?startDate=\(startDate)&endDate=\(endDate)"
            let urlString = "\(endpointString)?startDate=2017-06-01T08:00:00&endDate=2017-06-02T08:00:00"
            guard let url: URL = URL(string: urlString ) else { return }
    
            let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                guard error == nil else {
                    // TODO: Display error
                    return
                }
                guard data != nil else {
                    // TODO: Display error
                    return
                }
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse?.statusCode)
                do {
                    let decoder: JSONDecoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(df)
                    let decoded = try decoder.decode(EgvResponse.self, from: data!)
                    complete(decoded)
                } catch {
                    print(error)
                    return
                }
            })
            
            dataTask.resume()
        }
    }
}
