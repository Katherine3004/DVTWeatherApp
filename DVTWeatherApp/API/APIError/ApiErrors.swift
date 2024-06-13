//
//  ApiErrors.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import Foundation

public enum ApiError: LocalizedError, Comparable {
    case urlError(message: String)
    
    public var errorDescription: String? {
        switch self {
        case let .urlError(message): return message
        default: return nil
        }
    }
}

