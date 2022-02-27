
import Foundation

struct Album {
    let name: String
    let releaseDate: Date
}

extension Album {
    init(dto: AlbumDTO) {
        self.name = dto.name
        self.releaseDate = dto.releaseDate
    }
}
