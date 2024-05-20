//
//  State.swift
//  
//
//  Created by Nutan Niraula on 2/6/23.
//

import Foundation

public protocol State: CaseIterable, Hashable, RawRepresentable, Equatable {}

public enum StateError: Error, Equatable {
    case impossible(String)
}

extension StateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .impossible(let reason):
            return NSLocalizedString(reason, comment: "")
        }
    }
}
