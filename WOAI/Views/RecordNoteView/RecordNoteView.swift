import SwiftUI
import AVFAudio
import Combine

#Preview {
    RecordNoteView()
}
struct RecordNoteView: View {
    @StateObject private var viewModel = RecordNoteVM()

    var body: some View {
        VStack(spacing: 10) {
            Text("RecordNote")
                .font(.title3)
                .padding(.horizontal)
            RecordNoteTopView(viewModel: self.viewModel)
            RecordNoteBottomListView(viewModel: self.viewModel)
        }.background(Color.mainBackground)
        .onAppear {
                viewModel
                .onAppear()

        }
    }
}
