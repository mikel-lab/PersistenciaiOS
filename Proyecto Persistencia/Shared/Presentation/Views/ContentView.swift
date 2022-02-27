import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    
//    let bandNames: [String] = [
//        "Dire Straits",
//        "Incubus",
//        "Queen",
//        "Rolling"
//    ]
    
    let memberNames: [String] = [
        "Freddy Mercury",
        "Mike Jagger",
        "James Hetfield",
        "Mark Knoffler"
    ]
    
    let albumNames: [String] = [
        "What's Going On",
        "Pet Sounds",
        "Once",
        "Highest Hopes"
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.bands) { band in
                    NavigationLink {
                        Text(band.bandMembers());
                        Text(band.bandAlbums())
                    } label: {
                        Text(band.bandName())
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .onAppear {
            viewModel.getSavedArtists()
        }
    }

    private func addItem() {
        withAnimation {
            // let nameIndex = Int.random(in: 0..<4)
            let memberOneIndex = Int.random(in: 0..<4)
            let memberTwoIndex = Int.random(in: 0..<4)
            
            let albumOneIndex = Int.random(in: 0..<4)
            let albumTwoIndex = Int.random(in: 0..<4)

            // let randName = Int.random(in: 0..<100_000)

            let members = [
                Artist(name: memberNames[memberOneIndex] , birthDate: Date()),
                Artist(name: memberNames[memberTwoIndex], birthDate: Date())
            ]
            
            let albums = [
                Album(name: albumNames[albumOneIndex], releaseDate: Date()),
                Album(name: albumNames[albumTwoIndex], releaseDate: Date())
            ]

            let newBand = Band(name: UUID().uuidString, members: members, albums: albums)

            viewModel.saveNewBand(band: newBand)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let bandsToRemove = offsets.map {
                viewModel.bands[$0].id
            }
            
            viewModel.deleteBands(bandIds: bandsToRemove)
        }
    }
}


// formatter: itemFormatter

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
