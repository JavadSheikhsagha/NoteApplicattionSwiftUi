//
//  ContentView.swift
//  DragAndDropp
//
//  Created by enigma 1 on 11/8/22.
//

import SwiftUI
import SwiftyJSON

struct NoteScreen: View {
    
    
    @State var showNoteCreateDialog = false
    @State var showMoveBigNote = false
    @State var index = -1
    @State var savedIndex = -1
    @State var selectedIndex = -1
    @State var deletedList = [Int]()
    @State var noteList = [NoteModel]()
    @State var isEditingNote = false
    
    var body: some View {
        ZStack {
            
            Color(hex: "#373737")
                .ignoresSafeArea()
                .onTapGesture {
                    self.endTextEditing()
                }
                .onAppear{
                    if UserDefaults.standard.string(forKey: "note_list") == nil {
                        for i in 0...100 {
                            noteList.append(NoteModel(id: i, dragAmount: .zero, sizer: .zero, noteText: ""))
                        }
                        do {
                            
                            let json = try JSONEncoder().encode(deletedList)
                            let data = String(data: json, encoding: String.Encoding.utf8)!
                            print(data)
                            
                            UserDefaults.standard.set(data, forKey: "deleted_notes")
                            
                            
                        } catch {
                            print(error)
                        }
                        print("Printed")
                    } else {
                        let json = UserDefaults.standard.string(forKey: "note_list")!
                        let deletedJsons = UserDefaults.standard.string(forKey: "deleted_notes")
//                        print(json)
                        
                        let decoder = JSONDecoder()
                        
                        do {
                            let deletedNotes = try decoder.decode([Int].self, from: deletedJsons!.data(using: .utf8)!)
                            let noteModel = try decoder.decode([NoteModel].self, from: json.data(using: .utf8)!)
                            noteList = noteModel
                            deletedList = deletedNotes
                            
                            index = UserDefaults.standard.integer(forKey: "parent_index")
                            print("index \(index)")
                            index += 1
                            
                            self.selectedIndex = index
                            UserDefaults.standard.set(index, forKey: "parent_index")
                            self.deletedList.append(self.selectedIndex)
                            
                            showNoteCreateDialog.toggle()
                            showNoteCreateDialog.toggle()
                            showMoveBigNote = true
                            do {
                                
                                let json = try JSONEncoder().encode(deletedList)
                                let data = String(data: json, encoding: String.Encoding.utf8)!
                                print(data)
                                
                                UserDefaults.standard.set(data, forKey: "deleted_notes")
                                
                                
                            } catch {
                                print(error)
                            }
                            
                        } catch {
                            print("NOT CONVERTED")
                        }
                    }
                }
                
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Image("imgNoteBackground")
                        .resizable()
                        .frame(width: UIScreen.screenWidth/3.1, height: UIScreen.screenWidth/3.1)
                        .onTapGesture {
                            withAnimation {
                                showNoteCreateDialog.toggle()
                                index+=1
                                self.selectedIndex = index
                            }
                            
                        }
                    
                    Spacer()
                        .frame(width: 24)
                }
            }
            
            ZStack {
                
                VStack {
                    
                    HStack {
                        
                        Spacer()
                            .frame(width: 24)
                        
                        Button {
                            if !isEditingNote {
                                self.endTextEditing()
                                withAnimation {
                                    isEditingNote = false
                                    showNoteCreateDialog.toggle()
                                    index-=1
                                    self.selectedIndex = index
                                }
                            } else {
                                self.endTextEditing()
                                withAnimation {
                                    isEditingNote = false
                                    showNoteCreateDialog.toggle()
                                    self.selectedIndex = index
                                }
                            }
                        } label: {
                            Image("iconClose")
                        }

                        Spacer()
                        
                        if isEditingNote {
                            Button {
                                //delete
                                self.endTextEditing()
                                withAnimation {
                                    isEditingNote = false
                                    self.deletedList.append(self.selectedIndex)
                                    
                                    showNoteCreateDialog.toggle()
                                    showMoveBigNote = true
                                }
                                do {
                                    
                                    let json = try JSONEncoder().encode(deletedList)
                                    let data = String(data: json, encoding: String.Encoding.utf8)!
                                    print(data)
                                    
                                    UserDefaults.standard.set(data, forKey: "deleted_notes")
                                    
                                    
                                } catch {
                                    print(error)
                                }

                            } label: {
                                Image("iconTick")
                            }
                        }

                        
                        Spacer()
                        
                        Button {
                            self.endTextEditing()
                            withAnimation {
                                isEditingNote = false
                                showNoteCreateDialog.toggle()
                                showMoveBigNote = true
                            }
                        } label: {
                            Image("iconTick")
                        }

                        
                        Spacer()
                            .frame(width: 24)
                        
                    }
                    .opacity(showNoteCreateDialog ? 1.0 : 0.0)
                    .offset(y: showNoteCreateDialog ? 0 : -100)
                    .zIndex(10)
                    
                    Spacer()
                    
                    //big note
                    ZStack {
                        
                        ForEach(0..<100) { id in
                            if index >= id {
                                NoteSingleView(
                                    noteList: $noteList,
                                    noteText: noteList[id].noteText,
                                    showMoveBigNote: $showMoveBigNote,
                                    showNoteCreateDialog: $showNoteCreateDialog,
                                    isMovable: false,
                                    dragAmount: noteList[id].dragAmount,
                                    sizer: noteList[id].sizer,
                                    index: id,
                                    parentIndex : $selectedIndex,
                                    onTapEnded: { nmodel in
                                        print(nmodel)
                                        do {
                                            noteList[id] = nmodel
                                            let json = try JSONEncoder().encode(noteList)
                                            let data = String(data: json, encoding: String.Encoding.utf8)!
                                            print(data)
                                            
                                            UserDefaults.standard.set(data, forKey: "note_list")
                                            UserDefaults.standard.set(index, forKey: "parent_index")
                                            
                                            
                                        } catch {
                                            print(error)
                                        }
                                    }, onEditClick: {
                                        isEditingNote = true
                                    })
                                .offset(y: deletedList.contains(id) ? -1000 : 0)
                            }
                        }
//                        ForEach(0..<100) { id in
//                            if index >= id {
//                                ExtractedView(
//                                              showMoveBigNote: $showMoveBigNote,
//                                              showNoteCreateDialog: $showNoteCreateDialog,
//                                              index: id,
//                                              parentIndex : $selectedIndex, onTapEnded:  {
//
//                                              })
//                                .offset(y: deletedList.contains(id) ? -1000 : 0)
//                            }
//                        }
                    }
                    
                    
                    Spacer()
                    
                }
                
            }
            .background {
                Color(hex: "#373737")
                    .opacity(showNoteCreateDialog ? 0.8 : 0.0)
            }
            
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoteScreen()
    }
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

