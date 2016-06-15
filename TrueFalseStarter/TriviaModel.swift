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

//-----------------------
//MARK: Questions
//-----------------------
let question1 = Trivia(question: "What is the closest planet to the Sun?", option1: "Venus", option2: "Mercury", option3: "Earth", option4: "Mars", answer: "Mercury")

let question2 = Trivia(question: "What planet is known as the red planet?", option1: "Mars", option2: "Jupiter", option3: "Neptune", option4: "Saturn", answer: "Mars")

let question3 = Trivia(question: "Earth is located in which galaxy?", option1: "Andromeda", option2: "Tadpole", option3: "Pinwheel", option4: "The Milky Way", answer: "The Milky Way")

let question4 = Trivia(question: "What is the name of the first satellite sent into space?", option1: "Quazer", option2: "Sputnik", option3: "Atlas", option4: "Polaris", answer: "Sputnik")

let question5 = Trivia(question: "Who was the first person to walk on the moon?", option1: "Neil Armstrong", option2: "Michael Collins", option3: "Buzz Aldrin", option4: "Pete Conrad", answer: "Neil Armstrong")

let question6 = Trivia(question: "What is the name of the force holding us to the Earth?", option1: "Interstellar", option2: "Fusion", option3: "Ironis", option4: "Gravity", answer: "Gravity")

let question7 = Trivia(question: "Ganymede is a moon of which planet?", option1: "Neptune", option2: "Saturn", option3: "Jupiter", option4: "Venus", answer: "Jupiter")

let question8 = Trivia(question: "What is the name of NASA’s most famous space telescope?", option1: "Hubble", option2: "Spitzer", option3: "James Webb", option4: "Giant Magellan", answer: "Hubble")

let question9 = Trivia(question: "What planet is famous for the beautiful rings that surround it?", option1: "Pluto", option2: "Venus", option3: "Saturn", option4: "Uranus", answer: "Saturn")

let question10 = Trivia(question: "What is the sun?", option1: "Planet", option2: "Star", option3: "Atom", option4: "Supernova", answer: "Star")

var questionArray = [question1,question2,question3,question4,question5,question6,question7,question8,question9,question10]