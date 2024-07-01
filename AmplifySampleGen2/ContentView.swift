//
//  ContentView.swift
//  AmplifySampleGen2
//
//  Created by Wilfred Bradley Tan on 28/6/24.
//

import Amplify
import Authenticator
import SwiftUI

struct ContentView: View {
    // Create an observable object instance.
    @StateObject var vm = TodoViewModel()

    var body: some View {
        Authenticator { state in
            VStack {
                Button("Sign out") {
                    Task {
                        await state.signOut()
                    }
                }

                List {
                    ForEach($vm.todos, id: \.id) { todo in
                        TodoRow(vm: vm, todo: todo)
                    }.onDelete { indexSet in
                        vm.deleteTodos(indexSet: indexSet)
//                        vm.listTodos()
                    }
                }
                .onAppear(perform: {
                    vm.listTodos()
                })

                Button(action: {
                    vm.createTodo()
//                    vm.listTodos()
                }) {
                    HStack {
                        Text("Add a New Todo")
                        Image(systemName: "plus")
                    }
                }
                .accessibilityLabel("New Todo")
            }
        }
    }
}
