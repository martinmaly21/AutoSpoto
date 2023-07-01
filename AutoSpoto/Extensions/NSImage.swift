//
//  NSImage.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-07-01.
//

import AppKit

extension NSImage {
    func jpegData() -> Data {
        let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        return jpegData
    }
}

