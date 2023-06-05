//
//  File.swift
//  
//
//  Created by Nutan Niraula on 5/6/23.
//

import Foundation

enum MermaidJSConverter {
    
    static func convert<S: State, E: Event>(_ transitions: [StateMachine<S, E>.Transition]) -> String {
        var visualizerMarkup = "stateDiagram-v2\n"
        for transition in transitions {
            visualizerMarkup += "\t\(transition.initialState) --> \(transition.finalState) :\(transition.event)\n"
        }
        return visualizerMarkup
    }
}
