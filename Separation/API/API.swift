
//  API.swift
//  Test
//
//  Created by Graham Nadel on 2/8/24.
//

import Foundation
import Alamofire
import AVFoundation
import SwiftData

class API: ObservableObject {
    @Published var separatedAudio: SeparatedAudio?
    @Published var isSeparating = false
    

    func callAPI(for audioURL: URL, completionHandler: @escaping (Bool) -> Void) {
//        ngrok forwarding URL
//        Library == nonFuncional
//        Home 192.168.0.24
//        FrenchPress 192.168.208.183
//        Hotspot 10.21.8.101
        isSeparating = true
        let apiURL = "http://172.20.10.5:5001"
        
        let request = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioURL, withName: "audio_file")
            
        }, to: apiURL) { urlRequest in
            urlRequest.timeoutInterval = 120
        }
        
        request.responseDecodable(of: SeparatedAudio.self) { response in
            self.isSeparating = false
            
            switch response.result {
            case .success(let separatedAudioDict):
                self.separatedAudio = separatedAudioDict
                
                print("response decoded")
                completionHandler(true)
            case .failure(let error):
                print("Error: No api response. \(error)")
                completionHandler(false)
            }
        }
    }
}
