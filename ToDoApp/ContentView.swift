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
    @State private var newTaskTitle = "" // Step 1: Input for new task
    @State private var isAddingTask = false // Step 2: Tracks if input field is visible
    
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
                                    .foregroundColor(.red) // Red for high-priority tasks
                            }
                        }
                        .onLongPressGesture {
                            task.isHighPriority.toggle() // Toggle priority on long press
                        }
                    }
                        .onDelete(perform: deleteTask) // Step 3: Enable swipe-to-delete
                    }
                    
                    // Add Task Input Field
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
                    // Add Button in Navigation Bar
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            isAddingTask.toggle() // Toggle input visibility
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        
        // Step 4: Add Task Function
        func addTask() {
            guard !newTaskTitle.isEmpty else { return }
            tasks.append(Task(title: newTaskTitle, isCompleted: false, isHighPriority: false))
            newTaskTitle = "" // Clear the input field
            isAddingTask = false // Hide the input field
        }
        
        // Step 5: Delete Task Function
        func deleteTask(at offsets: IndexSet) {
            tasks.remove(atOffsets: offsets)
        }
    }
    
    #Preview {
        ContentView()
    }
