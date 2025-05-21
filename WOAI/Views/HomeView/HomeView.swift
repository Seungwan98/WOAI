//
//  HomeView.swift
//  WOAI
//
//  Created by 양승완 on 4/23/25.
//

import SwiftUI
import Combine

#Preview {
    MainView().environmentObject(AppRouter())
}
struct HomeView: View {
    
    @ObservedObject var viewModel: HomeVM
    @EnvironmentObject var router: AppRouter
    
    let itemSpacing: CGFloat = 30
    
    
    var body: some View {
        VStack {
            Text("Home")
                .font(.title3)
                .padding(.horizontal)
            ScrollView {
                VStack(spacing: 10) {
                    
                    Button("+새 회의 시작") {
                        router.push(.recording)
                        
                    }.font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.mainColor)
                        .cornerRadius(8)
                    
                    HomeTopListView(viewModel: viewModel).environmentObject(router)
                    HomeBottomListView(viewModel: viewModel).environmentObject(router)
                    
                    
                }.padding(.horizontal, itemSpacing)
                
            }.background(Color.mainBackground).onAppear {
                viewModel.onAppear()

            }
        }
       
    }
}

