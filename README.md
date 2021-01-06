# Course Stanford CS193p 2020 - Developing Apps for iOS
> 
> Solutions for [Stanford CS193p 2020](https://cs193p.sites.stanford.edu) course assignments. Use different commits to browse repo files of certain Lectures and Assignments. 
>
> Projects are written in **Xcode Version 12.0 beta 2** and **12.3** later.
>

<br/>


## Completion status

Type                                | Quantity  | Completion
:---                                |  :---:  |   :---:
Lectures                            | 13 / 14 |  93%
**Assignment I**                    |  6 / 6  | **100%**
Extra credits                       |  1 / 1  | *+100%*
**Assignment II**                   |  9 / 9  | **100%**
Extra credits                       |  1 / 2  |  *+50%*
**Assignment III**                  | 19 / 19 | **100%**
Extra credits                       |  4 / 11 |  *+36%*
**Assignment IV**                   | 10 / 10 | **100%**
Extra credits                       |  1 /  1 | *+100%*
**Assignment V**                    |  2 /  2 | **100%**
**Assignment VI**                   | 14 / 14 | **100%**
Extra credits                       |  2 /  2 | *+100%*



<br/>

## Emoji Art 

> 
> Project is made with **Xcode Version 12.0 beta 2**. 
> 

<br/>

#### Assignment IV

Task 1. The code accordingly to the Lecture 8.

 
Task 2 - 5. Support the selection of the emojis.

> 1. Use a Set to collect selected emojis. 
> 2. Write a `toggleMatching()` method as an extension to the Set that allows adding (selection) and removing (deselection) emojis from the Set. Call this method `.onTapGesture` for each emoji.
> 3. Customize an appearance of selected emojis with the ternany operator (? :). 
> 4. Add `.exclusively(before:)` to allow two variants of tap gesture: double tap for zoom and one tap to deselect all emojis.

```swift
// 1 
@State private var selectedEmojis: Set<EmojiArt.Emoji> = []

// 2 Set+Identifiable.swift
extension Set where Element: Identifiable {
    mutating func toggleMatching(_ element: Element) {
        if contains(matching: element) {
           remove(element)
        } else {
           insert(element)
        }
    }
}

// View
ZStack {
    Color.white
    ForEach(document.emojis) { emoji in
         Text(emoji.text)

            // 2
            .onTapGesture {
                selectedEmojis.toggleMatching(emoji)
            }
            // 3
            .background(
                Circle()
                    .stroke(Color.red)
                    .opacity(isSelected(emoji) ? 1 : 0)
            )
    }
}
// 4
 .gesture(tapBgToDeselectOrZoom(in: geometry.size))
 
--- 

private func tapBgToDeselectOrZoom(in size: CGSize) -> some Gesture {
    TapGesture(count: 1)
        .exclusively(before: doubleTapToZoom(in: size))
        .onEnded { _ in
            withAnimation(.linear(duration: 0.2)) {
                selectedEmojis.removeAll()
             }
        }
}

// 3
private func isSelected(_ emoji: EmojiArt.Emoji) -> Bool {
    selectedEmojis.contains(matching: emoji)
}

```

<br/>

Task 6 - 7. Dragging emojis  

> Create `@State` and `@GestureState` variables and a function for the Drag Gesture. Add a `.gesture()` modifier with this gesture to an emoji. 
>
> A background image will be dragged if there is no selection of emojis.
>

```swift 
    @State private var steadyStateDragEmojisOffset: CGSize = .zero
    @GestureState private var gestureDragEmojisOffset: CGSize = .zero
    
    private func dragEmojisGesture(for emoji: EmojiArt.Emoji) -> some Gesture {
        
        DragGesture()
            .updating($gestureDragEmojisOffset) { latestDragGestureValue, gestureDragEmojisOffset, transition in
                gestureDragEmojisOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                let distanceDragged = finalDragGestureValue.translation / zoomScale
                
                for emoji in selectedEmojis {
                   withAnimation {
                        document.moveEmoji(emoji, by: distanceDragged)
                    }
                }
            }
    }
    
    ---
    
    ForEach(document.emojis) { emoji in //...
            .gesture(dragEmojisGesture(for: emoji))        
    }
    
```

<br/>

Task 8 - 9. Pinching emojis 

> 1. Improve a `zoomScale` variable in the way that if there is a selection of emojis during pinching a size of the bg image will stay the same.
> 
> 2. Add a method to calculate zoomScale for each emoji. 
> 
> 3. Modify `zoomGesture()` to change a scale of the selected emojis only, or a scale of the whole picture if there is no selection.

```swift 
    // 1
    private var zoomScale: CGFloat {
        steadyStateZoomScale * (selectedEmojis.isEmpty ? gestureZoomScale : 1)
    }
    
    // 2
    private func zoomScale(for emoji: EmojiArt.Emoji) -> CGFloat {
        if isSelected(emoji) {
            return steadyStateZoomScale * gestureZoomScale
        } else {
            return zoomScale
        }
    }
    
    .font(animatableWithSize: emoji.fontSize * zoomScale(for: emoji))
    
    // 3
    private func zoomGesture() -> some Gesture {    //...

                .onEnded { finalGestureScale in
                if selectedEmojis.isEmpty {
                    steadyStateZoomScale *= finalGestureScale
                } else {
                    selectedEmojis.forEach { emoji in
                        document.scaleEmoji(emoji, by: finalGestureScale)
                    }
                }
            }
    }
```

<br/>

Task 10. Deleting emojis 

> 1. Add to the ViewModel `removeEmoji()` function. 
>
> 2. Implement this function in the View.
>
> Variant A. Deleting with the Long Tap Gesture.
> 
> Variant B. Selected emojis can be deleted with the tap on the Bin 🗑.

```swift

    // 1 ViewModel 
    func removeEmoji(_ emoji: EmojiArt.Emoji) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis.remove(at: index)
        }
    }
    
    
    // 2. Variant A
    private func longPressToRemove(_ emoji: EmojiArt.Emoji) -> some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onEnded { _ in
                document.removeEmoji(emoji)
            }
    }
    
    ---
    
    ForEach(document.emojis) { emoji in //...
           .gesture(longPressToRemove(emoji))    
    }
    
    // 2. Variant B
    Button(action: {
        selectedEmojis.forEach { emoji in
            document.removeEmoji(emoji)
            selectedEmojis.remove(emoji)
        }
    }) { 
        Image(systemName: "trash.fill")
            .font(.headline)
            .foregroundColor(selectedEmojis.isEmpty ? .gray : .blue)
    }
```

<br/>

Extra credit 1. Dragging unselected emojis

> Add condition in the `.onEnded { }` modifier of the `dragEmojisGesture(for:)` function. If an emoji isn't a part of the selection it will be moved anyway by the dragged distance.
> 

```swift 
    private func dragEmojisGesture(for emoji: EmojiArt.Emoji) -> some Gesture {
        
        // Extra credit
        let isEmojiPartOfSelection = isSelected(emoji)
        
        return DragGesture()
            .updating($gestureDragEmojisOffset) { latestDragGestureValue, gestureDragEmojisOffset, transition in
                gestureDragEmojisOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                let distanceDragged = finalDragGestureValue.translation / zoomScale
                
                // Extra credit `if-else`
                if isEmojiPartOfSelection {
                
                    for emoji in selectedEmojis {
                        withAnimation {
                            document.moveEmoji(emoji, by: distanceDragged)
                        }
                    }
                } else {
                    document.moveEmoji(emoji, by: distanceDragged)
                }
            }
    }
```
<br/>

---
 
<br/>

## Set Game 

<br/>

#### Assignment III

Task 1 - 19. Make a game of Set 

> Since the 1st task sounds like "Implement a game of solo Set" and other 18 tasks also cannot be called unexacting, I'm not providing here detailed answers for each task. However you can find some comments and print output in the [Set Game](./SetGame) project I've made.
>
> I used a new feature of SwiftUI `LazyVGrid` instead of the Grid provided by Professor.
>
> This project is made with **Xcode Version 12.0 beta 2**. 
>

<div>
<img src="SetGame/Screenshots/GameView.png" width="300px"/>
<img src= "SetGame/Screenshots/GameViewGif.gif" width = "600px"/>
</div>

<br/>

---

<br/>

## Memorize Game

<br/>

#### Assignment I

Task 1. The code from the 1st & 2nd Lectures

Task 2. Unpredictable order

> Swift provides an easy solution to randomize Array. In the ViewModel I added a *shuffled()* method to randomize emojis to play with and in the Model a *shuffle()* method to initialize a new game with shuffled cards
>
> `let emojis = theme.emojis.shuffled()`
> 
> `cards.shuffle()`
>

<br/>

Task 3. Width and height in a certain proportion

> Applied to the ZStack of the View, because of the better solution it was commented later 
>
> `.aspectRatio(2/3, contentMode: .fit)`
>


<br/>

Task 4. Randomize number of pairs of cards

> In the 2nd Assignment it is changed for an another solution
>
> `let numberOfPairs = Int.random(in: 2...5)`

<br/>

Task 5. Adjust size of the font

> After lecture #4 a Grid is applied to the project 
>
> `.font(EmojiMemoryGame.numberOfPairs > 4 ? .callout : .largeTitle)`
>

<br/>

Extra Credit 1. 

> Solution for that was displayed earlier 
> 
> `let emojis = theme.emojis.shuffled()`
>

<br/>

---

<br/>

#### Assignment II

Task 1. The code from the 3rd & 4th Lectures.

Task 2 - 5. Architect the concept of a 'theme' into the game

> 'static' properties belong to the type; a new theme can be added as an another 'static' property or by using `append(newTheme)` to the variable 'theme'. I prefer 'static' because I can see all themes in one place 

```swift
struct Theme {
    var name: String
    var emojis: [String]
    var cardsNumber: Int?
    var color: Color
    
    static let cats = Theme(name: "Cats", emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"], color: .yellow)
    ... // other themes in the project //
    
    static var themes = [cats, techno, zodiac, animals, vegetables, flowers]
}
```
> Initialize a theme property in ViewModel 
>

```swift

class EmojiMemoryGame: ObservableObject {
    ...
    var theme: Theme

        init() {
            let theme = Theme.themes.randomElement()!
            self.theme = theme
            model = EmojiMemoryGame.createMemoryGame(with: theme)
            }
            ...
}
```

<br/>

Task 6. Add 'New Game' button
> Add a Reset button in ViewModel and then use it functionality in the View 


```swift
// ViewModel
    func resetGame() {
        theme = Theme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }

// View 
    Button(action: {
        self.viewModel.resetGame()
     }) {
        Text("New Game")
     }
```

<br/>

Task 7. Display a theme in UI

> `Text(viewModel.theme.name)`
>

<br/>

Task 8. Giving and penalizing points

> The logic should be implemented in the Model. To the 'Card' struct we need to add a new boolean property 'alreadyBeenSeen' that will help us to penalize when cards haven't been matched during the 1st try.
>
> In the `choose(card:)` method replace the 'indexOfTheOneAndOnlyFaceUpCard' index which was created in the 4th lecture with the array 'faceupCardIndeces'. The new element will contain up to 2 indeces and flip cards face down when they don't match.
>
> Additional comments in the project.
>

```swift
mutating func choose(card: Card) {

    let faceupCardIndeces = cards.indices.filter { cards[$0].isFaceUp }
    
    \\\ third tap; when two cards are opened, update there Seen status and flip them; restart
    
    if faceupCardIndeces.count > 1 {
        for index in cards.indices {
            if cards[index].isFaceUp {
                cards[index].alreadyBeenSeen = true
                cards[index].isFaceUp = false
            }
        }
    }
    
    /// when the 1st and then the 2nd card has chosen which hasn't been matched yet
    if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
        
        /// 1st tap: choose card - > flip the 1st card;
        /// 2nd tap: choose another card (start over func) -> flip the second card but in faceUpIndeces will be only one index still
        cards[chosenIndex].isFaceUp = true
        if faceupCardIndeces.count == 1 {
            
            if cards[faceupCardIndeces[0]].content == cards[chosenIndex].content {
                cards[chosenIndex].isMatched = true
                cards[faceupCardIndeces[0]].isMatched = true
                
                /// add two points for match even if cards had been seen
                score += 2
            } else {
                
                /// penalizing 1 point for each card that has been seen but hasn't been matched yet
                if cards[chosenIndex].alreadyBeenSeen {
                    score -= 1
                }
                if cards[faceupCardIndeces[0]].alreadyBeenSeen {
                    score -= 1
                }
            }
        }
    }
}
```

<br/>

Task 9. Display the score in UI

> Add score as a variable in ViewModel and then display in the VIew 
>
> `var score: Int { model.score }` // ViewModel
>
> `Text("\(viewModel.score)")` // View
>

<br/>

Extra Credit 1. Support a gradient as the 'color' for a theme

> In the View (because it's a visual improvement) I added a computed property to make a gradient from the theme's color. 'CardView' requires now two values: `card` and `themeColor: LinearGradient`, so that color can be used to design appereance of cards
>

```swift
    var themeColor: LinearGradient {
        return LinearGradient(gradient: 
            Gradient(colors: [viewModel.theme.color, 
            viewModel.theme.color.opacity(0.4)]), 
            startPoint: .topLeading, 
            endPoint: .bottomTrailing)
    }
```

<br/>

---

<br/>

#### Assignment V

Task 1. Pre-defined number of cards for each theme 

> Remove an option of a random number of pairs. In the `ViewModel` inside the `createMemoryGame(with:)` method replace use a theme property.
>

```swift
 let numberOfPairs = theme.cardsNumber
```


> In `GameTheme.swift` file make Non-optional number of cards. Add a value of this property to each theme.
>

```swift
var cardsNumber: Int

static let cats = Theme(name: "Cats", emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"], cardsNumber: 8, color: .red)
```


<br/>

Task 2. JSON representation of the theme 

> 1. Add extensions: UIColor+RGBA and Data+utf8.
>
> 2. Change a type of the `color` property of the `Theme` structure to `UIColor.RGB`.
>
> 3. A theme should be created as the following:
```swift 
static let animals = Theme(name: "Animals", emojis: ["🐶", "🐨", "🦁", "🐼", "🦊", "🐻", "🐰"], cardsNumber: 7, color: .init(red: 200/255, green: 81/255, blue: 81/255, alpha: 1))
```
> 
> 4. Add a `var json: Data?` to `Theme` structure. Use it in the `ViewModel` to print the data as json.
```swift 
 print("json = \(theme.json?.utf8 ?? "nil")")
```
> 5. Make sure a theme color returns a Color view in the `View`: 
```swift 
var themeColor { return Color(viewModel.theme.color) }
```
>

<br/>

---

<br/>

#### Assignment VI

Task 1-2. Show a list of saved themes when the app launches

> 1. Create a ViewModel for themes that loads saved themes if they were edited by user or default version. Add a method to save data.
>
```swift 
class Themes: ObservableObject {
    @Published private(set) var savedThemes: [Theme]
    static let saveKey = "SavedThemesForEmojiMemoryGame"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Theme].self, from: data) {
                self.savedThemes = decoded
                return
            }
        }
        self.savedThemes = [Theme.cats, Theme.techno, Theme.zodiac, Theme.animals, Theme.vegetables, Theme.flowers]
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(savedThemes) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
}
```
>
> 2. Add a `id` property to the Theme structure, and conform it to the Identifiable protocol
>
```swift
struct Theme: Codable, Identifiable {
    var id = UUID()
    ...
}
```
>
> 3. Create a View that presents a List of themes
>
```swift
struct ThemesListView: View {
    @ObservedObject var viewModelThemes: Themes
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModelThemes.savedThemes) { theme in
                    Text(theme.name)
                }
            }
        }.navigationBarTitle("Memorize")
    }
}
```
>
> 4. Change a `contentView` constant to contain the created ThemesListView with the data from Themes ViewModel
>
```swift
    // class SceneDelegate, `scene()` method
    let themes = Themes()
    let contentView = ThemesListView(viewModelThemes: themes)
```
>

<br/>

Task 3. Display information for each theme
>
> Display a color with `Color(theme.color)`. A method that returns String can be used to show a descriptive text (emojis and number of played pairs): `Text(showListOfEmojis(theme: theme))`. The method:
>
```swift
private func showListOfEmojis(theme: Theme) -> String {
    let pairsStr = theme.cardsNumber == theme.emojis.count ? "" : "\(theme.cardsNumber) pairs from "
    return pairsStr + String(theme.emojis.joined())    
}
```
>

<br/>

Task 4-6. Rows of the themes list navigate to start the game
>
> 1. Wrape each row of the List view with the NavigationLink:
```swift 
NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))) {
...
}
```
>
> 2. Update initialization of the `EmojiMemoryGame` ViewModel, it should accept the chosen theme as a parameter to create a game.
>
```swift
init(theme: Theme) {
    self.theme = theme
    model = EmojiMemoryGame.createMemoryGame(with: theme)
}
```
>

<br/>

Task 7. Adding a new theme
>
> 1. Add a method to the created ViewModel that adds a new theme into the array. Which can used also for editing theme afterwards.
>
```swift
    // class Themes - ViewModel
    func addTheme(_ theme: Theme) {
        if let index = savedThemes.firstIndex(matching: theme) {
            savedThemes[index] = theme
        } else {
            savedThemes.append(theme)
        }
        save()
    }
```
>
> 2. Create a new view `ThemeEditorView` to show the Adding/Editing options for the theme, that view takes to parameters  `theme: Binding<Theme?>, updateChanges: @escaping (Theme) -> Void)`. The method will allow to save changes and update the model. 
>
> 3. Show `ThemeEditorView` through `sheet()`. 
>
```swift
.sheet(isPresented: $showingUpdateThemeView) {
    ThemeEditorView(theme: $selectedTheme) { updatedTheme in
        viewModelThemes.addTheme(updatedTheme)
            editMode = .inactive
    }
}
```
>
> If the "Add" button is pressed, the property `selectedTheme: Theme?` is equal `nil`.
>
```swift 
    private func addNewTheme() {
        selectedTheme = nil
        showingUpdateThemeView = true
    }
```
>
<br/>

Task 8-9. Edit mode. Deleting themes

> 1. Add to the ViewModel method to remove the chosen theme
```swift
func removeTheme(_ theme: Theme) {
    if let index = savedThemes.firstIndex(matching: theme) {
        savedThemes.remove(at: index)
        save()
    }
}
```
>
> 2. Surround a "theme row" with `ForEach` view, so `.onDelete` modifier can catch `indexSet` for the row that needed to be removed. Add `onTapGesture` modifier to allow edit a specific theme.
> 
```swift
List {
    ForEach(viewModelThemes.savedThemes) { theme in
        NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))) {
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color(theme.color))
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .opacity(editMode.isEditing ? 1 : 0)
                        .onTapGesture {
                            selectedTheme = theme
                            showingUpdateThemeView = true
                        }
                }.frame(width: 25, height: 25)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(theme.name)
                        .font(.headline)
                    Text(showListOfEmojis(theme: theme))
                        .font(.caption)
                        .lineLimit(1)
                }
            }.padding(5)
        }
    }
    .onDelete { indexSet in
        indexSet.map { viewModelThemes.savedThemes[$0] }.forEach { theme in
            viewModelThemes.removeTheme(theme)
        }
    }
}

```
>

<br/>

Task 10-13. Editing theme with `ThemeEditorView`

> 1. Edit the name of the theme `TextField("Name theme", text: $themeToAdd.name)`
> 
> 2. Add emoji to the theme 
>
```swift
TextField("Emoji", text: $emojiToAdd)

Button("Add") {
    for character in emojiToAdd {
        if !themeToAdd.emojis.contains(String(character)) {
            themeToAdd.emojis.append(String(character))
        }
    }
    emojiToAdd = ""
    updateCardsNumber()
}.disabled(emojiToAdd.isEmpty)

```
>
> 3. Update a number of cards in the theme
>
```swift
if themeToAdd.emojis.count > 1 {
    Section(header: Text("Number of cards to play")) {
        Stepper(value: $themeToAdd.cardsNumber, in: 2...themeToAdd.emojis.count) {
            Text("\(themeToAdd.cardsNumber) pairs")
        }
    }
}
```
>
```swift 
...
 private func updateCardsNumber() {
        themeToAdd.cardsNumber = themeToAdd.emojis.count
    }
```
>
> 4. Closure in the View allows to update the ViewModel 
>

<br/>

Extra credit 1. Support choosing a theme's color 

> 1. Add property colors for the `ThemeEditorView` 
`private var colors: [UIColor] = [.red, .blue, .green, .purple, .yellow, .magenta, .orange, .cyan, .brown]`
>
> 2. Assign a chosen color for the theme on the Tap gesture 
>
```swift
Section(header: Text("Theme color")) {
    Grid(colors, id: \.self) { color in
        ZStack {
            Circle().fill(Color(color)).frame(width: 35, height: 35)
            Image(systemName: "checkmark.circle")
                .foregroundColor(.white)
                .opacity(UIColor(themeToAdd.color) == color ? 1 : 0)
        }.onTapGesture {
            themeToAdd.color = UIColor.getRGB(color)
        }
    }.frame(minHeight: 20, idealHeight: 80, maxHeight: 100)
}
```
>

<br/>

Extra credit 2. Keep track of the removed emojis

> Add 2nd view for removed emojis, able tap gesture action
```swift 
Section(header: Text("Emojis to play"), footer: Text("Tap emoji to exclude")) {
    Grid(themeToAdd.emojis, id: \.self) { emoji in
        Text(emoji)
            .frame(width: 30, height: 30)
            .onTapGesture {
                withAnimation {
                    removeEmoji(emoji)
                }
            }
    }.frame(minHeight: 20, idealHeight: 100, maxHeight: 300)
}
if !themeToAdd.removedEmojis.isEmpty {
    Section(header: Text("Removed emojis"), footer: Text("Tap emoji to include in the game")) {
        Grid(themeToAdd.removedEmojis, id: \.self) { emoji in
            Text(emoji)
                .frame(width: 30, height: 30)
                .onTapGesture {
                    withAnimation {
                        returnEmoji(emoji)
                    }
                }
        }.frame(minHeight: 20, idealHeight: 100, maxHeight: 300)
    }
}
```
>
> Supporting methods
>
```swift
    private func removeEmoji(_ emoji: String) {
        if let index = themeToAdd.emojis.firstIndex(of: emoji) {
            themeToAdd.removedEmojis.append(themeToAdd.emojis.remove(at: index))
            updateCardsNumber()
        }
    }
    ...
    private func returnEmoji(_ emoji: String) {
        if let index = themeToAdd.removedEmojis.firstIndex(of: emoji) {
            themeToAdd.emojis.append(themeToAdd.removedEmojis.remove(at: index))
            updateCardsNumber()
        }
    }
```
>

<br>

>
> ❗️ Update in the `ThemeEditorView` after the 11th Lecture: Initialization of State property with a wrapper value of the `Binding<Theme>`
>
```swift
    init(theme: Binding<Theme?>, updateChanges: @escaping (Theme) -> Void) {
        _theme = theme
        self.updateChanges = updateChanges
        _themeToAdd = State(wrappedValue: theme.wrappedValue ?? Theme(name: "Unknown", emojis: [], removedEmojis: [], cardsNumber: 0, color: UIColor.getRGB(.red)))
    }
```


<br/>


## New & Useful Ideas for me from the Course
1. If Model can be made with different types, add Generics to it.
2. ViewModel establishes a specific type of data.
3. Static function can be used to create a specific ViewModel from Model; that function can be used to reset the game.
4. Use 'Drawing Constraints' to avoid setting values directly in a code.
5. Make variable of the model 'private' in ViewModel and send to the View an another copy of it. Mark 'private' all properties and functions that shouldn't be accessible and 'private(set)' - that shouldn't be changeable nowhere else.
6. Custom ViewModifiers, Shapes can help make code much reusable. 
7. Use *.updating($gestureStateVar)* to change the value of @GestureState for Non-discrete gestures.
8. Modifier `.exclusively(before: doubleTapToZoom(in: size))` allows to combine gestures.
9. A value of the *State var* can be assign with initialized data. 1st variant to use `.onAppear`, which is called after initialization. Or 2nd variant is to assign _value with the *wrappedValue*:
```swift
    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(wrappedValue: document.defaultPalette)
    }
```
10. **Environment Object** is usually used for sharing ViewModel data between screens 
11. `UIPasteboard.general.url` has a URL? data that a user copied somewhere, and it can be used as a value for properties, can be pasted. 
12. Reodering views can be achieved with `.zIndex(-1)` for background. 
13. `State` property can be initialized with `Binding.wrapperValue`: 
```swift
_themeToAdd = State(wrappedValue: theme.wrappedValue
```
14. Tags of the `Picker` has to have the same type with `selection` value; `nil` value can be presented as `.tag(String?.none)`. `Picker` can have additional items (and tags) that are not included in `selection` array.

<br/>



---
<br/>

## Note
Presented code is my attempt to solve required tasks of the Stanford course. I'd appreciate any features and improvement you have to share. Feel free to [reach me out](mailto:Valerika.Hello@gmail.com)  😊

<br/>

## Credits 
A playing card back image used in the Set Game is made by [macrovector](https://www.freepik.com/free-vector/undefined). These guys have nice solutions for Stanford assignments: [Antonio J Rossi](https://github.com/antoniojrossi), [Ruban](https://github.com/sk-ruban).
