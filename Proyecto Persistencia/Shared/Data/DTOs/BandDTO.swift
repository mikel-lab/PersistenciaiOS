import Foundation

struct BandDTO {
    let id: String
    let name: String
    let members: [ArtistDTO]
    var albums: [AlbumDTO]
}

extension BandDTO {
    init(domain: Band) {
        self.id = domain.id
        self.name = domain.name
        self.members = domain.members.map { currentArtist in
            ArtistDTO(domain: currentArtist)
        }
        self.albums = domain.albums.map { currentAlbum in
            AlbumDTO(domain: currentAlbum)
        }
    }
}

extension BandDTO {
    init(cd: CDBand) {
        self.id = cd.id!
        
        self.name = cd.name!
        
        let retrievedArray = cd.members?.allObjects ?? []
        
        let cdArtistArray = retrievedArray
            .compactMap { currentAny in
                currentAny as? CDArtist
            }
        
        self.members = cdArtistArray
            .map { currentCDArtist in
                ArtistDTO(cd: currentCDArtist)
            }
        
        let retrievedAlbums = cd.albums?.allObjects ?? []
        
        let cdAlbumArray = retrievedAlbums
            .compactMap { currentAny in
                currentAny as? CDAlbum
            }
        
        self.albums = cdAlbumArray
            .map { currentCDAlbum in
                AlbumDTO(cd: currentCDAlbum)
            }
    }
}
