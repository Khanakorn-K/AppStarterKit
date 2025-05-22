//
//  QuizMode.swift
//  AppStarterKit
//
//  Created by MK-Mini on 26/4/2568 BE.
//

enum QuizMode: String, Codable, UnknownCase {
    case `default` = "DEFAULT"
    case special = "SPECIAL"
    
    case unknown
    static var unknownCase: QuizMode = .unknown
}
