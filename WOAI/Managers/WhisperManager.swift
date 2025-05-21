import AVFAudio
import AVFoundation
import Foundation
import WhisperKit

final class WhisperManager {
    
    
    init() {}

    /// 로컬 파일 경로로부터 WhisperKit을 이용해 텍스트 추출
    func transcribeAudio(at fileURL: URL) async throws -> String {
        let whisper = try await WhisperKit()
        guard let result = try await whisper.transcribe(
            audioPath: fileURL.path,
            decodeOptions: DecodingOptions(language: "whisper_language".localized)
        ).first else {
            print("err")
            throw NSError(domain: "WhisperManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No transcription result"])
        }
        return result.text
    }
}
