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
    
    @State private var navigationPath = NavigationPath()
    
    @Query private var categories: [Category]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        Text("Category at \(category.name)")
                    } label: {
                        Text(category.name)
                    }
                }
                .onDelete(perform: deleteCategories)
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
                ToolbarItem {
                    Button(action: deleteAll) {
                        Label("Delete All", systemImage: "exclamationmark.warninglight.fill")
                    }
                }

            }
        }
    }

    private func deleteAll() {
        print("\n------------------------------")
        print("DELETING ALL DATA")
        print("------------------------------\n")

        modelContext.container.deleteAllData()
//        do {
//            try
//        }
        
//        PreviewHelper().deleteAll()
        
//        do {
//            try modelContext.container.main
////            try modelContext.d
//            try modelContext.delete(Category.self)
//        } catch {
//            print("Failed to empty the database\n\(error.localizedDescription)")
//        }
    }
    
    private func addItem() {
        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
        }
    }

    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
            }
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
