import Foundation
import Combine
import AVFAudio

class RecordingVM: ObservableObject {
    @Published var labelText: String = ""
    @Published var isRecording: Bool = false
    @Published var members: [String] = []
    
    private var audioRecorder: AVAudioRecorder?
    private let audioSession = AVAudioSession.sharedInstance()
    private var recordingFileURL: URL?
    private var fileName: String = ""
    private var startRecorded: Date? = nil
    private var finishRecorded: Date? = nil
    
    private let dateFormatter = DateFormatter()
    private let openAIManager: OpenAiManagerProtocol
    private let whisperManager: WhisperManager
    
    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "chatGPTApiKey") as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        
        self.openAIManager = OpenAiManager(apiKey: apiKey)
        self.whisperManager = WhisperManager()
        
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
        startRecorded = .now
        
        fileName = "recording_\(TimeManager.shared.getUntilDays(inputDate: startRecorded!) + " " + TimeManager.shared.getOnlyTimes(inputDate: startRecorded!)).m4a"

        
        let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("WOAIRecords")
        
            // 폴더 없으면 생성
        if !FileManager.default.fileExists(atPath: folderURL.path) {
               try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
           }

        let fileURL = folderURL.appendingPathComponent(fileName)
        
        
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
        finishRecorded = .now
        
        
        //        if let url = recordingFileURL {
        //            transcribeAndSummarize(url: URL(string: todo))
        //        }
        
        if let url = Bundle.main.url(forResource: "testAudio_0", withExtension: "m4a") {
            transcribeAndSummarize(url: url)
            
        } else {
            print("❌ 파일을 찾을 수 없음")
        }
    }
    
    private func transcribeAndSummarize(url: URL) {
        Task {
            do {
                let text = try await whisperManager.transcribeAudio(at: url)
                openAIManager.appendMeetingMembers(members: members)
                let meetingTask = try await openAIManager.sendMessageStream(text: text)
                
                for try await message in meetingTask {
                    await MainActor.run {
                       let viewContext = CoreDataManager.shared.container.viewContext
                        let newMeeting = MeetingTaskCoreData(context: viewContext)
                        
                        newMeeting.meetingTitle = message.meetingTitle
                        newMeeting.meetingSummary = message.meetingSummary
                        newMeeting.recordedAt = message.recordedAt
                        newMeeting.startRecorded = self.startRecorded
                        newMeeting.finishRecorded = self.finishRecorded
                        
                        _ = message.issues.map {
                            let newIssue = IssueCoreData(context: viewContext)
                            newIssue.actionItems = $0.actionItems
                            newIssue.details = $0.details
                            newIssue.issueName = $0.issueName

                            newMeeting.addToIssues(newIssue)
                            return newIssue
                        }
                        _ = message.timeline.map {
                            let newTimeline = TimelineCoreData(context: viewContext)
                            newTimeline.discussion = $0.discussion
                            newTimeline.time = $0.time
                            newMeeting.addToTimeline(newTimeline)

                            return newTimeline
                        }
                        _ = message.schedulingTasks.map {
                            let newSchedulingTask = SchedulingTaskCoreData(context: viewContext)
                            newSchedulingTask.date = $0.date
                            newSchedulingTask.participants = $0.participants
                            newSchedulingTask.subject = $0.subject
                            newSchedulingTask.time = $0.time
                            newMeeting.addToSchedulingTasks(newSchedulingTask)

                            return newSchedulingTask
                        }

                        
                        do {
                            
                            try viewContext.save()
                            print("저장 성공")
                        } catch {
                            print("저장 실패: \(error)")
                        }
                        
                        self.labelText = "완료"
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
    
    func onAppear() {
        self.startRecording()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.stopRecording()

        }
    }
}
