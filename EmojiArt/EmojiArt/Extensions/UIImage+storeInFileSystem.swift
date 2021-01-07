//
//  UIImage+storeInFileSystem.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 07/01/2021.
//

import UIKit

extension UIImage {
    func storeInFileSystem(name: String = "\(Date().timeIntervalSince1970)") -> URL? {
        var url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        url = url?.appendingPathComponent(name)
        if url != nil {
            do {
                try self.jpegData(compressionQuality: 1.0)?.write(to: url!)
            } catch {
                url = nil
            }
        }
        return url 
    }
}
