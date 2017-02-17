//
//  ProducersService.swift
//  Farmdrop
//
//  Created by James Beattie on 15/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation
import Moya

enum NetworkService {
    case showProducers
    case showPagedProducers(page: Int, numberOfProducers: Int)
}

extension NetworkService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://fd-v5-api-release.herokuapp.com/2")!
    }
    
    var path: String {
        switch self {
        case .showProducers, .showPagedProducers:
            return "/producers"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .showProducers, .showPagedProducers:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .showProducers:
            return nil
        case .showPagedProducers(let page, let num):
            var params: [String: Int] = [:]
            params["page"] = page
            params["per_page_limit"] = num
            return params
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .showProducers, .showPagedProducers:
            return URLEncoding.default // Send parameters in URL
        }
    }
    
    var sampleData: Data {
        switch self {
        case .showProducers:
            return "{\"response\":[{\"id\":170,\"name\":\"Purton House Organics\",\"permalink\":\"purton-house-organics\",\"created_at\":\"2014-04-14T10:38:55.267+01:00\",\"updated_at\":\"2017-01-20T17:33:11.000+00:00\",\"images\":[{\"path\":\"https://fd-v5-api-release.imgix.net/assets/producer/33ceef48bff5238c88ccda3eecd3d04d3f13d618fcfb59815b0cef31350c65d1/purton_rally_540by415.jpg\",\"position\":1}],\"short_description\":\"Mother and daughter-­run Purton House Organics supplies much of our fruit and vegetables, as well as organic beef, pork and eggs\",\"description\":\"Mother and daughter-­run Purton House Organics supplies much of our fruit and vegetables, as well as organic beef, pork and eggs.\r\n\r\nSet over 70 hectares of Wiltshire countryside, the farm is proud to have held organic status since 1997. \",\"location\":\"Purton, Wiltshire\",\"via_wholesaler\":true,\"wholesaler_name\":\"Purton House Organics\"}".utf8Encoded
        case .showPagedProducers(_, _):
            return "{\"response\":[{\"id\":170,\"name\":\"Purton House Organics\",\"permalink\":\"purton-house-organics\",\"created_at\":\"2014-04-14T10:38:55.267+01:00\",\"updated_at\":\"2017-01-20T17:33:11.000+00:00\",\"images\":[{\"path\":\"https://fd-v5-api-release.imgix.net/assets/producer/33ceef48bff5238c88ccda3eecd3d04d3f13d618fcfb59815b0cef31350c65d1/purton_rally_540by415.jpg\",\"position\":1}],\"short_description\":\"Mother and daughter-­run Purton House Organics supplies much of our fruit and vegetables, as well as organic beef, pork and eggs\",\"description\":\"Mother and daughter-­run Purton House Organics supplies much of our fruit and vegetables, as well as organic beef, pork and eggs.\r\n\r\nSet over 70 hectares of Wiltshire countryside, the farm is proud to have held organic status since 1997. \",\"location\":\"Purton, Wiltshire\",\"via_wholesaler\":true,\"wholesaler_name\":\"Purton House Organics\"}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .showProducers, .showPagedProducers:
            return .request
        }
    }
}
