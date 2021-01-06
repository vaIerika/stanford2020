//
//  EmojiArtDocumentStore.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 15/08/2020.
//

import SwiftUI
import Combine

// ViewModel that has another ViewModel
class EmojiArtDocumentStore: ObservableObject {
    @Published private var documentNames = [EmojiArtDocument: String]()

    let name: String
    
    func name(for document: EmojiArtDocument) -> String {
        if documentNames[document] == nil {
            documentNames[document] = "Untitled"
        }
        return documentNames[document]!
    }
    
    /// UserDefaults approach to edit document
    func setNameUD(_ name: String, for document: EmojiArtDocument) {
        documentNames[document] = name
    }
    
    /// UserDefaults approach to add document
    func addDocumentUD(named name: String = "Untitled") {
        documentNames[EmojiArtDocument()] = name
    }
    
    /// UserDefaults approach to remove document
    func removeDocumentUD(_ document: EmojiArtDocument) {
        documentNames[document] = nil
    }
    
    /// UserDefaults approach to store data
    init(named name: String = "Emoji Art") {
        self.name = name
        let defaultsKey = "EmojiArtDocumentStore.\(name)"
        documentNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
        autosave = $documentNames.sink { names in
            UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKey)
        }
    }
    
    // MARK: - Lecture 13
    /// DocumentsDirectory approach to edit document
    func setName(_ name: String, for document: EmojiArtDocument) {
        if let url = directory?.appendingPathComponent(name) {
            if !documentNames.values.contains(name) {
                removeDocument(document)
                document.url = url
                documentNames[document] = name
            }
        } else {
            documentNames[document] = name
        }
    }
    var documents: [EmojiArtDocument] {
        documentNames.keys.sorted { documentNames[$0]! < documentNames[$1]! }
    }
    
    /// DocumentsDirectory approach to add document
    func addDocument(named name: String = "Untitled") {
        let uniqueName = name.uniqued(withRespectTo: documentNames.values)
        let document: EmojiArtDocument
        if let url = directory?.appendingPathComponent(uniqueName) {
            document = EmojiArtDocument(url: url)
        } else {
            document = EmojiArtDocument()
        }
        documentNames[document] = uniqueName
    }
    
    /// DocumentsDirectory approach to remove document
    func removeDocument(_ document: EmojiArtDocument) {
        if let name = documentNames[document], let url = directory?.appendingPathComponent(name) {
            try? FileManager.default.removeItem(at: url)
        }
        documentNames[document] = nil
    }
    
    /// Use FileManager instead of UserDefaults for storing data
    private var directory: URL?
    
    init(directory: URL) {
        self.name = directory.lastPathComponent
        self.directory = directory
        do {
            let documents = try FileManager.default.contentsOfDirectory(atPath: directory.path)
            for document in documents {
                let emojiArtDocument = EmojiArtDocument(url: directory.appendingPathComponent(document))
                documentNames[emojiArtDocument] = document
            }
        } catch {
            print("EmojiArtDocumentStore: couldn't create store from directory \(directory): \(error.localizedDescription)")
        }
    }
    
    private var autosave: AnyCancellable?
}

// MARK: - To save in UserDefaults as property value
extension Dictionary where Key == EmojiArtDocument, Value == String {
    var asPropertyList: [String: String] {
        var uuidToName = [String: String]()
        for (key, value) in self {
            uuidToName[key.id.uuidString] = value
        }
        return uuidToName
    }
    
    init(fromPropertyList plist: Any?) {
        self.init()
        let uuidToName = plist as? [String: String] ?? [:]
        for uuid in uuidToName.keys {
            self[EmojiArtDocument(id: UUID(uuidString: uuid))] = uuidToName[uuid]
        }
    }
}
