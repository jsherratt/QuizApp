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
    var timer = Timer()
    var seconds = 15
    var timerIsRunning = false
    
    let array = Questions()
    
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
        loadGameSound(soundName: "StartSound", soundID: &currentSoundID)
        playGameSound(sound: currentSoundID)
        displayQuestion()
    }
    
    //-----------------------
    //MARK: Button Actions
    //-----------------------
    @IBAction func checkAnswer(sender: UIButton) {
        
        checkAnswerOfQuestion(button: sender)
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
        let selectedQuestion = array.questionArray[indexArray.last!]
        questionLabel.text = selectedQuestion.question
        
        //Set the title of each btn with the options from the select question
        option1Btn.setTitle(selectedQuestion.option1, for: .normal)
        option2Btn.setTitle(selectedQuestion.option2, for: .normal)
        option3Btn.setTitle(selectedQuestion.option3, for: .normal)
        option4Btn.setTitle(selectedQuestion.option4, for: .normal)
        
        //Set answer label with empty string. Disable play btn
        answerLabel.text = ""
        playBtn.isEnabled = false
        
        //Start the timer
        resetTimer()
        startTimer()
    }
    
    func checkAnswerOfQuestion(button: UIButton) {
        
        // Increment the questions asked counter
        questionsAsked += 1
        
        //Disable btns other than the selected one
        disableBtns(tag: button.tag)
        
        //Enable the next question btn
        playBtn.isEnabled = true
        
        let selectedQuestion = array.questionArray[indexArray.last!]
        let correctAnswer = selectedQuestion.answer
        
        //Check the title of the btn and see if it matches the correct answer. If correct, increment correct questions counter and change answer label to display correct.
        //If incorrect change answer label to display the correct answer
        if button.currentTitle == correctAnswer {
            
            timer.invalidate()
            loadGameSound(soundName: "CorrectSound", soundID: &currentSoundID)
            playGameSound(sound: currentSoundID)
            
            correctQuestions += 1
            
            answerLabel.textColor = UIColor(colorLiteralRed: 82/255, green: 223/255, blue: 107/255, alpha: 1.0)
            answerLabel.text = "Correct!"
            
        }else {
            
            timer.invalidate()
            loadGameSound(soundName: "IncorrectSound", soundID: &currentSoundID)
            playGameSound(sound: currentSoundID)
            answerLabel.textColor = UIColor(colorLiteralRed: 218/255, green: 75/255, blue: 75/255, alpha: 1.0)
            answerLabel.text = "Sorry the correct answer is\n \(correctAnswer)"
        }
    }
    
    func displayScore() {
        
        //Hide the answer buttons
        option1Btn.isHidden = true
        option2Btn.isHidden = true
        option3Btn.isHidden = true
        option4Btn.isHidden = true
        
        //Set play btn title to play again
        playBtn.setTitle("Play Again", for: .normal)
        playBtn.isEnabled = true
        
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
        option1Btn.isHidden = false
        option2Btn.isHidden = false
        option3Btn.isHidden = false
        option4Btn.isHidden = false
        
        //Set play btn title to next
        playBtn.setTitle("Next", for: .normal)
        
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
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
            timerIsRunning = true
        }
    }
    
    func countdown() {
        
        let selectedQuestion = array.questionArray[indexArray.last!]
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
            playBtn.isEnabled = true
            
            //Play incorrect sound and show correct answer
            loadGameSound(soundName: "IncorrectSound", soundID: &currentSoundID)
            playGameSound(sound: currentSoundID)
            answerLabel.textColor = UIColor(colorLiteralRed: 218/255, green: 75/255, blue: 75/255, alpha: 1.0)
            answerLabel.text = "Sorry\nthe correct answer is \(correctAnswer)"
        }
    }
    
    //-----------------------
    //MARK: Helper Functions
    //-----------------------
    func getRandomIndex() {
        
        var randomNumber = 0
        
        //Repeat random number until the random number is not contained in the index array or is not equal to the previous index
        repeat {
            
            randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: array.questionArray.count)
            
        }while indexArray.contains(indexOfSelectedQuestion) && randomNumber == indexOfSelectedQuestion
        
        indexOfSelectedQuestion = randomNumber
        
    }
    
    func disableBtns(tag: Int) {
        
        for btn in btnArray {
            
            //Enable player selected option btn and disable interaction
            if btn.tag == tag {
                
                btn.isEnabled = true
                btn.isUserInteractionEnabled = false
                
            }else {
                
                //Disable other options btns
                btn.isEnabled = false
            }
        }
    }
    
    func enableBtns() {
        
        for btn in btnArray {
            
            //Enable all btns and user interaction
            btn.isEnabled = true
            btn.isUserInteractionEnabled = true
        }
    }
    
    func disableAllBtns() {
        
        for btn in btnArray {
            
            btn.isEnabled = false
        }
    }
    
    func resetTimer() {
        
        //Reset the seconds and timer label
        seconds = 15
        timerLabel.text = "Time: \(seconds)"
        timerIsRunning = false
    }
    
    func loadNextRoundWithDelay(seconds: Double) {
        
        //Executes the nextRound method after the given delay
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.nextRound()
        }
    }
    
    func loadGameSound(soundName: String, soundID: UnsafeMutablePointer<SystemSoundID>) {
        
        //Load sound
        let pathToSoundFile = Bundle.main.path(forResource: soundName, ofType: "wav")
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
    
    //Hides the status bar
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

