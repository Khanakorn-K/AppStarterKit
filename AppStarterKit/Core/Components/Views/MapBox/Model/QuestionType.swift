//
//  QuestionType.swift
//  AppStarterKit
//
//  Created by MK-Mini on 26/4/2568 BE.
//

enum QuestionType: String, Codable, UnknownCase {
    case quest = "QUEST"
    case single = "SINGLE"
    case checkIn = "CHECKIN"
    case imageAnswer = "IMAGE_ANSWERING"
    case imageGalleryAnswer = "GALLERY_ANSWERING"
    
    static var unknownCase: QuestionType = .unknown
    case unknown
    
    var title: String {
        switch self {
        case .quest:
            return "ตอบคำถามด้วยข้อความ"
        case .single:
            return "เลือกคำตอบ"
        case .checkIn:
            return "เช็คอิน"
        case .imageAnswer:
            return "ถ่ายภาพ"
        case .imageGalleryAnswer:
            return "อัพโหลดหลายรูปภาพ"
        case .unknown:
            return "Unknown"
        }
    }
}
