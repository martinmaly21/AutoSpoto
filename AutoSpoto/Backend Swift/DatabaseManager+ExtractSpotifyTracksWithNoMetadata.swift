//
//  DatabaseManager+ExtractSpotifyTracksWithNoMetadata.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-08.
//

import Foundation

//MARK: - this extension is for extracting the Spotify Track id's from a given chat
extension DatabaseManager {
    func fetchSpotifyTracksWithNoMetadata(
        for chatIDs: [Int]
    ) async -> [Track] {
        //TODO: extract given chatIDs
        var tracks: [Track] = []
        
        //1-15
        tracks.append(Track(spotifyID: "3CeKc83EsgRPItgvlDHo5B", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5Mjxb8iTjPUZoE4wBEuujw", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7nnWIPM5hwE3DaUBkvOIpy", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "4PlHZ314edq6tCAmhc8Sf3", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "2c8Vk0rL4ixyEik2lZEA9h", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7nyFOUagrzizHBKKPtzy2H", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "1CcYbJv84YXy8WQLQilvb0", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5dSBi7CBxh1rdudhZUF5jt", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "3XMo9CI5tJn56VWo0INrYM", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7z5VgAx4xc6AoCpN57F31y", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7DoVVf6UuL0zvv9sxYRva5", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "60OOnXwxebQ4nysceVgQZX", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "2rslQV48gNv3r9pPrQFPW1", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "3qoFdhS8hFq2m0v5pzAf0H", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "6XDFFeinPXgy3auyC7huoC", timeStamp: "BLAH"))
        
        //16-30
        tracks.append(Track(spotifyID: "7mjSHL2Eb0kAwiKbvNNyD9", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "3fplqOwaH03uP6BlVwtveQ", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "4gS0C89Jlx8Zx4853NYRLY", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "2Nq06gpBMrjYnBLpi0cNYy", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5mCLCA1bnQHPU4EZBtZgqo", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "0SyrQWyIGUNZIPDNn8WK3L", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5coMYxwIbNMxtMIRJ1tWYm", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "6Olho973oeYV1gbYa5aP1Z", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "2gWA2eWOso3Ncj5navWlmz", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5QwfGyYKuVOcRRmarKO02G", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5iG1A5kU5KJd9pF8mmxWLB", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5UXlDFlgxnEKSgCnMQX9XM", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "1zQGt19BTDwXJ80veJqh9n", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "0MikGbA8bt5Fo07NVW6HQ7", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "6K1dM8q3M3e0EOFxiZgNpO", timeStamp: "BLAH"))
        
        //31-45
        tracks.append(Track(spotifyID: "3JWKhPP6muh6tjR8b7PDOb", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "0DRvClQbN9znQ295sx76VC", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "0anVOZUEsiQEOl00Zw7lyq", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "1J3C8kdqUckBrTtgttm0AA", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "3TxKtkCNR1yQARsvHxvNnP", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "20I8RduZC2PWMWTDCZuuAN", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "3QzptVakmUpFkP0KDqQU3m", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7aGicnnu8dLFoUobkhkXYh", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5hrJlfHjAhQXbVPVBwDFvY", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "5mLllF9AIePVdhExTiNyyr", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7sajvCnoz4QJrWRqXdjhAs", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "46W7yykdgEehLT3PXYP3NX", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "0yfNXxlyXdmP0ue1iJijx1", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "6nb57vP4sMYeeU2mfzVgr6", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "2ItpB7U6vrd8QMmL2GIgnW", timeStamp: "BLAH"))
        
        tracks.append(Track(spotifyID: "7HOqSh3apbrDHwEizL8H71", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "2sLVs5iX0osogh4jcsAJkv", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "0KU8W0lHfsNlH7lfV1dz29", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7uAQcuHWoTbSanKYmQrN89", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "7HNpXPaTcX5CoNBjTAEWBr", timeStamp: "BLAH"))
        tracks.append(Track(spotifyID: "0VH9sKPtKbkxllpqyYmJ7E", timeStamp: "BLAH"))

        //remove duplicates
        tracks = tracks.unique
        
        return tracks
    }
}


