import Foundation

protocol ArtistRepositoryProtocol {
    func getAllBands(completionHandler: @escaping ( ([Band]) -> Void ))
    func save(band: Band, completionHandler: @escaping ((Band) -> Void) )
    func removeAllBands(completionHandler: @escaping ( () -> Void ))
    func deleteBands(bandIds: [String], completionHandler: @escaping ( ([String]) -> Void ))
}

struct ArtistRepositoryREAL: ArtistRepositoryProtocol {
    private let localDataSource: ArtistLocalDSProtocol = ArtistLocalDSREAL()
    
    func getAllBands(completionHandler: @escaping ( ([Band]) -> Void )) {
//        localDataSource.getAllBands(completionHandler: { bandsDtos in
//            let domainBands = bandsDtos.map { currentBandDto in
//                Band(dto: currentBandDto)
//            }
//            completionHandler(domainBands)
//        })
        
        localDataSource.getAllBands { bandsDtos in
            let domainBands = bandsDtos.map { currentBandDto in
                Band(dto: currentBandDto)
            }
            completionHandler(domainBands)
        }
    }
    
    func save(band: Band, completionHandler: @escaping ((Band) -> Void) ) {
        localDataSource.save(band: BandDTO(domain: band),
                             completionHandler: { bandDto in
            completionHandler(Band(dto: bandDto))
        })
    }
    
    func removeAllBands(completionHandler: @escaping ( () -> Void )) {
        localDataSource.removeAllBands(completionHandler: completionHandler)
    }
    
    func deleteBands(bandIds: [String], completionHandler: @escaping ( ([String]) -> Void )) {
        localDataSource.deleteBands(bandIds: bandIds, completionHandler: completionHandler)
    }
}

//struct ArtistRepositoryMOCK: ArtistRepositoryProtocol {
//    func getAllBands(completionHandler: @escaping ( ([Band]) -> Void )) {
//        let artists = [
//            Artist(name: "Pedro", birthDate: Date()),
//            Artist(name: "Violeta", birthDate: Date())
//        ]
//
//        let band = Band(name: "Los Bravos", members: artists)
//
//        completionHandler([band])
//    }
//}
