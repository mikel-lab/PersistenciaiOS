import CoreData

protocol PersistenceControllerProtocol {
    func getAllBands(completionHandler: @escaping ( ([BandDTO]) -> Void ) )
    func save(band: BandDTO, completionHandler: @escaping ((BandDTO) -> Void) )
    func removeAllBands(completionHandler: @escaping ( () -> Void ))
    func deleteBands(bandIds: [String], completionHandler: @escaping ( ([String]) -> Void ))
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ArtistsZero")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceController: PersistenceControllerProtocol {
    
    func getAllBands(completionHandler: @escaping (([BandDTO]) -> Void)) {
        container.performBackgroundTask { privateMOC in
            let request = CDBand.fetchRequest()
            request.predicate = nil
            
            var retrievedBands: [CDBand] = []
            
            do {
                retrievedBands = try privateMOC.fetch(request)
            } catch {
                print("F: \(error)")
                completionHandler([])
            }
            
//            let transformedDtosA = retrievedBands.map { currentCDBand -> BandDTO in
//                let members = currentCDBand.members?.allObjects
//                    .compactMap { $0 as? CDArtist }
//                    .compactMap { currentCDArtist in
//                        ArtistDTO(name: currentCDArtist.name!, birthDate: currentCDArtist.birthDate!)
//                    } ?? []
//
//
//                let newBand = BandDTO(name: currentCDBand.name!, members: members)
//
//                return newBand
//            }
            
            let transformedDtosB = retrievedBands.map { currentCDBand in
                BandDTO(cd: currentCDBand)
            }
            
            completionHandler(transformedDtosB)
        }
    }
    
    func save(band: BandDTO, completionHandler: @escaping ((BandDTO) -> Void) ) {
        container.performBackgroundTask { privateMOC in
            let request = CDBand.fetchRequest()
            request.predicate = nil
            
            let newBand = CDBand(context: privateMOC)
            newBand.name = band.name
            newBand.id = band.id
            
            band.members.forEach { currentArtistDto in
                let newArtist = CDArtist(context: privateMOC)
                newArtist.name = currentArtistDto.name
                newArtist.birthDate = currentArtistDto.birthDate
                newArtist.addToBelongs(newBand)
            }
            
            band.albums.forEach { currentAlbumDto in
                let newAlbum = CDAlbum(context: privateMOC)
                newAlbum.name = currentAlbumDto.name
                newAlbum.releaseDate = currentAlbumDto.releaseDate
                newAlbum.addToBelongs(newBand)
            }
            
            do {
                try privateMOC.save()
            } catch {
                print("F: \(error)")
            }
            
            completionHandler(band)
        }
    }
    
    func removeAllBands(completionHandler: @escaping ( () -> Void )) {
        container.performBackgroundTask { privateMOC in
            let request: NSFetchRequest<NSFetchRequestResult> = CDBand.fetchRequest()
            request.predicate = nil
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try privateMOC.execute(deleteRequest)
            } catch {
                print("F: \(error)")
            }
            
            completionHandler()
        }
    }
    
    func deleteBands(bandIds: [String], completionHandler: @escaping ( ([String]) -> Void )) {
        container.performBackgroundTask { privateMOC in
            let request: NSFetchRequest<NSFetchRequestResult> = CDBand.fetchRequest()
            request.predicate = NSPredicate(format: "id IN %@", bandIds)
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            deleteRequest.resultType = .resultTypeCount
            
            do {
                _ = try privateMOC.execute(deleteRequest) as? NSBatchDeleteResult
            } catch {
                print("F: \(error)")
            }
            
            completionHandler(bandIds)
        }
    }
}
