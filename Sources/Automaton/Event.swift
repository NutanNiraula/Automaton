//
//  Event.swift
//  
//
//  Created by Nutan Niraula on 2/6/23.
//

public protocol Event: Equatable, CaseIterable, Hashable {
    func handleSideEffect()
}

public extension Event {
    func handleSideEffect() {}
}
