//
//  NetworkCall.swift
//  Machine Test
//
//  Created by Alen C James on 16/09/24.
//

import Foundation
import SwiftUI

class NetworkCall {
    func performAPICall(completion: @escaping (Result<[Json4Swift_Base], Error>) -> Void) {
        guard let url = URL(string: "https://64bfc2a60d8e251fd111630f.mockapi.io/api/Todo") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Return the error if the request fails
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Json4Swift_Base].self, from: data) // Decode into the model
                completion(.success(decodedData)) // Return the decoded data on success
            } catch {
                completion(.failure(error)) // Return the error if decoding fails
            }
        }
        task.resume()
    }
}


//
//class NetworkCall {
//    func performAPICall() {
//        let url = URL(string: "https://64bfc2a60d8e251fd111630f.mockapi.io/api/Todo")
//        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "")
//                return
//            }
//            do {
//                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data)
//                print(someDictionaryFromJSON)
//            } catch let parseError {
//                print("JSON Error \(parseError.localizedDescription)")
//            }
//            
//        }
//        task.resume()
//    }
//
//}
