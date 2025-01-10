//
//  ContentView.swift
//  ToDoApp
//
//  Created by Avni Salhotra on 2024-12-11.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var isHighPriority: Bool
}

struct ContentView: View {
    @State private var tasks = [
        Task(title: "Buy groceries", isCompleted: false, isHighPriority: true),
        Task(title: "Walk the dog", isCompleted: false, isHighPriority: false),
        Task(title: "Read a book", isCompleted: true, isHighPriority: true)
    ]
    @State private var newTaskTitle = ""
    @State private var isAddingTask = false
    @State private var editingTask: Task? = nil
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            VStack {
                // Task List
                List {
                    ForEach($tasks) { $task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                                .onTapGesture {
                                    task.isCompleted.toggle()
                                }
                            Text(task.title)
                                .strikethrough(task.isCompleted, color: .gray)
                            Spacer()
                            if task.isHighPriority {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            Button(action: {
                                editTask(task) // Trigger edit mode
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }

                // Edit UI
                if isEditing {
                    VStack {
                        TextField("Edit task title", text: Binding(
                            get: { editingTask?.title ?? "" },
                            set: { editingTask?.title = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        
                        Toggle("High Priority", isOn: Binding(
                            get: { editingTask?.isHighPriority ?? false },
                            set: { editingTask?.isHighPriority = $0 }
                        ))
                        .padding()
                        
                        HStack {
                            Button("Cancel") {
                                cancelEditing()
                            }
                            .padding()

                            Button("Save") {
                                saveEditing()
                            }
                            .padding()
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                }

                // Add Task Input
                if isAddingTask {
                    HStack {
                        TextField("Enter new task", text: $newTaskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button("Add") {
                            addTask()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Today's Tasks")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        isAddingTask.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    func editTask(_ task: Task) {
        editingTask = task
        isEditing = true
    }

    func cancelEditing() {
        editingTask = nil
        isEditing = false
    }

    func saveEditing() {
        guard let updatedTask = editingTask else { return }
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
        cancelEditing()
    }

    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        tasks.append(Task(title: newTaskTitle, isCompleted: false, isHighPriority: false))
        newTaskTitle = ""
        isAddingTask = false
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
