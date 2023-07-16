//
//  ContentView.swift
//  Mathgik
//
//  Created by Louis Mille on 16/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var gameStart = false
    
    @State private var tables = 2
    
    @State private var questions = 1
    @State private var currentQuestion = 1
    
    @State private var userAnswer = 0
    
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var showingScore = false
    
    @State private var difficulty = ["chick", "dog", "snake"]
    @State private var easyModeNumbers = Int.random(in: 1..<5)
    @State private var moderateModeNumbers = Int.random(in: 5..<9)
    @State private var hardModeNumbers = Int.random(in: 9..<13)
    
    @State private var easyMode = false
    @State private var moderateMode = false
    @State private var hardMode = false
    
    @State private var opacityValue = 1.0
    
    @State private var resetGame = false
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                Text("🪄Mathgik🪄")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Text("Kids game to learn tables")
            }
            
            VStack {
                VStack {
                    Section {
                        Stepper("Select a multiplication table", value: $tables, in: 2...12, step: 1)
                        Text("\(tables)")
                            .padding(.vertical, 10)
                    }
                    
                    Section {
                        Stepper("How many questions?", value: $questions, in: 1...20, step: 1)
                        Text("\(questions)")
                            .padding(.vertical, 10)
                    }
                    
                    Section {
                        Text("Select a difficulty:")
                        HStack {
                            Button {
                                easyModeTapped()
                                cannotChangeDifficulty()
                                withAnimation {
                                    opacityValue = 0.25
                                }
                            } label: {
                                Image(difficulty[0])
                                    .opacity(easyMode == true ? 1 : opacityValue)
                            }
                            
                            Button {
                                moderateModeTapped()
                                cannotChangeDifficulty()
                                withAnimation {
                                    opacityValue = 0.25
                                }
                            } label: {
                                Image(difficulty[1])
                                    .opacity(moderateMode == true ? 1 : opacityValue)
                            }
                            
                            Button {
                                hardModeTapped()
                                cannotChangeDifficulty()
                                withAnimation {
                                    opacityValue = 0.25
                                }
                            } label: {
                                Image(difficulty[2])
                                    .opacity(hardMode == true ? 1 : opacityValue)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .padding(.horizontal, 50)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 20)
                
                Spacer()
                
                VStack {
                    Section {
                        Text("Question \(currentQuestion)/\(questions)")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 100)
                
                VStack {
                    Section {
                        if easyMode {
                            Text("What is \(tables) x \(easyModeNumbers) ?")
                                .padding(.vertical, 10)
                        }
                        if moderateMode {
                            Text("What is \(tables) x \(moderateModeNumbers) ?")
                                .padding(.vertical, 10)
                        }
                        if hardMode {
                            Text("What is \(tables) x \(hardModeNumbers) ?")
                                .padding(.vertical, 10)
                        }
                    }
                    
                    Section {
                        TextField("Answer", value: $userAnswer, format: .number)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 125)
                        Button("Validate") {
                            if easyMode {
                                easyModeNextQuestion()
                                restartGame()
                                newGame()
                            }
                            if moderateMode {
                                moderateModeNextQuestion()
                                restartGame()
                                newGame()
                            }
                            if hardMode {
                                hardModeNextQuestion()
                                restartGame()
                                newGame()
                            }
                        }
                    } header: {
                        Text("Enter your answer: ")
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 20)
                
                VStack {
                    Section {
                        Text("Score: \(currentScore)")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 100)
            }
            .navigationTitle("Mathgik")
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("End", action: restartGame)
        } message: {
            Text("Your final score is \(currentScore)")
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Restart", action: newGame)
        }
    }
    
    func easyModeTapped() {
        if moderateMode == true {
            easyMode = false
        } else if hardMode == true {
            easyMode = false
        } else {
            easyMode = true
        }
    }
    
    func moderateModeTapped() {
        if easyMode == true {
            moderateMode = false
        } else if hardMode == true {
            moderateMode = false
        } else {
            moderateMode = true
        }
    }
    
    func hardModeTapped() {
        if moderateMode == true {
            hardMode = false
        } else if easyMode == true {
            hardMode = false
        } else {
            hardMode = true
        }
    }
    
    func cannotChangeDifficulty() {
        if easyMode {
            moderateMode = false
            hardMode = false
        }
        
        if moderateMode {
            easyMode = false
            hardMode = false
        }
        
        if hardMode {
            easyMode = false
            moderateMode = false
        }
    }
    
    func easyModeNextQuestion() {
        if userAnswer != tables * easyModeNumbers {
            currentScore -= 1
            currentQuestion += 1
        } else {
            easyModeNumbers = Int.random(in: 1..<5)
            currentScore += 1
            currentQuestion += 1
        }
    }
    
    func moderateModeNextQuestion() {
        if userAnswer != tables * moderateModeNumbers {
            currentScore -= 1
            currentQuestion += 1
        } else {
            moderateModeNumbers = Int.random(in: 1..<5)
            currentScore += 1
            currentQuestion += 1
        }
    }
    
    func hardModeNextQuestion() {
        if userAnswer != tables * hardModeNumbers {
            currentScore -= 1
            currentQuestion += 1
        } else {
            hardModeNumbers = Int.random(in: 1..<5)
            currentScore += 1
            currentQuestion += 1
        }
    }
    
    func restartGame() {
        if currentQuestion == questions {
            scoreTitle = "No more questions"
            resetGame = true
        }
    }
    
    func newGame() {
        if resetGame == true {
            tables = 2
            questions = 1
            currentScore = 0
            currentQuestion = 0
            easyMode = false
            moderateMode = false
            hardMode = false
            opacityValue = 1.0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
