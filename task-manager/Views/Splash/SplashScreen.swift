//
//  SplashScreen.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 4/01/25.
//

import SwiftUI
import SwiftData

struct SplashScreen: View {
    @Environment(TaskManagerAppViewModel.self) var appDataProvider
    
    var body: some View {
        @Bindable var splashViewModel = appDataProvider.splashViewModel
        ZStack {
            Color.white
            VStack  {
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding(.top, 80)
                    .padding(.bottom, 100)
                Text("Tasks Manager")
                    .font(.system(size: 33))
                    .bold()
                    .opacity(0.7)
                Text("Kriver Devices")
                Spacer()
                Text("By Crhistian David Vergara Gomez")
                    .padding(.bottom, 20)
                    .opacity(0.5)
            }
        }
        .background(.white)
        .onAppear {
                appDataProvider.splashViewModel.didApper()
        }
    }
}

#Preview {
    @Previewable @State var appDataProvider = TaskManagerAppViewModel(
        splashViewModel: SplashViewModel(
            backend: BackendServiceTest()
        )
    )

    SplashScreen()
        .environment(appDataProvider)
}
