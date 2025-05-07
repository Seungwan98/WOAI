import SwiftUI
import AVFAudio
import Combine

#Preview {
    RecordNoteView()
}
struct RecordNoteView: View {
    @StateObject private var viewModel = RecordNoteVM()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        
        VStack(spacing: 20) {
            Text("RecordNote").font(.title2)
            Spacer()
                
            HStack {
                Button(action: {
                    router.push(.recording)
                }) {
                    VStack {
                        Image(systemName: "microphone.fill").resizable().scaledToFill().frame(width: 30, height: 30).foregroundStyle(Color.mainColor)
                        Spacer().frame(height: 20)
                        
                        Text("record")
                            .foregroundColor(.mainColor)
                    }
                       
                }.frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white)
                    .cornerRadius(20)
                
                Spacer().frame(width: 10)
                
                // TODO V2 FileUpload
//                Button(action: {
//                    // 파일 업로드 버튼
//                }) {
//                    
//                    VStack {
//                        Image(systemName: "square.and.arrow.up").resizable().scaledToFill().frame(width: 30, height: 30).foregroundStyle(Color.mainColor)
//                        
//                        Spacer().frame(height: 20)
//                        Text("File Upload").foregroundStyle(Color.mainColor)
//                    }
//                    
//                }.frame(maxWidth: .infinity, minHeight: 200)
//                    .background(Color.white)
//                    .cornerRadius(6)
                
            }.padding(.horizontal, 100)
        
            HStack {
                Text("녹음 목록").font(.system(size: 30, weight: .bold)).foregroundStyle(Color.mainColor)
                Spacer()
            }.padding(.horizontal, 40)
       
            
            List {
                ForEach(viewModel.recordedList) { model in
                    
                    VStack {
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Text("\(model.name)")
                                Text("\(model.loadingTime)")
                                
                            }
                            Spacer()
                            Image(systemName: "headphones").resizable().scaledToFill().frame(width: 15, height: 10).foregroundStyle(Color.mainColor)
                            Spacer().frame(width: 10)
                            
                            Image(systemName: "trash").resizable().scaledToFill().frame(width: 15, height: 10).foregroundStyle(Color.red)
                            
                            
                        }

                    }
                  
                }
                
            }.listStyle(.plain).background(Color.clear).padding(.horizontal, 20)
        }.background(Color.mainBackground)
        .onAppear {
                viewModel.onAppear()

        }
    }
}
