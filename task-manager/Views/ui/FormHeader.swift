//
//  FormHeader.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 6/01/25.
//

import SwiftUI
struct FormHeader: View {
    var title: String
    var subtitle: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .foregroundColor(.textTitle)
                .font(.system(size: 22))
                .padding(.top, 24)
                .padding(.bottom, 2)
            Text(subtitle)
                .foregroundColor(.textDescriptions)
                .padding(.bottom, 24)
        }
    }
}
