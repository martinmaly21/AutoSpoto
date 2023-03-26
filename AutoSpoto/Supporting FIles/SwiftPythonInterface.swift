//
//  SwiftPythonInterface.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-01.
//
//For all of these to work you need to change the file path for your machine

import Foundation
import PythonKit

//Call this function to sign the user in and save the cache

class SwiftPythonInterface {
    typealias PythonObjectContinuation = CheckedContinuation<PythonObject, Never>
    typealias PythonVoidContinuation = CheckedContinuation<Void, Never>

    private static var filepath: String {
        let knownFileNameAtDesiredPath = "db.py"
        let knownFileNameArray = knownFileNameAtDesiredPath.split(separator: ".")

        guard let filePath = Bundle.main.url(forResource: String(knownFileNameArray[0]), withExtension: String(knownFileNameArray[1]))?.path() else {
            fatalError("Could not get filePath")
        }
        return filePath.replacingOccurrences(of: knownFileNameAtDesiredPath, with: "")
    }

    static let sys = Python.import("sys")

    //Instance variables
    private static var spotify_api: PythonObject {
        sys.path.append(filepath)
        return Python.import("spotify_apis")
    }

    private static var extract_script: PythonObject {
        sys.path.append(filepath)
        return Python.import("extract_script")
    }

    private static var db: PythonObject {
        sys.path.append(filepath)

        //is it okay to pass in Bundle.main.bundleURL?
        //Not sure if Bundle.main.bundleURL.path() is a constant; Ideally we want it to be
        //so that multiple instances of autospoto.db are not created
        let db_string = "\(filepath)autospoto.db"
        let contactsStringID = "DBD9A071-1507-4104-A7B0-9302B102B4D4"

        return DispatchQueue.main.sync {
            return Python.import("db").db(db_string, contactsStringID)
        }
    }

    private static var spotiy: PythonObject {
        guard let cacheUrl = Bundle.main.urls(forResourcesWithExtension: "cache", subdirectory: nil)?.first else {
            fatalError("Could not get .cache url")
        }

        return DispatchQueue.main.sync {
            return spotify_api.Spotiy(cacheUrl.path)
        }
    }

    static func user_info() async -> PythonObject {
        return await withCheckedContinuation { (continuation: PythonObjectContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                let user_info = spotify_api.Spotiy().user_info()

                DispatchQueue.main.sync {
                    continuation.resume(returning: user_info)
                }
            }
        }
    }

    static func getSongs(
        chat_ids: [Int],
        lastUpdated: Bool = false,
        displayView: Bool = false,
        shouldStripInvalidIDs: Bool = true
    ) async -> PythonObject {
        return await withCheckedContinuation { (continuation: PythonObjectContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                let tracks = extract_script.get_songs(chat_ids, lastUpdated, displayView, shouldStripInvalidIDs, spotiy)
                DispatchQueue.main.sync {
                    continuation.resume(returning: tracks)
                }
            }
        }
    }

    //return playlist iD
    static func createPlaylistAndAddSongs(
        playlistImage: String? = nil,
        playlistName: String,
        playlistDescription: String = "",
        chatIDs: [Int]
    ) async -> String {
        //TODO: pass in playlistPhoto

        let playlistID = await SwiftPythonInterface.createPlaylist(
            name: playlistName,
            description: playlistDescription,
            chat_ids: chatIDs
        )

#warning("Pass in tracks as a parameter of this function instead")
        let tracks = await getSongs(chat_ids: chatIDs)
        let _ = await addSongsToPlaylist(
            playlist_id: playlistID,
            tracks: tracks
        )

        return DispatchQueue.main.sync { playlistID.description }
    }

    static private func createPlaylist(name: String, description: String, chat_ids: [Int]) async -> PythonObject {
        return await withCheckedContinuation { (continuation: PythonObjectContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                let response = spotiy.create_playlist(spotiy.user_info(), name, description, chat_ids, db)
                db.close_connection()

                DispatchQueue.main.sync {
                    continuation.resume(returning: response)
                }
            }
        }
    }

    //maybe playlist_id can be string. Will need to see what the best way to pass objects/variables between functions
    static func addSongsToPlaylist(playlist_id: PythonObject, tracks: PythonObject) async -> PythonObject {
        return await withCheckedContinuation { (continuation: PythonObjectContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                let response = spotiy.update_playlist(playlist_id, tracks, db)
                db.close_connection()

                DispatchQueue.main.sync {
                    continuation.resume(returning: response)
                }
            }
        }
    }

    static func deletePlaylist(playlist_id: String) async {
        await withCheckedContinuation { (continuation: PythonVoidContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                spotiy.current_user_unfollow_playlist(playlist_id, db)
                db.close_connection()
                continuation.resume()
            }
        }
    }

    static func displayPlaylists() async -> PythonObject {
        return await withCheckedContinuation { (continuation: PythonObjectContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                let response = db.display_playlists()
                DispatchQueue.main.sync {
                    continuation.resume(returning: response)
                }
            }
        }
    }

    static func viewGroupChat() async -> PythonObject {
        return await withCheckedContinuation { (continuation: PythonObjectContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                let response = db.retrieve_group_chat()

                DispatchQueue.main.sync {
                    continuation.resume(returning: response)
                }
            }
        }
    }

    static func viewSingleChat() async -> PythonObject {
        return await withCheckedContinuation { (continuation: PythonObjectContinuation) in
            DispatchQueue.global(qos: .userInitiated).sync {
                let response = db.retrieve_single_chat()
                DispatchQueue.main.sync {
                    continuation.resume(returning: response)
                }
            }
        }
    }

    //TODO: Add more queries if needed
}

