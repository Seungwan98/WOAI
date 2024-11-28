//
//  OpenAIManager.swift
//  WOAI
//
//  Created by 양승완 on 11/27/24.
//

import Foundation

class ChatGPTAPI: @unchecked Sendable {

    
    
    private let systemMessage: Message
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


    init(apiKey: String, model: String = "gpt-3.5-turbo", temperature: Double = 0.5) {
        self.apiKey = apiKey
        self.model = model

        let systemPrompt = ""

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
        let maxCharacterLimit = 300000 // Imposta un limite di caratteri
        var totalCharacters = messages.contentCount
        while totalCharacters > maxCharacterLimit {
            if historyList.count > 2 {
                historyList.removeFirst()
                messages = [systemMessage] + historyList + [messages.last!]
                totalCharacters = messages.contentCount
            } else {
                // Se la cronologia è troppo corta, tronca l'ultimo messaggio
                if let lastMessage = messages.last {
                    let allowedContentCount = maxCharacterLimit - messages.dropLast().contentCount
                    if allowedContentCount > 0 {
                        let truncatedContent = String(lastMessage.content.prefix(allowedContentCount))
                        messages[messages.count - 1] = Message(role: lastMessage.role, content: truncatedContent)
                    } else {
                        messages.removeLast() // Rimuove l'ultimo messaggio se non ci sono caratteri consentiti
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

    private func appendToHistoryList(userText: String, responseText: String) {
        self.historyList.append(.init(role: "user", content: userText))
        self.historyList.append(.init(role: "assistant", content: responseText))
    }

    // Funzione per inviare messaggi in streaming
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
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

        return AsyncThrowingStream<String, Error> { continuation in
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
                            continuation.yield(text)
                        }
                    }
                    print("responseText\(responseText)")

                    self.appendToHistoryList(userText: text, responseText: responseText)
                    continuation.finish()
                } catch {
                    print("error\(error)")
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // Funzione per inviare messaggi senza streaming
    func sendMessage(_ text: String) async throws -> String {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, stream: false)

        let (data, response) = try await urlSession.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError.customError(withMessage: "Invalid response")
        }

        guard 200...299 ~= httpResponse.statusCode else {
            
            var error = "Bad Response: \(httpResponse.statusCode)"
            if let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                error.append("\n\(errorResponse.message)")
            }
            throw NSError.customError(withMessage: error)
        }

        do {
            let completionResponse = try self.jsonDecoder.decode(CompletionResponse.self, from: data)
            let responseText = completionResponse.choices.first?.message.content ?? ""
            self.appendToHistoryList(userText: text, responseText: responseText)
            return responseText
        } catch {
            throw error
        }
    }

    // Funzione per caricare la cronologia
//    func loadHistoryList() {
//        let historyKey = "historyList_\(assistantID.uuidString)"
//        if let savedHistory = UserDefaults.standard.data(forKey: historyKey) {
//            let decoder = JSONDecoder()
//            if let decodedHistory = try? decoder.decode([Message].self, from: savedHistory) {
//                historyList = decodedHistory
//            } else {
//                historyList = []
//            }
//        } else {
//            historyList = []
//        }
//    }

  
}

// Estensione per creare errori personalizzati
extension NSError {
    static func customError(withMessage message: String) -> NSError {
        return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
