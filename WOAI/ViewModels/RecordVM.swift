import Foundation
import Combine
import AVFAudio

class RecordVM: ObservableObject {
    @Published var labelText: String = ""
    @Published var isRecording: Bool = false

    private var audioRecorder: AVAudioRecorder?
    private let audioSession = AVAudioSession.sharedInstance()
    private var recordingFileURL: URL?
    private var fileName: String = ""

    private let openAIManager: OpenAiManager
    private let whisperManager: WhisperManager

    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "chatGPTApiKey") as? String else {
            fatalError("API_KEY not found in Info.plist")
        }

        self.openAIManager = OpenAiManager(apiKey: apiKey)
        self.whisperManager = WhisperManager(chatGPT: self.openAIManager)

        Task {
            await requestPermissionsAndConfigureSession()
        }
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        isRecording = true
        labelText = "\n녹음중..."

        fileName = "recording_\(UUID().uuidString).m4a"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        recordingFileURL = fileURL

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
        } catch {
            print("녹음 시작 실패: \(error)")
        }
    }

    private func stopRecording() {
        isRecording = false
        labelText = "\n분석중..."
        audioRecorder?.stop()

        if let url = recordingFileURL {
            transcribeAndSummarize(url: url)
        }
    }

    private func transcribeAndSummarize(url: URL) {
        Task {
            do {
                let text = try await whisperManager.transcribeAudio(at: url)
                let stream = try await openAIManager.sendMessageStream(text: text)
                
                var result = ""
                for try await message in stream {
                    result += message
                    await MainActor.run {
                        self.labelText = result
                    }
                }
            } catch {
                print("❌ 오류 발생: \(error)")
                await MainActor.run {
                    self.labelText = "오류가 발생했어요.\n다시 시도해주세요!"
                }
            }
        }
    }

    private func requestPermissionsAndConfigureSession() async {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)

            let granted = await withCheckedContinuation { continuation in
                AVAudioApplication.requestRecordPermission { allowed in
                    continuation.resume(returning: allowed)
                }
            }

            if granted {
                print("🎤 마이크 권한 허용됨")
            } else {
                print("🚫 마이크 권한 거부됨")
            }

        } catch {
            print("🎧 오디오 세션 설정 실패: \(error)")
        }
    }
}