struct NoteSingleView: View {
    
    @Binding var noteList : [NoteModel]
    @State var noteText :String
    @Binding var showMoveBigNote : Bool
    @Binding var showNoteCreateDialog : Bool
    @State var isMovable :Bool
    
    @State var dragAmount : CGSize
    @State var sizer : CGSize
    
    var index : Int
    
    @State var zIndex = 0.0
    
    @Binding var parentIndex : Int
    
    var onTapEnded : (NoteModel) -> Void
    var onEditClick : () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Image("imgNoteBackground")
                .resizable()
                .onTapGesture {
                    self.endTextEditing()
                }
                .onAppear {
//                    zIndex = 5
                    onTapEnded(NoteModel(id: self.index,
                                         dragAmount: self.dragAmount,
                                         sizer: self.sizer,
                                         noteText: noteText))
                    
                    for list in noteList {
                        if list.id == noteList.count {
                            showNoteCreateDialog = true
                        }
                    }
                }
            
            TextField("Enter Note", text: $noteText)
                .font(.system(size: parentIndex == index ? (showNoteCreateDialog ? 18 : 10) : 10))
                .foregroundColor(.black)
                .padding(24)
            
            
            if !isMovable {
                if parentIndex != index && showNoteCreateDialog {
                    Color(hex: "#000000")
                        .opacity(0.5)
                }
            }
            
        }
        .frame(width: sizeOfNote(), height: sizeOfNote())
        .opacity(showMoveBigNote || showNoteCreateDialog ? 1.0 : 0.0)
        .offset(y: showMoveBigNote || showNoteCreateDialog ? 0 : UIScreen.screenHeight)
        .offset(self.dragAmount)
        .gesture(
            DragGesture (coordinateSpace: .global)
                .onChanged({
                    if !(showNoteCreateDialog) {
                        self.dragAmount = CGSize(width: self.sizer.width + $0.translation.width,
                                                    height: self.sizer.height + $0.translation.height)
                        onTapEnded(NoteModel(id: self.index,
                                             dragAmount: self.dragAmount,
                                             sizer: self.sizer,
                                             noteText: noteText))
                    } else {
                        onTapEnded(NoteModel(id: self.index,
                                             dragAmount: self.dragAmount,
                                             sizer: self.sizer,
                                             noteText: noteText))
                    }
                })
                .onEnded({ _ in
                    if showMoveBigNote {
                        self.sizer = self.dragAmount
                        onTapEnded(NoteModel(id: self.index,
                                             dragAmount: self.dragAmount,
                                             sizer: self.sizer,
                                             noteText: noteText))
                        isMovable = false
                        zIndex = 0
                    }
                })
        )
        .onTapGesture {
            print("hello")
            onEditClick()
            withAnimation {
                dragAmount = .zero
                sizer = .zero
                showMoveBigNote = true
                showNoteCreateDialog = true
                parentIndex = index
                zIndex = 5
                
            }
            print("Notttte \(noteText)")
            onTapEnded(NoteModel(id: self.index,
                                 dragAmount: self.dragAmount,
                                 sizer: self.sizer,
                                 noteText: noteText))
        }.zIndex(zIndex)
    }
    
    func sizeOfNote() -> CGFloat {
        if index == parentIndex {
            if showNoteCreateDialog {
                return UIScreen.screenWidth - 82
            } else if showMoveBigNote {
                return UIScreen.screenWidth/4
            } else {
                return UIScreen.screenWidth/4
            }
        } else {
            return UIScreen.screenWidth/4
        }
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}



