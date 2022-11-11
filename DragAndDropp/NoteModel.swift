//
//  NoteModel.swift
//  DragAndDropp
//
//  Created by enigma 1 on 11/9/22.
//

import Foundation


struct NoteModel : Codable {
    
    var id : Int
    var dragAmount : CGSize
    var sizer : CGSize
    var noteText : String
    
    
}
