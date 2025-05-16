//
//  SetUpProfileModelProtocol.swift
//  AppStarterKit
//
//  Created by MK-Mini on 16/4/2568 BE.
//

protocol SetUpProfileModelProtocol {
    var avatar: String? { get }
    var name: String? { get }
    var status: Bool { get }
    var token: String? { get }
    var isNew: Bool? { get }
}

extension SetUpProfileModelProtocol {
    var isNew: Bool? {
        return nil
    }
}
