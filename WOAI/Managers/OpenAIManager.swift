//
//  OpenAIManager.swift
//  WOAI
//
//  Created by 양승완 on 11/27/24.
//

import Foundation

protocol OpenAiManagerProtocol {
    func appendMeetingMembers(members:[String])
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<MeetingTask, Error>
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
        당신은 대화 기록을 매우 세부적으로 분석하고 요약하는 데 특화된 고급 AI 어시스턴트입니다. 주어진 대화를 기반으로 데이터를 아래 기준에 맞춰 구조화하고 요약하세요.

    

        0. 1번 부터는 대화일때를 얘기하는거야 만약 대화가 아니라고 판단될 경우에는 그냥 전체적인 내용을 요역해줘.

        
        
        1. **Issue 분류**:
           - 대화에서 논의된 주요 주제 또는 이슈(Issue)를 식별하세요.
           - 관련된 내용을 그룹화하여 각 Issue에 따라 정리하세요.
           - 각 Issue에 대해 주요 주제, 핵심 세부사항, 논의 결과 또는 결론을 포함하세요.

        2. **세부 요약**:
           - 각 Issue별로 논의된 내용이 무엇인지, 왜 논의되었는지, 실행해야 할 항목이 무엇인지 간결하게 요약하세요.
           - 논의 중 나온 중요한 결정, 합의된 내용, 또는 추가적인 후속 작업이 필요한 부분을 강조하세요.

        3. **시간 기반 세분화**:
           - 대화 중 시간과 관련된 언급(예: "10시," "오후 3시," "나중에," "처음에" 등)을 감지하세요.
           - 시간 순서대로 대화를 정리하고, 각 시간대에 어떤 주제가 논의되었는지 명시하세요.

        4. **약속 및 일정(Issue) 추출**:
           - 대화에서 약속, 일정 조율, 계획 수립과 관련된 발언을 식별하세요.
           - 참가자, 날짜, 시간, 장소 등 약속과 관련된 세부정보를 추출하여 별도의 "약속(Issue)" 카테고리로 정리하세요.

        5. **화자 구분**:
           - 화자 정보가 제공된 경우, 각 대화 내용을 해당 화자와 연결하세요.
           - "화자 1," "화자 2" 등의 태그를 사용하여 각 발언을 구분하세요.

        6. **결과물의 구조화**:
           - 아래의 구조화된 형식(JSON 유사)에 따라 결과를 출력하세요:
             - Issues: 주제별 정리.
             - Timeline: 시간 순서로 정리된 논의 내용.
             - Scheduling Tasks: 약속 및 일정 관련 정리.
        
     특이사항: '-' 라는 텍스트로 화자가 분리되어있습니다.

        ### 예시 입력:
        예를 들어, 대화에서 프로젝트 업데이트, 신규 기능 브레인스토밍, 팀 할당 논의, 다음 주 월요일 오후 3시에 있을 미팅 일정 등이 포함될 수 있습니다.

        ### 기대 출력 형식: JSON
        ### 항목들이 존재하지 않더라도 empty 값이나 dummy 값으로 전송해주세요. ex) "Date": "", "Time": ""
        
        
          "Issues": [
            {
              "IssueName": "프로젝트 업데이트",
              "Details": "현재 스프린트 진행 상황을 논의하고, 장애 요인을 확인했으며, 해결 방안을 제안함.",
              "ActionItems": ["장애 요인 A를 금요일까지 해결", "마케팅 팀과 콘텐츠 승인 관련 후속 조치."]
            },
            {
              "IssueName": "기능 브레인스토밍",
              "Details": "신규 온보딩 기능에 대한 아이디어를 브레인스토밍하고, 제안의 실현 가능성을 평가함.",
              "ActionItems": ["제안된 기능 B의 초기 설계 작성", "다음 회의 전 실현 가능성 보고 준비."]
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
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<MeetingTask, Error> {
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

        return AsyncThrowingStream<MeetingTask, Error> { continuation in
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
                        print("stripped **\(responseText)**")
                        let task = try await JsonManager.shared.getJson(stripped)
                        continuation.yield(task)
                    } catch {
                        continuation.finish(throwing: error)
                    }
                    print("responseText\(responseText)")

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
