//
//  ContentView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [Category]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        Text("Category at \(category.name)")
                    } label: {
                        Text(category.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func deleteAll() {
        do {
            try modelContext.delete(Category.self)
        } catch {
            print("Failed to empty the database\n\(error.localizedDescription)")
        }
    }
    
    private func addItem() {
        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let previewHelper = PreviewHelper()
//                
//        ContentView()
//            .modelContainer(previewHelper.container)
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
//    }
//}


#Preview {
    let previewHelper = PreviewHelper()
    
    return ContentView()
        .modelContainer(previewHelper.container)
}
