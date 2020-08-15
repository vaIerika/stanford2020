//
//  EditableText.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 15/08/2020.
//

import SwiftUI

struct EditableText: View {
    var text = ""
    var isEditing: Bool
    var onChanged: (String) -> Void
    
    init(_ text: String, isEditing: Bool, onChanged: @escaping (String) -> Void) {
        self.text = text
        self.isEditing = isEditing
        self.onChanged = onChanged
    }
    
    @State private var editableText = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField(text, text: $editableText, onEditingChanged: { began in
                callOnChangedIfChanged()
            })
            .opacity(isEditing ? 1 : 0)
            .disabled(!isEditing)
            
            if !isEditing {
                Text(text)
                    .opacity(isEditing ? 0 : 1)
                    .onAppear {
                        
                        // report any time it moves from editable to non-editable
                        callOnChangedIfChanged()
                    }
            }
        }
        .onAppear { editableText = text }
    }
    
    func callOnChangedIfChanged() {
        if editableText != text {
            onChanged(editableText)
        }
    }
}

struct EditableText_Previews: PreviewProvider {
    static var previews: some View {
        EditableText("Text", isEditing: true, onChanged: { began in
            
        })
    }
}
