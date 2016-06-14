//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var shuffledArray: [Trivia] = []
    var btnArray: [UIButton] = []
    
    var gameSound: SystemSoundID = 0
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    @IBOutlet weak var nextQuestionBtn: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnArray.append(option1Btn)
        btnArray.append(option2Btn)
        btnArray.append(option3Btn)
        btnArray.append(option4Btn)
        
        //loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        
        shuffledArray =  GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(questionArray) as! [Trivia]
        
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(shuffledArray.count)
        
        let selectedQuestion = shuffledArray[indexOfSelectedQuestion]
        questionField.text = selectedQuestion.question
        
        option1Btn.setTitle(selectedQuestion.option1, forState: .Normal)
        option2Btn.setTitle(selectedQuestion.option2, forState: .Normal)
        option3Btn.setTitle(selectedQuestion.option3, forState: .Normal)
        option4Btn.setTitle(selectedQuestion.option4, forState: .Normal)
        
        answerLabel.text = ""
        playAgainButton.hidden = true
        nextQuestionBtn.hidden = false
        nextQuestionBtn.enabled = false
    }
    
    func displayScore() {
        // Hide the answer buttons
        option1Btn.hidden = true
        option2Btn.hidden = true
        option3Btn.hidden = true
        option4Btn.hidden = true
        
        // Display play again button
        playAgainButton.hidden = false
        nextQuestionBtn.hidden = true
        
        if correctQuestions == questionsAsked {
            
            questionField.text = "Amazing!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
            
        }else if correctQuestions > 1 && correctQuestions < 4 {
            
            questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
            
        }else {
            
            questionField.text = "Brush up on your knowledge!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        }
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        
        // Increment the questions asked counter
        questionsAsked += 1
        
        disableBtns(sender.tag)
        nextQuestionBtn.enabled = true
        
        let selectedQuestion = shuffledArray[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestion.answer
        
        if sender.currentTitle == correctAnswer {
            
            correctQuestions += 1
            
            sender.enabled = true
            sender.titleLabel?.textColor = UIColor.whiteColor()
            
            answerLabel.textColor = UIColor(colorLiteralRed: 82/255, green: 223/255, blue: 107/255, alpha: 1.0)
            answerLabel.text = "Correct!"
            
        }else {
            
            answerLabel.textColor = UIColor(colorLiteralRed: 218/255, green: 75/255, blue: 75/255, alpha: 1.0)
            answerLabel.text = "Sorry\nthe correct answer is \(correctAnswer)"
        }
}
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            
            // Game is over
            answerLabel.text = ""
            displayScore()
            
        } else {
            
            // Continue game
            displayQuestion()
            enableBtns()
        }
    }
    @IBAction func nextQuestion(sender: UIButton) {
        
        loadNextRoundWithDelay(seconds: 1)
    }
    
    @IBAction func playAgain() {
        
        // Show the answer buttons
        option1Btn.hidden = false
        option2Btn.hidden = false
        option3Btn.hidden = false
        option4Btn.hidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func disableBtns(tag: Int) {
        
        for btn in btnArray {
            
            if btn.tag == tag {
                
                btn.enabled = true
                btn.userInteractionEnabled = false
                
            }else {
                
                btn.enabled = false
            }
        }
    }
    
    func enableBtns() {
        
        for btn in btnArray {
            
            btn.enabled = true
            btn.userInteractionEnabled = true
        }
    }
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

