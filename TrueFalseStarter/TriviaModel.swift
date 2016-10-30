//
//  TriviaModel.swift
//  TrueFalseStarter
//
//  Created by Joe Sherratt on 14/06/2016.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import GameKit

class Trivia {
    
    //-----------------------
    //MARK: Variables
    //-----------------------
    var question: String
    var option1:String
    var option2:String
    var option3:String
    var option4:String
    var answer:String
    
    //-----------------------
    //MARK: Init
    //-----------------------
    init(question: String, option1: String, option2: String, option3: String, option4: String, answer: String) {
        
        self.question = question
        self.option1 = option1
        self.option2 = option2
        self.option3 = option3
        self.option4 = option4
        self.answer = answer
    }
}
