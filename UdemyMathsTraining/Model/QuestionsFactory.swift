//
//  QuestionsFactory.swift
//  UdemyMathsTraining
//
//  Created by Cristian Misael Almendro Lazarte on 10/2/18.
//  Copyright © 2018 Cristian Misael Almendro Lazarte. All rights reserved.
//

import Foundation


class QuestionFactory {
    
    private var questions = [Question]();
    public private(set) var score = 0;
    public private(set) var pointsPerQuestion = 100
    
    init() {
        self.addNewQuestion();
    }
    
    func restartData() {
        self.score = 0;
        self.questions.removeAll();
        self.addNewQuestion();
    }
    
    func addNewQuestion() {
        questions.insert(createQuestion(), at: 0);
    }
    
    func getQuestionAt(index: Int) -> Question? {
        
        if  index < 0 || index >= questions.count{
            return nil;
        }
        
        return self.questions[index];
    }
    
    func updateQuestion(at index: Int, with answer: Int) {
        questions[index].userAnswer = answer
    }
    
    func validateQuestion(at index: Int) {
        if self.questions[index].userAnswer == self.questions[index].answer {
            self.score += pointsPerQuestion
        }
    }
    
    func numberOfQuestions() -> Int {
        return questions.count;
    }
    
    func createQuestion() -> Question {
        var question = "";
        var correctAnswer = 0;
        
        while true {
            let firstNumber = Int.random(in: 0...9);
            let secondNumber = Int.random(in: 0...9);
            
            
            if (Bool.random()){
                //Generamos una operacion de Suma
                
                let result = firstNumber + secondNumber;
                
                if  result < 10 {
                    question = "\(firstNumber) + \(secondNumber)";
                    correctAnswer = result;
                    break;
                }
            }
            else{
                //Generamos una operacion de resta
                let result = firstNumber - secondNumber;
                
                
                if  result >= 0 {
                    question = "\(firstNumber) - \(secondNumber)";
                    correctAnswer = result;
                    break;
                }
            }
        }
        return Question(text: question, answer: correctAnswer, userAnswer: nil);
    }

}
