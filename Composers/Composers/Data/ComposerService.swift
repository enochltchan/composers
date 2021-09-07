//
//  ComposerService.swift
//  Composers
//
//  Created by Enoch Chan on 4/8/21.
//

import Foundation

enum ComposerCallingError: Error {
    case problemGeneratingURL
    case problemGettingDataFromAPI
    case problemDecodingData
}

class ComposerService {
    private let urlString = "https://run.mocky.io/v3/7887ebe4-cf26-464b-b301-8bb9908f403b"
    
    func getComposers(completion: @escaping ([Composer]?, Error?) -> ()) {
        // getComposers now returns an escaping closure. Closure is SWIFT's way of representing an anonymous function - we don't specify what the caller should be doing.
        // getComposers takes a completion handler from the caller that says: depending on what result we get back from the code, we want to do certain decisions.
        guard let url = URL(string: self.urlString) else {
            DispatchQueue.main.async { completion(nil, ComposerCallingError.problemGeneratingURL) }
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil, ComposerCallingError.problemGettingDataFromAPI) }
                return
            }
            
            do {
                let composerResult = try JSONDecoder().decode(ComposerResult.self, from: data)
                DispatchQueue.main.async { completion(composerResult.composers, nil) }
            } catch (let error) {
                print(error)
                DispatchQueue.main.async { completion(nil, ComposerCallingError.problemDecodingData) }
            }
        }
        task.resume()
    }
}
