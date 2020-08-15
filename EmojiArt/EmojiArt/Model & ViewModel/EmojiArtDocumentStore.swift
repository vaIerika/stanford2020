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
    
    func setName(_ name: String, for document: EmojiArtDocument) {
        documentNames[document] = name
    }
    
    var documents: [EmojiArtDocument] {
        documentNames.keys.sorted { documentNames[$0]! < documentNames[$1]! }
    }
    
    func addDocument(named name: String = "Untitled") {
        documentNames[EmojiArtDocument()] = name 
    }
    
    func removeDocument(_ document: EmojiArtDocument) {
        documentNames[document] = nil
    }
    
    private var autosave: AnyCancellable?
    
    init(named name: String = "Emoji Art") {
        self.name = name
        let defaultsKey = "EmojiArtDocumentStore.\(name)"
        documentNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
        autosave = $documentNames.sink { names in
            UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKey)
        }
    }
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
