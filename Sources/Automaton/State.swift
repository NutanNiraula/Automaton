//
//  State.swift
//  
//
//  Created by Nutan Niraula on 2/6/23.
//

public protocol State: CaseIterable, Hashable, RawRepresentable, Equatable {}

public enum StateError: Error, Equatable {
    case impossible(String)
}
