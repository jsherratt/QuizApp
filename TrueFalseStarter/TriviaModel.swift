//
//  TriviaModel.swift
//  TrueFalseStarter
//
//  Created by Joe Sherratt on 14/06/2016.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import GameKit

struct Trivia {
    
    let triviaQuestions: [[String : String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
    
    func getRandomTrivia() -> [String:String] {
        
        let randomIndex = GKRandomSource.sharedRandom().nextIntWithUpperBound(triviaQuestions.count)
        
        return triviaQuestions[randomIndex]
    }
}