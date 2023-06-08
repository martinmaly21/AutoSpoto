//
//  HTTPMethodType.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

enum HTTPMethodType: Equatable {
    static func == (lhs: HTTPMethodType, rhs: HTTPMethodType) -> Bool {
        switch lhs {
        case .get(_):
            if case .get = rhs {
                return true
            } else {
                return false
            }
        case .post:
            if case .post = rhs {
                return true
            } else {
                return false
            }
        case .put:
            if case .put = rhs {
                return true
            } else {
                return false
            }
        case .delete:
            if case .delete = rhs {
                return true
            } else {
                return false
            }
        }
    }
    
    case get(queryParams: [String:Any]?)
    case post(data: [String:Any]?)
    case put(data: [String:Any]?)
    case delete(data: [String:Any]?)
    
    var httpMethod: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
    
    var data: Data? {
        switch self {
        case .get(queryParams: _):
            return nil
        case .post(let data):
            guard let data = data else {
                return nil
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
                fatalError("Could not create")
            }
            
            return jsonData
        case .put(let data):
            guard let data = data else {
                return nil
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
                fatalError("Could not create")
            }
            
            return jsonData
        case .delete(let data):
            guard let data = data else {
                return nil
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
                fatalError("Could not create")
            }
            
            return jsonData
        }
    }
}
