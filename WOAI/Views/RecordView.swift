import SwiftUI
import AVFAudio
import Combine

#Preview {
    RecordView()
}
struct RecordView: View {
    @StateObject private var viewModel = RecordVM()

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Text(viewModel.isRecording ? "stop" : "record")
                    .foregroundColor(.black)
                    .frame(width: 100, height: 100)
                    .background(Color.red)
                    .clipShape(Circle())
            }
            
            ScrollView {
                Text(viewModel.labelText)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
        }
        .padding(.bottom, 20)
        .onAppear {
            // viewModel에서 초기 데이터 로딩 필요 시
        }
    }
}
