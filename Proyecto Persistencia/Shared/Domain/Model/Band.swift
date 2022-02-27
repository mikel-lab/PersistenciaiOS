import Foundation

struct Band {
    let name: String
    let members: [Artist]
    let albums: [Album]
}

extension Band {
    init(dto: BandDTO) {
        self.name = dto.name
        
        var membersList: [Artist] = []
        
        for member in dto.members {
            let newArtist = Artist(dto: member)
            membersList.append(newArtist)
        }
        
        self.members = membersList
        
        var albumsList: [Album] = []
        
        for album in dto.albums {
            let newAlbum = Album(dto: album)
            albumsList.append(newAlbum)
        }
        
        self.albums = albumsList
    }
}

extension Band: Identifiable {
    var id: String {
        name
    }
}

extension Band {
    func bandName() -> String {
        return name
    }
    
    func bandMembers() -> String {
        let memberNames = members.map { currentMember in
            currentMember.name
        }
        
        let formattedMemberNames = memberNames.joined(separator: ", ")
        
        return formattedMemberNames
    }
    
    func bandAlbums() -> String {
        let albumNames = albums.map { currentAlbum in
            currentAlbum.name
        }
        
        let formattedAlbumNames = albumNames.joined(separator: ", ")
        
        return formattedAlbumNames
    }
}

///
/// let artists = [
///     Artist(name: "Juan", birthDate = Date()),
///     Artist(name: "Maria", birthDate = Date())
/// ]
///
/// let band = Band(name: "Los Chunguitos", members: artists)
///
///
/// bandMembers()
///
///     -> let memberNames: [String] = ["Juan", "Maria"]
///
///     -> let formattedMemberNames: String = "Juan, Maria"
///
