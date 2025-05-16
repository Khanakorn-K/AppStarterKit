//
//  StateContainer.swift
//  AppStarterKit
//
//  Created by MK-Mini on 25/4/2568 BE.
//

import SwiftUI

// Protocol for state containers that support optional overrides
protocol StateContainer {
    associatedtype BaseState
    associatedtype OverrideState
    
    // Get the effective value, using override if available
    func effectiveValue<T>(base: T, override: T?) -> T
    
    // Update the state using a closure
    func updateState(_ update: (inout OverrideState) -> Void)
    
    // Animate state changes
    func animateState(animation: Animation, _ update: @escaping (inout OverrideState) -> Void)
    
    // Reset all overrides
    func resetState()
}

// A class that manages optional state overrides for SwiftUI views
final class OptionalStateManager<T>: ObservableObject, StateContainer {
    typealias OverrideState = T
    typealias BaseState = Void
    
    @Published var state: T
    
    init(initialState: T) {
        self.state = initialState
    }
    
    // Get effective value (override or base)
    func effectiveValue<V>(base: V, override: V?) -> V {
        return override ?? base
    }
    
    // Update state with closure
    func updateState(_ update: (inout T) -> Void) {
        var newState = state
        update(&newState)
        state = newState
    }
    
    // Animate state changes
    func animateState(animation: Animation = .default, _ update: @escaping (inout T) -> Void) {
        withAnimation(animation) {
            updateState(update)
        }
    }
    
    // Reset state to initial values
    func resetState() {
        // This assumes T can be initialized with default values
        state = T.self as! T
    }
    
    // Reset state to specific values
    func resetState(to newState: T) {
        state = newState
    }
}
