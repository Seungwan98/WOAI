//
//  OpenAIManager.swift
//  WOAI
//
//  Created by 양승완 on 11/27/24.
//

import Foundation

protocol OpenAiManagerProtocol {
    func appendMeetingMembers(members:[String])
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<MeetingTaskDTO, Error>
}

class OpenAiManager: @unchecked Sendable, OpenAiManagerProtocol {
  
    private var systemMessage: Message
    private let temperature: Double
    private let model: String

    private let apiKey: String
    private var historyList = [Message]()
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }

    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    private var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }


    init(apiKey: String, model: String = "gpt-4o", temperature: Double = 0.5) {
        self.apiKey = apiKey
        self.model = model

        let systemPrompt = """
     당신은 회의 대화를 분석하여 구조화된 JSON으로 정리하는 고급 비서 AI입니다.

     주어진 회의 텍스트를 기반으로 다음의 JSON 구조에 맞춰 내용을 요약 및 분류하세요:

     ---

     🧾 **최상위 항목 (회의 메타 정보)**

     - `MeetingTitle`: 회의의 주제 또는 제목을 요약
     - `MeetingSummary`: 회의의 주요 내용을 두 문장 이내로 요약
     - `RecordedAt`: 회의가 열린 날짜 및 시간 (예: "2025-04-25 오전 10시")

     ---

     📌 **Issues (회의 중 논의된 이슈)**

     - 각 이슈는 다음 필드를 포함합니다:
       - `IssueName`: 논의된 주제 또는 문제의 이름
       - `Details`: 어떤 내용을 논의했는지 상세히 설명
       - `ActionItems`: 후속으로 수행해야 할 작업 리스트 (문자열 배열)

     ---

     🕒 **Timeline (시간 흐름 요약)**

     - 회의 중 각 시간대에 어떤 주제를 다뤘는지 기록합니다:
       - `Time`: "오전 10시", "오후 3시" 등의 형식
       - `Discussion`: 해당 시간에 이루어진 주요 논의

     ---

     📅 **SchedulingTasks (약속 및 일정)**

     - 회의 중 언급된 다음 일정이나 회의 등을 정리합니다:
       - `Subject`: 회의나 약속의 제목
       - `Date`: 약속 날짜 (예: "다음 주 월요일")
       - `Time`: 약속 시간
       - `Participants`: 참여자 리스트

     ---

     💡 주의:

     - `MeetingTitle`, `MeetingSummary`, `RecordedAt`는 **Issues 밖에 위치**
     - `RecordedAt`은 회의 전체의 시점을 나타내며, 각 이슈에는 포함되지 않음
     - 가능한 한 구체적이고 간결한 표현을 사용하세요

     ---

     이제 다음 회의 대화 내용을 기반으로 위와 같은 구조로 JSON을 생성해 주세요.

    {
      "MeetingTitle": "WOAI 온보딩 기능 회의",
      "MeetingSummary": "현재 스프린트 상황을 점검하고 신규 온보딩 기능을 브레인스토밍함.",
      "RecordedAt": "2025-04-25 오전 10시",
      "Issues": [
        {
          "IssueName": "프로젝트 업데이트",
          "Details": "현재 스프린트 진행 상황을 논의하고, 장애 요인을 확인했으며, 해결 방안을 제안함.",
          "ActionItems": [
            "장애 요인 A를 금요일까지 해결",
            "마케팅 팀과 콘텐츠 승인 관련 후속 조치."
          ]
        },
        {
          "IssueName": "기능 브레인스토밍",
          "Details": "신규 온보딩 기능에 대한 아이디어를 브레인스토밍하고, 제안의 실현 가능성을 평가함.",
          "ActionItems": [
            "제안된 기능 B의 초기 설계 작성",
            "다음 회의 전 실현 가능성 보고 준비."
          ]
        }
      ],
      "Timeline": [
        {
          "Time": "오전 10시",
          "Discussion": "프로젝트 업데이트를 검토하고 장애 요인에 대해 논의함."
        },
        {
          "Time": "오전 10시 30분",
          "Discussion": "신규 온보딩 기능에 대한 아이디어를 브레인스토밍함."
        }
      ],
      "SchedulingTasks": [
        {
          "Subject": "팀 미팅",
          "Date": "다음 주 월요일",
          "Time": "오후 3시",
          "Participants": ["John", "Emma", "Alex"]
        }
      ]
    }

   

"""

        self.systemMessage = .init(role: "system", content: systemPrompt)
        self.temperature = temperature
    }

    // Metodo per ottenere il systemMessage
    func getSystemMessage() -> Message {
        return systemMessage
    }

    private func generateMessages(from text: String) -> [Message] {
        var messages = [systemMessage] + historyList
        messages.append(Message(role: "user", content: text))

        // Limita la cronologia per evitare di superare il limite di token
        let maxCharacterLimit = 3000000 // Imposta un limite di caratteri
        var totalCharacters = messages.contentCount
        while totalCharacters > maxCharacterLimit {
            if historyList.count > 2 {
                historyList.removeFirst()
                messages = [systemMessage] + historyList + [messages.last!]
                totalCharacters = messages.contentCount
            } else {
                
                if let lastMessage = messages.last {
                    let allowedContentCount = maxCharacterLimit - messages.dropLast().contentCount
                    if allowedContentCount > 0 {
                        let truncatedContent = String(lastMessage.content.prefix(allowedContentCount))
                        messages[messages.count - 1] = Message(role: lastMessage.role, content: truncatedContent)
                    } else {
                        messages.removeLast()
                    }
                    break
                }
            }
        }

        return messages
    }

    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = Request(model: model, temperature: temperature,
                              messages: generateMessages(from: text), stream: stream)
        print(request)
        return try JSONEncoder().encode(request)
        
    }

    private func appendToHistoryList(systemText: String, responseText: String) {
        self.historyList.append(.init(role: "system", content: systemText))
    }
    
 

    // Funzione per inviare messaggi in streaming
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<MeetingTaskDTO, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)

        let (result, response) = try await urlSession.bytes(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError.customError(withMessage: "Invalid response")
        }

        guard 200...299 ~= httpResponse.statusCode else {
            print("error \(httpResponse.statusCode)")
            var errorText = ""
            for try await line in result.lines {
                errorText += line
            }

            if let data = errorText.data(using: .utf8), let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                errorText = "\n\(errorResponse.message)"
            }

            throw NSError.customError(withMessage: "Bad Response: \(httpResponse.statusCode), \(errorText)")
        }

        return AsyncThrowingStream<MeetingTaskDTO, Error> { continuation in
            Task(priority: .userInitiated) { [weak self] in
                guard let self = self else { return }
                do {
                    var responseText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                            let data = line.dropFirst(6).data(using: .utf8),
                            let response = try? self.jsonDecoder.decode(StreamCompletionResponse.self, from: data),
                            let text = response.choices.first?.delta.content {
                            responseText += text
                        }
                    }
                    
                    do {
                        let stripped = stripMarkdownCodeBlock(from: responseText)
                        print("stripped **\(stripped)**")
                        let task = try await JsonManager.shared.getJson(stripped)
                        continuation.yield(task)
                    } catch {
                        print("stripped, JSON ERROR")
                        continuation.finish(throwing: error)
                    }

                    self.appendToHistoryList(systemText: text, responseText: responseText)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
  
}

extension OpenAiManager {
    func appendMeetingMembers(members: [String]) {
        let content = self.systemMessage.content + "대화에 참여자는 \(members.reduce(""){ $0+","+$1 }) 이야 ~님 이라고 판별된거 같은 경우에 비슷한 이름이 있으면 바꿔줘 \n ex) 교형님 -> 규영님"
        self.systemMessage = Message(role: self.systemMessage.role, content: content)
    }
    func stripMarkdownCodeBlock(from text: String) -> String {
        var cleaned = text

        // 맨 앞에 ```json 또는 ``` 제거
        cleaned = cleaned.replacingOccurrences(of: #"(?m)^```json\s*\n"#, with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: #"(?m)^```\s*\n"#, with: "", options: .regularExpression)

        // 맨 뒤에 ``` 제거
        cleaned = cleaned.replacingOccurrences(of: #"(?m)^```\s*$"#, with: "", options: .regularExpression)

        return cleaned
    }
}

// Estensione per creare errori personalizzati
extension NSError {
    static func customError(withMessage message: String) -> NSError {
        return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
