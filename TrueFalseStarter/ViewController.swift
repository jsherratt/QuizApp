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
    
    //-----------------------
    //MARK: Variables
    //-----------------------
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var indexArray: [Int] = []
    var btnArray: [UIButton] = []
    
    //Sound
    var currentSoundID: SystemSoundID = 0
    
    //Timer
    var timer = NSTimer()
    var seconds = 15
    var timerIsRunning = false
    
    //-----------------------
    //MARK: Outlets
    //-----------------------
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    //-----------------------
    //MARK: View
    //-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add btns to btn array
        btnArray.append(option1Btn)
        btnArray.append(option2Btn)
        btnArray.append(option3Btn)
        btnArray.append(option4Btn)
        
        //Round btn corners
        roundBtnCorners()
        
        //Set up game
        loadGameSound("StartSound", soundID: &currentSoundID)
        playGameSound(currentSoundID)
        displayQuestion()
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    @IBAction func checkAnswer(sender: UIButton) {
        
        checkAnswerOfQuestion(sender)
    }
    
    @IBAction func playBtn(sender: UIButton) {
        
        //Current title of the play btn
        let title = sender.currentTitle!
        
        //Either play again or move to next question depending on the title of the play btn
        switch title {
            
        case "Play Again":
            
            //Play another round
            playAgain()
            
        case "Next":
            
            //Move on to the next question
            loadNextRoundWithDelay(seconds: 1)
            
        default:
            break
        }
    }

    //-----------------------
    //MARK: Game Functions
    //-----------------------
    func displayQuestion() {
        
        //Random index never repeating the same index twice for a game
        getRandomIndex()
        
        //Check if index array is empty
        if indexArray.isEmpty {
            
            indexArray.append(indexOfSelectedQuestion)
            
        }else {
            
            //Append index of selection question to indexArray
            indexArray.append(indexOfSelectedQuestion)
        }
        
        //Display text of question in the question label
        let selectedQuestion = questionArray[indexArray.last!]
        questionLabel.text = selectedQuestion.question
        
        //Set the title of each btn with the options from the select question
        option1Btn.setTitle(selectedQuestion.option1, forState: .Normal)
        option2Btn.setTitle(selectedQuestion.option2, forState: .Normal)
        option3Btn.setTitle(selectedQuestion.option3, forState: .Normal)
        option4Btn.setTitle(selectedQuestion.option4, forState: .Normal)
        
        //Set answer label with empty string. Disable play btn
        answerLabel.text = ""
        playBtn.enabled = false
        
        //Start the timer
        resetTimer()
        startTimer()
    }
    
    func checkAnswerOfQuestion(button: UIButton) {
        
        // Increment the questions asked counter
        questionsAsked += 1
        
        //Disable btns other than the selected one
        disableBtns(button.tag)
        
        //Enable the next question btn
        playBtn.enabled = true
        
        let selectedQuestion = questionArray[indexArray.last!]
        let correctAnswer = selectedQuestion.answer
        
        //Check the title of the btn and see if it matches the correct answer. If correct, increment correct questions counter and change answer label to display correct.
        //If incorrect change answer label to display the correct answer
        if button.currentTitle == correctAnswer {
            
            timer.invalidate()
            loadGameSound("CorrectSound", soundID: &currentSoundID)
            playGameSound(currentSoundID)
            
            correctQuestions += 1
            
            answerLabel.textColor = UIColor(colorLiteralRed: 82/255, green: 223/255, blue: 107/255, alpha: 1.0)
            answerLabel.text = "Correct!"
            
        }else {
            
            timer.invalidate()
            loadGameSound("IncorrectSound", soundID: &currentSoundID)
            playGameSound(currentSoundID)
            answerLabel.textColor = UIColor(colorLiteralRed: 218/255, green: 75/255, blue: 75/255, alpha: 1.0)
            answerLabel.text = "Sorry the correct answer is\n \(correctAnswer)"
        }
    }
    
    func displayScore() {
        
        //Hide the answer buttons
        option1Btn.hidden = true
        option2Btn.hidden = true
        option3Btn.hidden = true
        option4Btn.hidden = true
        
        //Set play btn title to play again
        playBtn.setTitle("Play Again", forState: .Normal)
        playBtn.enabled = true
        
        //Display text based on the player score
        if correctQuestions == questionsAsked {
            questionLabel.text = "Amazing!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
            
        }else if correctQuestions > 1 && correctQuestions < 4 {
            questionLabel.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
            
        }else {
            questionLabel.text = "Brush up on your knowledge!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        }
    }
    
    func nextRound() {
        
        //Game is over
        if questionsAsked == questionsPerRound {
            
            //Set answer label to empty string, reset timer and display players score
            answerLabel.text = ""
            timer.invalidate()
            resetTimer()
            displayScore()
        
        //Continue game
        } else {
            
            //Display another question and enable btns
            displayQuestion()
            enableBtns()
        }
    }
    
    func playAgain() {
        
        //Show the answer buttons
        option1Btn.hidden = false
        option2Btn.hidden = false
        option3Btn.hidden = false
        option4Btn.hidden = false
        
        //Set play btn title to next
        playBtn.setTitle("Next", forState: .Normal)
        
        //Reset the score and move on to the next round
        questionsAsked = 0
        correctQuestions = 0
        indexArray.removeAll()
        nextRound()
    }
    
    //-----------------------
    //MARK: Timer
    //-----------------------
    func startTimer() {
        
        if timerIsRunning == false {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
            timerIsRunning = true
        }
    }
    
    func countdown() {
        
        let selectedQuestion = questionArray[indexArray.last!]
        let correctAnswer = selectedQuestion.answer
        
        //Decremet seconds by 1
        seconds -= 1
        
        //Update timer label
        timerLabel.text = "Time: \(seconds)"
        
        if seconds == 0 {
            
            //Invalidate the timer
            timer.invalidate()
            
            // Increment the questions asked counter
            questionsAsked += 1
            
            //Disable all btns
            disableAllBtns()
            
            //Enable the next question btn
            playBtn.enabled = true
            
            //Play incorrect sound and show correct answer
            loadGameSound("IncorrectSound", soundID: &currentSoundID)
            playGameSound(currentSoundID)
            answerLabel.textColor = UIColor(colorLiteralRed: 218/255, green: 75/255, blue: 75/255, alpha: 1.0)
            answerLabel.text = "Sorry\nthe correct answer is \(correctAnswer)"
        }
    }
    
    //-----------------------
    //MARK: Helper Functions
    //-----------------------
    func getRandomIndex() -> Int{
        
        var randomNumber = 0
        
        //Repeat random number until the random number is not contained in the index array or is not equal to the previous index
        repeat {
            
            randomNumber = GKRandomSource.sharedRandom().nextIntWithUpperBound(questionArray.count)
            
        }while indexArray.contains(indexOfSelectedQuestion) && randomNumber == indexOfSelectedQuestion
        
        indexOfSelectedQuestion = randomNumber
        
        return randomNumber
    }
    
    func disableBtns(tag: Int) {
        
        for btn in btnArray {
            
            //Enable player selected option btn and disable interaction
            if btn.tag == tag {
                
                btn.enabled = true
                btn.userInteractionEnabled = false
                
            }else {
                
                //Disable other options btns
                btn.enabled = false
            }
        }
    }
    
    func enableBtns() {
        
        for btn in btnArray {
            
            //Enable all btns and user interaction
            btn.enabled = true
            btn.userInteractionEnabled = true
        }
    }
    
    func disableAllBtns() {
        
        for btn in btnArray {
            
            btn.enabled = false
        }
    }
    
    func resetTimer() {
        
        //Reset the seconds and timer label
        seconds = 15
        timerLabel.text = "Time: \(seconds)"
        timerIsRunning = false
    }
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        
        //Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        
        //Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        //Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    func loadGameSound(soundName: String, soundID: UnsafeMutablePointer<SystemSoundID>) {
        
        //Load sound
        let pathToSoundFile = NSBundle.mainBundle().pathForResource(soundName, ofType: "wav")
        let soundPath = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundPath, soundID)
    }
    
    func playGameSound(sound: SystemSoundID) {
        
        //Play sound
        AudioServicesPlaySystemSound(sound)
    }
    
    func roundBtnCorners() {
        
        //Round btn corner using corner radius
        playBtn.layer.cornerRadius = 8
        
        for btn in btnArray {
            
            btn.layer.cornerRadius = 8
        }
    }
    
    //-----------------------
    //MARK: Extra
    //-----------------------
    override func prefersStatusBarHidden() -> Bool {
        
        //Hides the status bar
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

