//
//  NetworkState.swift
//  CodingTest
//
//  Created by Andrés Padilla on 22/6/21.
//

import UIKit
import Foundation
import Alamofire

class NetworkState {
    
    class func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
//    let reachabilityManager = NetworkReachabilityManager()
    
}
