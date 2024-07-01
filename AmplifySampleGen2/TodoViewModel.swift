//
//  TodoViewModel.swift
//  AmplifySampleGen2
//
//  Created by Wilfred Bradley Tan on 28/6/24.
//

import Amplify
import SwiftUI

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []

    init() {
        createSubscription()
    }

    func createTodo() {
        let creationTime = Temporal.DateTime.now()
        let todo = Todo(
            content: "Random Todo \(creationTime)",
            isDone: false,
            createdAt: creationTime,
            updatedAt: creationTime
        )

        Task {
            do {
                let result = try await Amplify.API.mutate(request: .create(todo))
                switch result {
                case .success(let todo):
                    print("Successfully created todo: \(todo)")
                    if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                        todos[index] = todo
                    } else {
                        todos.append(todo)
                    }
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to create todo: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }

    func listTodos() {
        Task {
            do {
                let result = try await Amplify.API.query(request: .list(Todo.self))
                switch result {
                case .success(let todos):
                    print("Successfully retrieved list of todos: \(todos)")
                    self.todos = todos.elements
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to query list of todos: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }

    func deleteTodos(indexSet: IndexSet) {
        for index in indexSet {
            let todo = todos[index]
            Task {
                do {
                    let result = try await Amplify.API.mutate(request: .delete(todo))
                    switch result {
                    case .success(let todo):
                        print("Successfully deleted todo: \(todo)")
                    case .failure(let error):
                        print("Got failed result with \(error.errorDescription)")
                    }
                } catch let error as APIError {
                    print("Failed to deleted todo: ", error)
                } catch {
                    print("Unexpected error: \(error)")
                }
            }

            todos.remove(atOffsets: indexSet)
        }
    }

    func updateTodo(todo: Todo) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .update(todo))
                switch result {
                case .success(let todo):
                    print("Successfully updated todo: \(todo)")
                    if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                        todos[index] = todo
                    } else {
                        todos.append(todo)
                    }

                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }

            } catch let error as APIError {
                print("Failed to updated todo: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }

//    func createTodo() {
//        let creationTime = Temporal.DateTime.now()
//        let todo = Todo(
//            content: "Random Todo \(creationTime)",
//            isDone: false,
//            createdAt: creationTime,
//            updatedAt: creationTime
//        )
//        updateTodo(todo: todo)
//    }
//
//    func listTodos() {
//        Task {
//            do {
//                // AWS DataStore is required for conflict resolution
//                todos = try await Amplify.DataStore.query(Todo.self)
//                print("Fetched \(todos.count) todos")
//            } catch let error as DataStoreError { // Additional error handling for datastore
//                print("Error retrieving posts \(error)")
//            } catch {
//                print("Unexpected error \(error)")
//            }
//        }
//    }
//
//    func deleteTodos(indexSet: IndexSet) {
//        Task {
//            for index in indexSet {
//                let todo = todos[index]
//                do {
//                    try await Amplify.DataStore.delete(todo)
//                } catch {
//                    print("Delete Todo failed with error: \(error)")
//                }
//            }
//
//            todos.remove(atOffsets: indexSet)
//        }
//    }
//
//    func updateTodo(todo: Todo) {
//        Task {
//            do {
//                try await Amplify.DataStore.save(todo)
//                if let index = todos.firstIndex(where: { $0.id == todo.id }) {
//                    todos[index] = todo
//                } else {
//                    todos.append(todo)
//                }
//
//            } catch let error as DataStoreError { // Additional error handling for datastore
//                print("Error saving post \(error)")
//            } catch {
//                print("Unexpected error \(error)")
//            }
//        }
//    }

    var onCreateSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Todo>>?
    var onUpdateSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Todo>>?
    var onDeleteSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Todo>>?

    func createSubscription() {
        onCreateSubscription = Amplify.API.subscribe(request: .subscription(of: Todo.self, type: .onCreate))

        Task {
            do {
                guard let subscription = onCreateSubscription else {
                    return
                }

                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let createdTodo):
                            print("Successfully got todo from subscription: \(createdTodo)")

                            if !todos.contains(where: { $0.id == createdTodo.id }) {
                                todos.append(createdTodo)
                            }

                        case .failure(let error):
                            print("Got failed result with \(error.errorDescription)")
                        }
                    }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }

        Task {
            do {
                guard let subscription = onUpdateSubscription else {
                    return
                }

                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let updatedTodo):
                            print("Successfully got updated note from subscription: \(updatedTodo)")
                            // TODO: Do something with this
//                            await fetchTodos()
                            if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                                todos[index] = updatedTodo
                            }

                        case .failure(let error):
                            print("Got failed result with \(error.errorDescription)")
                        }
                    }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }

        Task {
            do {
                guard let subscription = onDeleteSubscription else {
                    return
                }

                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let deletedTodo):
                            print("Successfully got deleted note from subscription: \(deletedTodo)")
                            // TODO: Do something with this
                            todos.removeAll(where: { $0.id == deletedTodo.id })

                        case .failure(let error):
                            print("Got failed result with \(error.errorDescription)")
                        }
                    }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }
    }
}
