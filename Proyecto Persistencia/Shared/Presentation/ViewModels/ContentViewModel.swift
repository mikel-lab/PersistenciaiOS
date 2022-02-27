import Foundation

protocol Visitable {
    var name: String { get set }
    func printInfo()
}

struct Bicycle: Visitable {
    var name: String = "Bicycle"
    
    func printInfo() {
        print("I am a bicycle")
    }
}

struct Car: Visitable {
    var name: String = "Car"
    
    func printInfo() {
        print("I am a car")
    }
}

struct Visitor<T: Visitable> {
    func printName(element: T) {
        element.printInfo()
    }
}

class ContentViewModel: ObservableObject {
    @Published var bands: [Band] = []
    
    private let getAllBands: GetAllBandsUseCaseProtocol = GetAllBandsUseCaseREAL()
    private let saveBand: SaveBandUseCaseProtocol = SaveBandUseCaseREAL()
    private let deleteAllBands: DeleteAllBandsUseCaseProtocol = DeleteAllBandsUseCaseREAL()
    private let deleteBands: DeleteBandsUseCaseProtocol = DeleteBandsUseCaseREAL()
    
    func getSavedArtists() {
        getAllBands.execute { retrievedBands in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.bands = retrievedBands
            }
        }
    }
    
    func saveNewBand(band: Band) {
        saveBand.execute(band: band, completionHandler: { savedBandData in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.bands.append(savedBandData)
            }
        })
    }
    
    func deleteEveryBand() {
        deleteAllBands.execute(completionHandler: {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.bands = []
            }
        })
    }
    
    func deleteBands(bandIds: [String]) {
        deleteBands.execute(bandIds: bandIds, completionHandler: { removedBandIds in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.bands = self.bands
                    .filter { !removedBandIds.contains($0.id) }
            }
        })
    }
}

///
///                         UseCase1Protocol <-> UseCase1Implementation
///                         UseCase2Protocol <-> UseCase2Implementation
///  View <-> ViewModel <-> UseCase3Protocol <-> UseCase3Implementation
///                         UseCase4Protocol <-> UseCase4Implementation
///                            ...
///                         UseCaseMProtocol <-> UseCaseNImplementation
///
