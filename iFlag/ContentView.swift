//
//  ContentView.swift
//  iFlag
//
//  Created by Kaumon Aung on 15.04.20.
//  Copyright © 2020 Kaumon Aung. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let europeFlags = ["Netherlands", "Greece", "Germany", "Italy", "UK", "Switzerland", "Poland", "Sweden", "Belgium", "Austria", "Denmark", "Croatia", "Ukraine", "Norway", "Finland", "Ireland", "Malta", "Iceland", "Romania", "Hungary", "Luxembourg", "Bulgaria", "Slovenia", "Albania", "Cyprus", "Serbia", "Estonia", "Slovakia", "Portugal", "Czech Republic", "Latvia", "Bosnia and Herzegovina", "Armenia", "Montenegro", "Kosovo", "Georgia", "Lithuania", "Liechtenstein", "Monaco", "Vatican City"]
    let americaFlags = ["USA", "Brazil", "Mexico", "Colombia", "Argentina", "Canada", "Peru", "Venezuela", "Chile", "Ecuador", "Guatemala", "Cuba", "Bolivia", "Haiti", "Dominican Republic", "Paraguay", "Costa Rica", "Jamaica", "Puerto Rico"]
    let africaFlags = ["South Africa", "Nigeria", "Kenya", "Ghana", "Algeria", "Cameroon", "Democratic Republic of the Congo", "Egypt", "Ethiopia", "Liberia", "Libya", "Madagascar", "Mauritius", "Morocco", "Namibia", "Senegal", "Somalia", "Sudan", "Zimbabwe", "Tunisia"]
    let asiaFlags = ["China", "India", "Kazakhstan", "Saudi Arabia", "Iran", "Mongolia", "Indonesia", "Pakistan", "Turkey", "Myanmar", "Afghanistan", "Yemen", "Thailand", "Turkmenistan", "Uzbekistan", "Iraq", "Japan", "Vietnam", "Malaysia", "Oman", "Philippines", "Laos", "Syria", "Cambodia", "Bangladesh", "Nepal", "South Korea", "United Arab Emirates", "Sri Lanka", "Taiwan", "Israel", "Qatar", "Singapore", "Maldives", "Australia", "New Zealand", "Fiji", "Papua New Guinea"]
    
    @State private var allFlags = ["Germany", "USA", "UK"]
    @State private var correctQuestionCount = 0
    @State private var showingAlert = false
    @State private var correctAnswer = Int.random(in: 0 ..< 3)
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var dismissButton = ""
    @State private var questionCount = 1
    @State private var selection = 0
    @State private var gameStatusActive = false
    
    let areaSelection = ["Europe", "America", "Africa", "Asia", "All"]
    
    let topColor = Color(red: 250/255, green: 208/255, blue: 196/255)
    let bottomColor = Color(red: 255/255, green: 154/255, blue: 158/255)
    let darkGrey = Color(red: 38/255, green: 50/255, blue: 56/255)
    let darkRed = Color(red: 255/255, green: 79/255, blue: 85/255)
    
    var flagBeingAskedFor: String {
        let rightAnswer = correctAnswer
        let searchedFlag = allFlags[rightAnswer]
        return searchedFlag
    }
    
    var buttonLabel: String {
        var label: String = ""
        
        if !gameStatusActive {
            label = "Start Game"
        } else if questionCount == 10 {
            label = "Start Game"
        } else {
            label = "Restart Game"
        }
        
        return label
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Picker("Select what flags you want", selection: $selection) {
                    ForEach(0 ..< areaSelection.count) {
                        Text("\(self.areaSelection[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: {
                    self.startGame(flagArea: self.selection)
                }) {
                    Text(buttonLabel)
                        .padding(.all, 10)
                        .background(darkRed)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } .padding(.bottom)
                
                Divider()
                
                Text("Tap the flag of")
                    .foregroundColor(darkGrey)
                    .padding(.top)
                
                Text(flagBeingAskedFor)
                    .foregroundColor(darkGrey)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.checkAnswer(number: number)
                    }) {
                        Image(self.allFlags[number])
                            .resizable()
                            .frame(width: 200, height: 100)
                            .shadow(radius: 5)
                            .padding(.vertical, 5)
                    } .buttonStyle(PlainButtonStyle())
                }
                
                Text("\(questionCount) out of 10")
                    .foregroundColor(darkGrey)
                    .frame(minWidth: 100)
                    .font(.headline)
                
            }
        }
            
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text(dismissButton)) {
                self.newQuestion()
                })
        }
        
    }
    
    func startGame(flagArea: Int) {
        
        switch flagArea {
        case 0:
            checkGameStatus()
            allFlags.removeAll()
            allFlags.append(contentsOf: europeFlags)
            allFlags.shuffle()
        case 1:
            checkGameStatus()
            allFlags.removeAll()
            allFlags.append(contentsOf: americaFlags)
            allFlags.shuffle()
        case 2:
            checkGameStatus()
            allFlags.removeAll()
            allFlags.append(contentsOf: africaFlags)
            allFlags.shuffle()
        case 3:
            checkGameStatus()
            allFlags.removeAll()
            allFlags.append(contentsOf: asiaFlags)
            allFlags.shuffle()
        case 4:
            checkGameStatus()
            allFlags.removeAll()
            allFlags.append(contentsOf: europeFlags + americaFlags + africaFlags + asiaFlags)
            allFlags.shuffle()
        default:
            fatalError("Could not find flag selection")
        }
    }
    
    func checkGameStatus() {
        
        if !gameStatusActive {
            gameStatusActive = true
            correctQuestionCount = 0
            questionCount = 1
        } else {
            correctQuestionCount = 0
            questionCount = 1
            gameStatusActive = true
        }
        
    }
    
    func checkAnswer(number: Int) {
        if !gameStatusActive { return }
        
        if number == correctAnswer {
            correctQuestionCount += 1
            correctFlagTapped(country: number)
        } else {
            correctQuestionCount -= 1
            wrongFlagTapped(country: number)
        }
    }
    
    func newQuestion() {
        correctAnswer = Int.random(in: 0 ..< 3)
        allFlags.shuffle()
    }
    
    func correctFlagTapped(country: Int) {
        if questionCount == 9 {
            gameFinished()
        } else {
            showingAlert = true
            alertTitle = "Correct!"
            alertMessage = "Good job! This is \(allFlags[country])"
            dismissButton = "Next Question"
            questionCount += 1
        }
        
    }
    
    func wrongFlagTapped(country: Int) {
        if questionCount == 9 {
            gameFinished()
        } else {
            showingAlert = true
            alertTitle = "Wrong!"
            alertMessage = "Sorry! This is actually \(allFlags[country])"
            dismissButton = "Next Question"
            questionCount += 1
        }
        
    }
    
    func gameFinished() {
        showingAlert = true
        alertTitle = "Congratulations!"
        alertMessage = "You got \(correctQuestionCount) out of 10 questions right."
        dismissButton = "Dismiss"
        questionCount += 1
        gameStatusActive = false
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
