//
//  ImageService.swift
//  Farmdrop
//
//  Created by James Beattie on 16/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import Moya

enum ImageService {
    case downloadImage(path: String)
}

extension ImageService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://fd-v5-api-release.imgix.net/assets/producer/")!
    }
    
    var path: String {
        switch self {
        case .downloadImage(let path):
            return "\(path)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .downloadImage:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .downloadImage:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .downloadImage:
            return URLEncoding.default // Send parameters in URL
        }
    }
    
    var sampleData: Data {
        switch self {
        case .downloadImage:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .downloadImage:
            return .request
        }
    }
}
