//
//  HomeView.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI
import Combine

//#Preview {
//    MainView()
//}



struct RecordingView: View {
    
    @EnvironmentObject var router: AppRouter
    @StateObject var viewModel = RecordingVM()
    
    var body: some View {
        VStack {
            Text(viewModel.labelText)

    }.onAppear() {
        viewModel.onAppear()
    }
    
    }
    
}
