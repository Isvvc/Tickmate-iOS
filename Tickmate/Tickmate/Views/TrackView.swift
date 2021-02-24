//
//  TrackView.swift
//  Tickmate
//
//  Created by Isaac Lyons on 2/23/21.
//

import SwiftUI

struct TrackView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @EnvironmentObject private var trackController: TrackController
    
    @ObservedObject var track: Track
    
    @StateObject private var draftTrack = TrackRepresentation()
    @State private var initialized = false
    @State private var editMode = false
    
    var body: some View {
        List {
            TextField("Name", text: $draftTrack.name)
                .disabled(!editMode)
        }
        .navigationTitle("Track details")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(editMode ? "Done" : "Edit") {
                    if editMode {
                        save()
                    }
                    withAnimation {
                        editMode.toggle()
                    }
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                if editMode {
                    Button("Cancel") {
                        cancel()
                        withAnimation {
                            editMode = false
                        }
                    }
                }
            }
        }
        .onAppear {
            if !initialized {
                draftTrack.load(track: track)
                initialized = true
            }
        }
    }
    
    private func save() {
        draftTrack.save(to: track)
    }
    
    private func cancel() {
        draftTrack.load(track: track)
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrackView(track: Track(name: "Test Track", color: 0, context: PersistenceController.preview.container.viewContext))
        }
    }
}
