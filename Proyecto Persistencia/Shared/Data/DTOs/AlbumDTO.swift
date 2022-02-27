

import Foundation

struct AlbumDTO {
    let name: String
    let releaseDate: Date
}

extension AlbumDTO {
    init(domain: Album) {
        self.name = domain.name
        self.releaseDate = domain.releaseDate
    }
}
    
extension AlbumDTO {
    init(cd: CDAlbum) {
        self.name = cd.name!
        self.releaseDate = cd.releaseDate!
    }
}

  
