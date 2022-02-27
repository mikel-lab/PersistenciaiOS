import Foundation

protocol GetAllBandsUseCaseProtocol {
    func execute(completionHandler: @escaping ( ([Band]) -> Void ))
}

//struct GetAllBandsUseCaseMOCK: GetAllBandsUseCaseProtocol {
//    func execute(completionHandler: @escaping (([Band]) -> Void)) {
//        let artists = [
//            Artist(name: "Juan", birthDate: Date()),
//            Artist(name: "Maria", birthDate: Date())
//        ]
//        
//        let band = Band(name: "Los Chunguitos", members: artists)
//        
//        completionHandler([band])
//    }
//}

struct GetAllBandsUseCaseREAL: GetAllBandsUseCaseProtocol {
    private let repository: ArtistRepositoryProtocol = ArtistRepositoryREAL()
    
    func execute(completionHandler: @escaping ( ([Band]) -> Void )) {
        repository.getAllBands(completionHandler: completionHandler)
    }
}
