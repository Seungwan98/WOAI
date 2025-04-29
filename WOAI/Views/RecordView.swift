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
                
            HStack {
                Button(action: {
                    viewModel.toggleRecording()
                }) {
                    VStack {
                        Image(systemName: "microphone.fill").resizable().scaledToFill().frame(width: 30, height: 30).foregroundStyle(Color.mainColor)
                        Spacer().frame(height: 20)
                        
                        Text(viewModel.isRecording ? "stop" : "record")
                            .foregroundColor(.mainColor)
                    }
                    
                       
                }.frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white)
                    .cornerRadius(6)
                
                Spacer().frame(width: 10)
                
                Button(action: {
                    
                    // 파일 업로드 버튼
                }) {
                    
                    VStack {
                        Image(systemName: "square.and.arrow.up").resizable().scaledToFill().frame(width: 30, height: 30).foregroundStyle(Color.mainColor)
                        
                        Spacer().frame(height: 20)
                        Text("File Upload").foregroundStyle(Color.mainColor)
                    }
            
    

                    
                }.frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white)
                    .cornerRadius(6)
                
            }.padding(.horizontal, 40)
        
            HStack {
                Text("녹음 목록").font(.system(size: 30, weight: .bold)).foregroundStyle(Color.mainColor)
                Spacer()
            }.padding(.horizontal, 40)
       
            
            ScrollView {
                Text(viewModel.labelText)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
        }.background(Color.mainBackground)
        .padding(.bottom, 20)
        .onAppear {
            // viewModel에서 초기 데이터 로딩 필요 시
        }
    }
}
