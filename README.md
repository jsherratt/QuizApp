# QuizApp
This is a simple quiz game where the user is presented with a question and has 15 seconds to answer.

# Instructions
The starter files contain a Storyboard scene that is simulated to a 4.7 inch iPhone without any constraints to position elements. If you run the app in an iPhone 6/6s simulator, the layout looks fine but it breaks on any other device size. Convert the Storyboard back to a universal scene and add constraints to maintain the layout such all UI elements are sized and spaced appropriately for all iPhones 3, 4, 5, 6 and 6+.

Refactor the existing code to make use of custom structs or classes where appropriate and ensure that code adheres to the Model-View-Controller (MVC) design pattern. Please place your new custom data structure in a new Swift file.
Enhance the quiz so that it can accommodate four answer choices for each question, as shown in the mockups and sample question set.
Add functionality such that during each game, questions are chosen at random, though no question will be repeated within a single game.

In addition, all students must implement ONE of the following features. To be eligible for a grade of “exceeds expectations” you must implement at least THREE of the following features, marked as OPTIONAL:
Please note: Many of the below features can be adapted from code which already exists in the starter project.

Add two sound effects, one for correct answers and one for incorrect. You may also add sounds at game end, or wherever else you see fit. (Hint: you can base your solution on code already found in the starter app.

Modify the app to be in "lightning" mode where users only have 15 seconds to select an answer. Display the number of correct answers at the end of the quiz.

Implement a way to appropriately display the correct answer, when a player answers incorrectly.
