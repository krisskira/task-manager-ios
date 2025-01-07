//
//  TaskCell.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 8/01/25.
//
import SwiftUI

struct TaskCell: View {
    @Binding var task: TaskModel

    var date: [String: String] {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            let month = formatter.string(from: task.createdAt).uppercased()
            formatter.dateFormat = "dd"
            let day = formatter.string(from: task.createdAt)
            return ["month" : month, "day" : day]
        }
    }
    var dividerColor: Color {
        task.completed ? .green.opacity(0.8) : .orange
    }
    
    var colorGlow: GradientStyle {
        task.completed ? .lime : .sunset
    }
    
    var status: String {
        task.completed ? "Completado" : "Pendiente"
    }
   
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(date["month"]!)
                        .fontDesign(.rounded)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                    Text(date["day"]!)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                }
                    .padding(8)
                    .foregroundColor(.textTitle)
//                
                VStack(alignment: .leading){
                    Text(task.title)
                        .font(.system(size: 18))
                        .foregroundColor(.textTitle)
                        .fontWeight(.semibold)
                    Text(task.description)
                        .padding(.bottom, 16)
                        .foregroundColor(.textDescriptions)
                        .fontWeight(.light)

                    HStack {
                        Text(status)
                            .font(.system(size: 12, weight: .light))
                            .padding(.all, 4)
                            .background(.white)
                            .foregroundColor(dividerColor)
                            .cornerRadius(4)
                            .multicolorGlow(colorGlow)
                            .frame(width: 100, height: 40)
                        Spacer()
                        Image(systemName: "pencil.and.scribble")
                    }.padding(.leading, -12)
                }
                .padding(EdgeInsets(
                    top: 8, leading: 0, bottom: 8, trailing: 8
                ))
                .overlay {
                    HStack {
                        Divider()
                            .frame(width: 1)
                            .background(dividerColor)
                            .padding(.horizontal, -9)
                        Spacer()
                    }
                }
            }
            .background()
            .cornerRadius(12)
            .padding(.all, 8)
            .multicolorGlow(colorGlow)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var taskPending = TaskDataTest.first!
    @Previewable @State var taskCompleted = TaskDataTest.first(where: { task in
        task.completed
    })!
    TaskCell(task: $taskPending)
    TaskCell(task: $taskCompleted)
}

