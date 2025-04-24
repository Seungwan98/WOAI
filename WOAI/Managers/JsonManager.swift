//
//  JsonManager.swift
//  WOAI
//
//  Created by 양승완 on 4/24/25.
//

import Foundation

class JsonManager {
    
    static let shared = JsonManager()
    
    private init() {}
    
    func getJson(_ text: String) async throws -> MeetingTask {
        guard let data = text.data(using: .utf8) else {
            throw JsonError.invalidData
        }

        do {
            let meeting = try JSONDecoder().decode(MeetingTask.self, from: data)
            return meeting
        } catch {
            throw JsonError.decodingFailed(error)
        }
    }
}

// 에러 정의 (명확하게!)
enum JsonError: Error {
    case invalidData
    case decodingFailed(Error)
}

