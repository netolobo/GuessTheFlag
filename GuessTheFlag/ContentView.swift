//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Neto Lobo on 28/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var showFinalScore = false
    @State private var gameRounds = 8
    @State private var animationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    @State private var tappedButtonIndex: Int?
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .init(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: .init(red: 0.76, green: 0.15, blue: 0.2), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            tappedButtonIndex = number
                        } label: {
                            flagImage(imageName: countries[number])
                                .accessibilityLabel(labels[countries[number]], default: "Unknown flag")
                        }
                        .rotation3DEffect(
                            .degrees(tappedButtonIndex == number ? animationAmount : 0),
                                                  axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .scaleEffect(tappedButtonIndex != number ? scaleAmount : 1.0)
                        .opacity(tappedButtonIndex != number ? opacityAmount : 1.0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Your score is \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
            Button("Reset", action: resetGame)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("The game is over!", isPresented: $showFinalScore) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation {
                animationAmount += 360
            }
        } else {
            scoreTitle = "Wrong! That's the flag of the \(countries[number])"
            if score > 0 {
                score -= 1
            }
            
            withAnimation {
                opacityAmount = 0.25
                scaleAmount = 0.25
            }
        }
        gameRounds -= 1
        
        if gameRounds == 0 {
            showFinalScore = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        resetAnimations()
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        gameRounds = 8
        score = 0
        resetAnimations()
    }
    
    func resetAnimations() {
        scaleAmount = 1.0
        opacityAmount = 1.0
    }
}

struct flagImage : View {
    let imageName : String
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }

    
}

#Preview {
    ContentView()
}
