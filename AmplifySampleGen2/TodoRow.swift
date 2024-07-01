//
//  TodoRow.swift
//  AmplifySampleGen2
//
//  Created by Wilfred Bradley Tan on 28/6/24.
//

import SwiftUI

struct TodoRow: View {
    @ObservedObject var vm: TodoViewModel
    @Binding var todo: Todo

    var body: some View {
        Toggle(isOn: $todo.isDone) {
            Text(todo.content ?? "")
        }
        .toggleStyle(SwitchToggleStyle())
//        .onChange(of: todo.isDone) { _, newValue in
        .onChange(of: todo.isDone) { newValue in
            var updatedTodo = todo
            updatedTodo.isDone = newValue
            vm.updateTodo(todo: updatedTodo)
//            vm.listTodos()
        }
    }
}
