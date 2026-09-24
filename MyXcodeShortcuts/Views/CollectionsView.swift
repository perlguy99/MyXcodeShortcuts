//
//  CollectionsView.swift
//  MyXcodeShortcuts
//
//  Lists every ShortcutApp collection (the built-in "Xcode Shortcuts" seed plus any imported
//  via ImportCollectionView) and lets the user pick which one is "active" - i.e. which one is
//  displayed on the main list and exported to PDF. Also the entry point for importing a new
//  collection.
//

import SwiftUI
import SwiftData

struct CollectionsView: View {
    @Environment(StatusManager.self) private var statusManager

    @Query(sort: \ShortcutApp.name) private var shortcutApps: [ShortcutApp]
    @State private var isShowingImportSheet = false

    private var activeID: UUID? {
        UUID(uuidString: statusManager.activeShortcutAppID) ?? shortcutApps.first?.id
    }

    var body: some View {
        List {
            if shortcutApps.isEmpty {
                Text("No collections yet!").italic()
            } else {
                ForEach(shortcutApps) { shortcutApp in
                    Button {
                        select(shortcutApp)
                    } label: {
                        row(for: shortcutApp)
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .navigationTitle("Collections")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingImportSheet = true
                } label: {
                    Label("New Collection", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingImportSheet) {
            NavigationStack {
                ImportCollectionView { newApp in
                    select(newApp)
                }
            }
        }
    }

    private func row(for shortcutApp: ShortcutApp) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(shortcutApp.name)
                Text("\(shortcutApp.categories.count) categories")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if shortcutApp.id == activeID {
                Image(systemName: "checkmark")
                    .foregroundStyle(.blue)
            }
        }
    }

    private func select(_ shortcutApp: ShortcutApp) {
        statusManager.activeShortcutAppID = shortcutApp.id.uuidString
        statusManager.pdfTitle = shortcutApp.name
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ShortcutApp.self, Category.self, Shortcut.self, configurations: config)

        let xcodeApp = ShortcutApp(name: "Xcode Shortcuts")
        container.mainContext.insert(xcodeApp)
        let finderApp = ShortcutApp(name: "Finder Shortcuts")
        container.mainContext.insert(finderApp)

        return NavigationStack {
            CollectionsView()
        }
        .modelContainer(container)
        .environment(StatusManager())
    } catch {
        return Text("Failed to create a model container")
    }
}
