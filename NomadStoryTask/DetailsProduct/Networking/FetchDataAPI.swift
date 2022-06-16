//
//  FetchDataAPI.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import Foundation
import Combine

protocol FetchDataAPIProtocol {
    func fetchData() -> AnyPublisher<DataModel, NetworkErrror>
}

class FetchDataAPI: FetchDataAPIProtocol {
    
    private var networkRequest: Requestable
    private var environment: Environment = .production
    
    // inject this for testability
    init(networkRequest: Requestable, environment: Environment) {
        
        self.networkRequest  = networkRequest
        self.environment     = environment
        
    }
    
    func fetchData() -> AnyPublisher<DataModel, NetworkErrror> {
        
        let endpoint = PurchaseServiceEndpoints.fetchData
        let request  = endpoint.fetchData(environment: self.environment)
        
        return self.networkRequest.request(request)
    }
    
}
