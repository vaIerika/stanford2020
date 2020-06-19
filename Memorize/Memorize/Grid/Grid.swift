//
//  Grid.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 05/06/2020.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {    /// care a little bit about type; generics + protocols
    var items: [Item]
    var viewForItem: (Item) -> ItemView

    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {  /// make function as a reference type
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            self.body(for: item, in: layout)
        }
    }
    
    func body(for item: Item, in layout: GridLayout) -> some View  {
        let index = items.firstIndex(matching: item)!
      //  return Group {
      //      if index != nil {
                return viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
      //      }
      //  }
        // if it will crash App I would want that
    }
    
//    func index(of item: Item) -> Int {
//        for index in 0..<items.count {
//            if items[index].id == item.id {
//                return index
//            }
//        }
//        return 0 // TODO: bogus
//    }
}

