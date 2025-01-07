//
//  TasksScreen.swift
//  task-manager
//
//  Created by Crhistian David Vergara Gomez on 3/01/25.
//

import SwiftUI

struct TasksScreen: View {
    @Environment(TaskManagerAppViewModel.self) var appDataService

    
    var body: some View {
        @Bindable var taskViewModel = appDataService.taskViewModel
        VStack {
            EmptyMessage(show: taskViewModel.showEmptyMessage)
            List($taskViewModel.tasks) { task in
                TaskCell(task: task)
                    .listRowSeparator(.hidden)
                    .background(.backgroundDark)
                    .listRowInsets(
                        .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                    )
                    .swipeActions(allowsFullSwipe: true) {
                        Button { taskViewModel.deleteTask(task.id)}
                        label: {
                            VStack{
                                Text("Eliminar")
                                Image(systemName: "trash")
                                    .symbolEffect(.scale)
                            }
                            .cornerRadius(16)
                            .background(Color.red)
                        }
                    }
                    .onTapGesture {
                        taskViewModel
                            .goToEditTask(task.wrappedValue)
                    }
            }
            .background(.backgroundDark)
            .listRowSpacing(-0)
            .listStyle(.plain)
            .searchable(
                text: $taskViewModel.searchText,
                prompt: "Buscar"
            )
            .onSubmit(of: .search) {
                taskViewModel.updateSearchText(with: nil)
            }
            .refreshable() {
                print("Cargando mas datos")
            }

            if taskViewModel.hasMoreTasks {
                HStack {
                    Spacer()
                    Button(action: {
                        taskViewModel.loadMoreData()
                    }) {
                        if taskViewModel.isLoading {
                            ProgressView(value: 0.5)
                                .tint(Color.white)
                                .progressViewStyle(.circular)
                                .controlSize(.large)
                                .padding(.top, 12)
                            Text("Cargando...")
                                .foregroundColor(.white)
                        } else {
                            Text("Cargar más")
                                .foregroundColor(.white)
                                .padding(.top, 12)
                        }
                    }
                    Spacer()
                }
            }
        }
        .background(.backgroundDark)
        .onAppear { taskViewModel.loadTasks(taskViewModel.filters)}
        .navigationTitle(Text("Tareas"))
        .toolbarVisibility(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.backgroundDark, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    taskViewModel.goToAddTask()
                } label: {
                    HStack{
                        Image(systemName: "plus")
                            .symbolEffect(.scale)
                    }
                }
            }
            ToolbarItemGroup(placement: .cancellationAction) {
                Button {
                    appDataService.logout()
                } label: {
                    HStack{
                        Image(systemName: "square.and.arrow.up")
                            .symbolEffect(.scale)
                    }
                }
            }
            ToolbarItemGroup(placement: .secondaryAction) {
                Menu {
                    Button {
                        taskViewModel.filterByState(nil)
                    } label: {
                        HStack{
                            Text("Todos")
                            Spacer()
                            Image(systemName: "checklist")
                                .symbolEffect(.scale)
                                .symbolRenderingMode(.palette)
                                .foregroundColor(taskViewModel.colorfilterAllTasks)
                        }
                    }
                    Button {
                        taskViewModel.filterByState(true)
                    } label: {
                        HStack{
                            Text("Completados")
                            Spacer()
                            Image(systemName: "checklist.checked")
                                .symbolEffect(.scale)
                                .symbolRenderingMode(.palette)
                                .foregroundColor(taskViewModel.colorfilterCompletedTasks)
                        }
                    }
                    Button {
                        taskViewModel.filterByState(false)
                    } label: {
                        HStack{
                            Text("Pendientes")
                            Spacer()
                            Image(systemName: "checklist.unchecked")
                                .symbolEffect(.scale)
                                .symbolRenderingMode(.palette)
                                .foregroundColor(taskViewModel.colorfilterIncompletedTasks)
                        }
                    }
                } label: {
                    Text("Filtrar por")
                }
                
                Button {
                    taskViewModel.goToProfile()
                } label: {
                    HStack{
                        Text("Perfil")
                        Spacer()
                        Image(systemName: "person")
                    }
                }
                
                Button {
                    taskViewModel.goToAbout()
                } label: {
                    HStack{
                        Text("Acerca")
                        Spacer()
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var appViewModel = TaskManagerAppViewModel(
        taskViewModel: TaskViewModel(
            backend: BackendServiceTest(token: "loggedIn")
        )
    )
    NavigationStack
    {
        TasksScreen()
            .environment(appViewModel)
    }
}



struct EmptyMessage: View {
    var show: Bool
    var body: some View {
        if show {
            VStack{
                Image(systemName: "folder.badge.gearshape")
                    .frame(width:  80, height: 80)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 3)
                    }
                Text("No hay tareas")
                    .padding()
                    .foregroundColor(.white)
            }
            .padding(.all, 16)
            .background(.backgroundDark)
            .cornerRadius(16)
        }
    }
}
