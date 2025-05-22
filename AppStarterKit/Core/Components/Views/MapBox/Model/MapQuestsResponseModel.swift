//
//  MapQuestsResponseModel.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 20/3/2567 BE.
//

import Foundation

struct MapQuestsResponseModel: Codable {
   
    let quests: Quests

    enum CodingKeys: String, CodingKey {
        case quests = "Quests"
    }
    
    // MARK: - Quests
    struct Quests: Codable {
        let quizeMode: QuizMode
        let questionTitle: String
        let questionType: QuestionType
        let questQuestionID: Int

        enum CodingKeys: String, CodingKey {
            case quizeMode = "QuizeMode"
            case questionType = "QuestionType"
            case questionTitle = "QuestionTitle"
            case questQuestionID = "QuestQuestionID"
        }
    }
}

extension MapQuestsResponseModel: Equatable {
    static func == (lhs: MapQuestsResponseModel, rhs: MapQuestsResponseModel) -> Bool {
        lhs.quests.questQuestionID == rhs.quests.questQuestionID
    }
}

