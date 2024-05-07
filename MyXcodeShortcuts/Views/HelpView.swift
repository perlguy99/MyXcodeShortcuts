//
//  HelpView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/21/24.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        NavigationSplitView {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                Text("Help")
                    .font(.headline)
            } else {
                helpView
            }
        } detail: {
            if UIDevice.current.userInterfaceIdiom == .pad {
                helpView
            }
        }
        .navigationBarTitle("Quick Help", displayMode: .inline)
    }
    
    private var helpView: some View {
        List {
            Section(header: Text("First Time Running")) {
                Text("Upon first load, the app is pre-populated with default data from Apple's documentation\n")
                + Text("It isn't 100% complete, but it is a good start").font(.footnote).italic()
                
                Text("Users can then add or customize the shortcuts")
            }

            Section(header: Text("Main View")) {
                Text("★ Long-Press on an existing Shortcut to edit it")
                Text("★ Tap on a Shortcuts checkbox to toggle its filter attribute between none, favorite, and hidden")
            }
            
            Section {
                Text("Tap to select the sort order\n")
                + Text("It is still very basic sorting").font(.footnote).italic()
            } header: {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Sorting")
                }
            }

            Section {
                
                Text("Tap to toggle between\n") +
                Text("(none, favorite, hidden)").font(.footnote).italic()
                
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.blue)
                    Text("(none)").bold() +
                    Text(" - No filter applied\n")
                    + Text("Not").font(.footnote).italic().underline().bold()
                    + Text(" showing hidden").font(.footnote).italic()
                }
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.yellow)
                    Text("(favorites)").bold() +
                    Text(" - Only showing Favorites")
                }
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.red)
                    Text("(hidden)").bold() +
                    Text(" - Showing hidden")
                }
            } header: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filtering")
                }
            }
            
            Section {
                Text("Tap to add a new Shortcut")
            } header: {
                HStack {
                    Image(systemName: "plus")
                    Text("Adding")
                }
            }

            Section {
                Text("Tap to go to the Settings")
                Text("In Settings you can\n") +
                Text("\t☞ Customize the PDF title\n") +
                Text("\t☞ Choose to show symbols or not\n") +
                Text("\t☞ Set a custom key separator\n") +
                Text("\t☞ Preview/Print cheatsheet")
            } header: {
                HStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }

            
            Section {
                Text("I just wanted to make sure I gave credit to Ray Wenderlich at https://kodeco.com for the tutoriall that inspired this app.")
            } header: {
                HStack {
                    Image(systemName: "hands.and.sparkles.fill")
                    Text("Thank You!")
                }
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

#Preview {
    HelpView()
        .preferredColorScheme(.dark)
}
