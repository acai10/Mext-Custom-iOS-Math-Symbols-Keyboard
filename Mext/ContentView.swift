//
//  ContentView.swift
//  Mext
//
//  Created by acai10 on 03.06.25.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Variables
    let text = "Have a nice day "
    let radius_circle: CGFloat = 100
    let radius_text: CGFloat = 80
    let size: CGFloat = 200
    let letters: [(offset: Int, element: Character)]
    
    @State private var inputLink: String = ""
    @State private var link: String = "https://google.com"
    @State private var rotation: Double = 0
    // score button
    @State private var score: Int = 0
    @State private var resetChance: Double = 0.0
    @State private var currentChanceScore: Double = 0.0
    @State private var currentChanceMax: Double = 0.0
    @State private var totalTaps: Int = 0
    @State private var maxScore: Int = 0
    @State private var add: Int = 1
    let scoreColors: [Color] = [
        Color.red,
        Color.pink,
        Color.orange,
        Color.yellow,
        Color.brown,
        Color.cyan,
        Color.indigo,
        Color.purple,
        Color.teal,
        Color.green,
        Color.gray,
        Color.blue,
        Color.mint
    ]
    // powerUps
    @GestureState private var isScoreButtonPressed: Bool = false
    @GestureState private var isPowerUpButtonPressed: Bool = false
    @GestureState private var isAutoClickerButtonPressed: Bool = false
    @GestureState private var isAddButtonPressed: Bool = false
    @State private var isStartAutoClicker: Bool = false
    @State private var factor: Double = 1.0
    @State private var timer: Timer?
    @GestureState private var isFactorButtonPressed: Bool = false
    // page selection
    @State private var currentPage: String = "colors"
    // default
    @GestureState private var isDefaultPressed: Bool = false
    // button backgrounds
    @GestureState private var isMintPressed: Bool = false
    @GestureState private var isTealPressed: Bool = false
    @GestureState private var isCyanPressed: Bool = false
    @GestureState private var isBluePressed: Bool = false
    @GestureState private var isIndigoPressed: Bool = false
    @GestureState private var isPurplePressed: Bool = false
    @GestureState private var isPinkPressed: Bool = false
    @GestureState private var isRedPressed: Bool = false
    @GestureState private var isOrangePressed: Bool = false
    @GestureState private var isYellowPressed: Bool = false
    @GestureState private var isGreenPressed: Bool = false
    @GestureState private var isBrownPressed: Bool = false
    @GestureState private var isWhitePressed: Bool = false
    @GestureState private var isLavenderPressed: Bool = false
    @GestureState private var isCoralPressed: Bool = false
    @GestureState private var isFuchsiaPressed: Bool = false
    @GestureState private var isAppleGreenPressed: Bool = false
    @GestureState private var isRosePressed: Bool = false
    @GestureState private var isSmokeBluePressed: Bool = false
    @GestureState private var isMidnightPressed: Bool = false
    @GestureState private var isLimePressed: Bool = false
    @GestureState private var isMustardPressed: Bool = false
    // button titles
    @GestureState private var isBlackTitlePressed: Bool = false
    @GestureState private var isWhiteTitlePressed: Bool = false
    // keyboard backgrounds
    @GestureState private var isSandPressed: Bool = false
    @GestureState private var isCaramelPressed: Bool = false
    @GestureState private var isOlivePressed: Bool = false
    @GestureState private var isSagePressed: Bool = false
    @GestureState private var isSkyPressed: Bool = false
    @GestureState private var isLavenderGrayPressed: Bool = false
    @GestureState private var isPlumPressed: Bool = false
    @GestureState private var isRoseGrayPressed: Bool = false
    @GestureState private var isPeachPressed: Bool = false
    
    // MARK: - Colors
    static let buttonBackgroundColors: [String] = [
        "mint", "teal", "cyan", "blue", "indigo", "purple", "pink", "red",
        "orange", "yellow", "green", "brown", "white", "lavender", "coral",
        "fuchsia", "appleGreen", "rose", "smokeBlue", "midnight", "lime", "mustard"
    ]
    
    static let buttonTitleColors: [String] = [
        "blackTitle", "whiteTitle"
    ]
    
    static let keyboardBackground: [String] = [
        "sand", "caramel", "olive", "sage", "sky",
        "lavenderGray", "plum", "roseGray", "peach"
    ]
    
    // MARK: - init
    init() {
        letters = Array(text.enumerated())
        
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        if defaults?.string(forKey: "buttons") == nil {
            defaults?.set(" ", forKey: "buttons")
        }
        if defaults?.string(forKey: "buttonTitle") == nil {
            defaults?.set(" ", forKey: "buttonTitle")
        }
        if defaults?.string(forKey: "keyboardBackgroundColor") == nil {
            defaults?.set(" ", forKey: "keyboardBackgroundColor")
        }
        if defaults?.double(forKey: "Factor") == nil {
            defaults?.set(1.0, forKey: "Factor")
        }
    }
    
    // MARK: - main body
    var body: some View {
        VStack {
            Picker("Choose a page", selection: $currentPage) {
                Text("Colors").tag("colors")
                Text("Score").tag("score")
            }
            .pickerStyle(.segmented)
            .padding()
            
            if currentPage == "colors" {
                ScrollView(.vertical) {
                    VStack {
                        TextField("https://", text: $inputLink)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.purple, lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .onChange(of: inputLink) {
                                link = "https://\(inputLink)"
                                if inputLink == "" || inputLink == "https://" {
                                    link = "https://google.com"
                                }
                            }
                        
                        ZStack {
                            Circle()
                                .stroke(Color.purple, lineWidth: 3)
                                .frame(width: radius_circle * 2, height: radius_circle * 2)
                            
                            
                            
                            Link("🚀", destination: URL(string: link)!)
                                .font(.system(size: 60))
                            
                            ForEach(letters, id: \.offset) { index, letter in
                                letterView(index: index, letter: letter)
                            }
                            .frame(width: size, height: size)
                            .rotationEffect(.degrees(rotation))
                            .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: rotation)
                            .onAppear {
                                rotation -= 360
                            }
                        }
                        
                        ColorButton(color: .gray, key: " ", isPressed: isDefaultPressed)
                        
                        Text("Press a color to change the button color")
                            .font(.caption)
                            .padding(.top, 10)
                        
                        HStack {
                            ColorButton(color: .mint, key: "mint", isPressed: isMintPressed)
                            ColorButton(color: .teal, key: "teal", isPressed: isTealPressed)
                            ColorButton(color: .cyan, key: "cyan", isPressed: isCyanPressed)
                            ColorButton(color: .blue, key: "blue", isPressed: isBluePressed)
                            ColorButton(color: .indigo, key: "indigo", isPressed: isIndigoPressed)
                            ColorButton(color: .purple, key: "purple", isPressed: isPurplePressed)
                            ColorButton(color: .pink, key: "pink", isPressed: isPinkPressed)
                            ColorButton(color: .red, key: "red", isPressed: isRedPressed)
                        }
                        
                        HStack {
                            ColorButton(color: .orange, key: "orange", isPressed: isOrangePressed)
                            ColorButton(color: .yellow, key: "yellow", isPressed: isYellowPressed)
                            ColorButton(color: .green, key: "green", isPressed: isGreenPressed)
                            ColorButton(color: .brown, key: "brown", isPressed: isBrownPressed)
                            ColorButton(color: Color(white: 0.9), key: "white", isPressed: isWhitePressed)
                            ColorButton(color: Color(hue: 0.6, saturation: 0.5, brightness: 0.9), key: "lavender", isPressed: isLavenderPressed)
                            ColorButton(color: Color(hue: 0.1, saturation: 0.7, brightness: 1.0), key: "coral", isPressed: isCoralPressed)
                        }
                        
                        HStack {
                            ColorButton(color: Color(hue: 0.85, saturation: 0.4, brightness: 0.8), key: "fuchsia", isPressed: isFuchsiaPressed)
                            ColorButton(color: Color(hue: 0.3, saturation: 0.7, brightness: 0.8), key: "appleGreen", isPressed: isAppleGreenPressed)
                            ColorButton(color: Color(hue: 0.95, saturation: 0.3, brightness: 0.9), key: "rose", isPressed: isRosePressed)
                            ColorButton(color: Color(hue: 0.5, saturation: 0.2, brightness: 0.6), key: "smokeBlue", isPressed: isSmokeBluePressed)
                            ColorButton(color: Color(hue: 0.67, saturation: 0.6, brightness: 0.7), key: "midnight", isPressed: isMidnightPressed)
                            ColorButton(color: Color(hue: 0.45, saturation: 0.6, brightness: 0.9), key: "lime", isPressed: isLimePressed)
                            ColorButton(color: Color(hue: 0.2, saturation: 0.4, brightness: 0.7), key: "mustard", isPressed: isMustardPressed)
                        }
                        
                        Text("Press a color to change the button title color")
                            .font(.caption)
                            .padding(.top, 10)
                        
                        HStack {
                            ColorButton(color: .black, key: "blackTitle", isPressed: isBlackTitlePressed)
                            ColorButton(color: .white, key: "whiteTitle", isPressed: isWhiteTitlePressed)
                        }
                        
                        Text("Press a color to change the keyboard background color")
                            .font(.caption)
                            .padding(.top, 10)
                        
                        HStack {
                            ColorButton(color: Color(hue: 0.55, saturation: 0.4, brightness: 0.7), key: "sky", isPressed: isSkyPressed)
                            ColorButton(color: Color(hue: 0.1, saturation: 0.3, brightness: 0.95), key: "sand", isPressed: isSandPressed)
                            ColorButton(color: Color(hue: 0.15, saturation: 0.4, brightness: 0.8), key: "caramel", isPressed: isCaramelPressed)
                            ColorButton(color: Color(hue: 0.25, saturation: 0.6, brightness: 0.9), key: "olive", isPressed: isOlivePressed)
                            ColorButton(color: Color(hue: 0.4, saturation: 0.5, brightness: 0.85), key: "sage", isPressed: isSagePressed)
                        }
                        
                        HStack {
                            ColorButton(color: Color(hue: 0.6, saturation: 0.3, brightness: 0.75), key: "lavenderGray", isPressed: isLavenderGrayPressed)
                            ColorButton(color: Color(hue: 0.7, saturation: 0.4, brightness: 0.6), key: "plum", isPressed: isPlumPressed)
                            ColorButton(color: Color(hue: 0.83, saturation: 0.3, brightness: 0.85), key: "roseGray", isPressed: isRoseGrayPressed)
                            ColorButton(color: Color(hue: 0.05, saturation: 0.5, brightness: 1.0), key: "peach", isPressed: isPeachPressed)
                        }
                    }
                }
            }
            else if currentPage == "score" {
                ScrollView(.vertical) {
                    HStack {
                        // MARK: - PowerUp
                        Button {
                            powerUp(cost: 1000, getScore: 10, getChance: 0.1)
                        } label: {
                            Text("+10 (cost: 1000)")
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(getColorButton())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.purple, lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                        .scaleEffect(isPowerUpButtonPressed ? 1.2 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: isPowerUpButtonPressed)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .updating($isPowerUpButtonPressed) { _, state, _ in
                                    state = true
                                }
                        )
                        
                        Button {
                            add = getAdd()
                            guard add < 1000 else { return }
                            let requiredTaps = 1000 * add
                            if getTaps() >= requiredTaps && add < 1000 {
                                let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
                                add += 1
                                defaults?.set(getTaps() - requiredTaps, forKey: "TotalTaps")
                                defaults?.set(add, forKey: "Add")
                                update()
                            }
                        } label: {
                            Text(add < 1000 ? "+1 / tap (cost: \(1000 * add))" : "out of stock")
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(getColorButton())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.purple, lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                        .scaleEffect(isAddButtonPressed ? 1.2 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: isAddButtonPressed)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .updating($isAddButtonPressed) { _, state, _ in
                                    state = true
                                }
                        )
                    }
                    .padding(10)
                    
                    // MARK: - Auto Clicker
                    HStack {
                        Button {
                            isStartAutoClicker.toggle()
                            if isStartAutoClicker {
                                startTimer()
                            } else {
                                stopTimer()
                            }
                        } label: {
                            Text("Auto Clicker")
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(getColorButton())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.purple, lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                        .scaleEffect(isAutoClickerButtonPressed ? 1.2 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: isAutoClickerButtonPressed)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .updating($isAutoClickerButtonPressed) { _, state, _ in
                                    state = true
                                }
                        )
                        
                        Button {
                            factor = getFactor()
                            guard factor >= 0.01 else { return }
                            let requiredTaps = Int(10000 * (1 / factor))
                            if getTaps() >= requiredTaps && factor >= 0.01 {
                                let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
                                factor *= 0.1
                                startTimer()
                                defaults?.set(getTaps() - requiredTaps, forKey: "TotalTaps")
                                defaults?.set(factor, forKey: "Factor")
                                update()
                            }
                        } label: {
                            Text(factor >= 0.01
                                 ? String(format: "x%.0f (cost: %.0f)", 1 / factor, 10000 * (1 / factor))
                                 : String(format: "x%.0f", 1 / factor)
                                )
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(getColorButton())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.purple, lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                        .scaleEffect(isFactorButtonPressed ? 1.2 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: isFactorButtonPressed)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .updating($isFactorButtonPressed) { _, state, _ in
                                    state = true
                                }
                        )
                    }
                    .padding(.bottom, 10)
                    
                    // MARK: - Stats
                    VStack {
                        Text("Total: \(totalTaps) (\(add) / tap)")
                            .zIndex(1)
                        Text(currentChanceScore * 100 > 0.0000001 ? String(format: "Chance to reach current score: %.8f%%", currentChanceScore * 100) :  String(format: "Chance to reach current score: %.2e%%", currentChanceScore * 100))
                            .zIndex(1)
                        Text("Score: \(score)")
                            .zIndex(1)
                            .fontWeight(.bold)
                        Text(String(format: "Reset-Chance: %.0f%%", resetChance * 100))
                            .zIndex(1)
                            .fontWeight(.bold)
                        Text(currentChanceMax * 100 > 0.0000001 ? "Max: \(maxScore) has \(String(format: "%.8f%%", currentChanceMax * 100))" : "Max: \(maxScore) has \(String(format: "%.2e%%", currentChanceMax * 100))")
                            .zIndex(1)
                    }
                    .onAppear {
                        update()
                    }
                    
                    // MARK: - trigger button
                    GeometryReader { geometry in
                        VStack {
                            Button {
                                triggerScoreLogic()
                            } label: {
                                Text("+1")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                                    .background(getColorButton())
                                    .cornerRadius(.infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color.purple, lineWidth: 2)
                                    )
                            }
                            .scaleEffect(isScoreButtonPressed ? 1.2 : 1.0)
                            .animation(.easeOut(duration: 0.1), value: isScoreButtonPressed)
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .updating($isScoreButtonPressed) { _, state, _ in
                                        state = true
                                    }
                            )
                        }
                        .padding(.top, 30)
                    }
                }
            }
        }
    }
    
    // MARK: - animation function
    @ViewBuilder
    func letterView(index: Int, letter: Character) -> some View {
        let angle = Double(index) / Double(letters.count) * 2 * .pi - .pi / 2
        let x = radius_text * cos(angle) + size / 2
        let y = radius_text * sin(angle) + size / 2
        
        Text(String(letter))
            .font(.system(size: 20))
            .rotationEffect(.radians(angle + .pi / 2))
            .position(x: x, y: y)
            .bold()
    }
    
    // MARK: - Timer
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: factor, repeats: true) { _ in
            if isStartAutoClicker && factor > 0 {
                triggerScoreLogic()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Score
    func getMaxScoreText() -> Int {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        //defaults?.set(100, forKey: "MaxScore")
        return defaults?.integer(forKey: "MaxScore") ?? 0
    }

    func scoreText() -> Int {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        return defaults?.integer(forKey: "Score") ?? 0
    }

    func resetText() -> Double {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        return defaults?.double(forKey: "ResetChance") ?? 0.0
    }
    
    func getTaps() -> Int {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        //defaults?.set(100000000, forKey: "TotalTaps")
        return defaults?.integer(forKey: "TotalTaps") ?? 0
    }
    
    func getAdd() -> Int {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        if defaults?.double(forKey: "Add") == nil || defaults?.double(forKey: "Add") == 0 {
            defaults?.set(1, forKey: "Add")
        }
        //defaults?.set(1, forKey: "Add")
        return defaults?.integer(forKey: "Add") ?? 1
    }
    
    func getFactor() -> Double {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        if defaults?.double(forKey: "Factor") == nil || defaults?.double(forKey: "Factor") == 0.0 {
            defaults?.set(1.0, forKey: "Factor")
        }
        //defaults?.set(1.0, forKey: "Factor")
        return defaults?.double(forKey: "Factor") ?? 1.0
    }
    
    func getColorButton() -> Color {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        return scoreColors[min(scoreColors.count - 1, (defaults?.integer(forKey: "TotalTaps") ?? 0) / 100000)]
    }
    
    func getCurrentChance(indicator: Bool) -> Double {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        var k: Int = 0
        if indicator {
            k = defaults?.integer(forKey: "MaxScore") ?? 0
        } else {
            k = defaults?.integer(forKey: "Score") ?? 0
        }
        if k > 100 {
            return 0.0
        }
        if k <= 0 {
            return 1.0
        }

        var p = 1.0
        for n in 1...k {
            p *= 1.0 - Double(n-1) / 100.0
        }

        return p
    }
    
    // MARK: - Update func
    func update() {
        totalTaps = getTaps()
        score = scoreText()
        resetChance = resetText()
        maxScore = getMaxScoreText()
        currentChanceScore = getCurrentChance(indicator: false)
        currentChanceMax = getCurrentChance(indicator: true)
        factor = getFactor()
        add = getAdd()
    }
    
    // MARK: - track overall taps
    func trackTaps() {
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        totalTaps = defaults?.integer(forKey: "TotalTaps") ?? 0
        add = defaults?.integer(forKey: "Add") ?? 0
        totalTaps += add
        defaults?.set(totalTaps, forKey: "TotalTaps")
    }
    
    // MARK: - Score Logic Button
    func triggerScoreLogic() {
        trackTaps()
        let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        score = defaults?.integer(forKey: "Score") ?? 0
        resetChance = defaults?.double(forKey: "ResetChance") ?? 0.0

        if Double.random(in: 0...1) < resetChance {
            score = 0
            resetChance = 0.0
        } else {
            score += 1
            resetChance += 0.01
        }

        defaults?.set(score, forKey: "Score")
        defaults?.set(resetChance, forKey: "ResetChance")

        if (defaults?.integer(forKey: "MaxScore") ?? 0) < score {
            defaults?.set(score, forKey: "MaxScore")
        }
        
        update()
    }
    
    // MARK: - score button powerups
    func powerUp(cost: Int, getScore: Int, getChance: Double) {
        if getTaps() >= cost {
            let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
            
            score = defaults?.integer(forKey: "Score") ?? 0
            resetChance = defaults?.double(forKey: "ResetChance") ?? 0.0
            
            if (score + getScore <= 100) && (resetChance + getChance <= 1.0) {
                if Double.random(in: 0...1) < resetChance {
                    score = 0
                    resetChance = 0.0
                } else {
                    score += getScore
                    resetChance += getChance
                }
                defaults?.set(score, forKey: "Score")
                defaults?.set(resetChance, forKey: "ResetChance")

                if (defaults?.integer(forKey: "MaxScore") ?? 0) < score {
                    defaults?.set(score, forKey: "MaxScore")
                }
                defaults?.set(getTaps() - cost, forKey: "TotalTaps")
            }
            update()
        }
    }
    
    // MARK: - button functions
    struct ColorButton: View {
        var color: Color
        var key: String
        @GestureState var isPressed: Bool
        
        var name: String {
            key == " " ? "Default" : " "
        }

        var body: some View {
            Button(name) {
                let defaults = UserDefaults(suiteName: "group.com.acai10.mext")
                if buttonTitleColors.contains(key) {
                    defaults?.set(key, forKey: "buttonTitle")
                } else if buttonBackgroundColors.contains(key) {
                    defaults?.set(key, forKey: "buttons")
                } else if ContentView.keyboardBackground.contains(key) {
                    defaults?.set(key, forKey: "keyboardBackgroundColor")
                } else if key == " " {
                    defaults?.set(key, forKey: "buttons")
                    defaults?.set(key, forKey: "buttonTitle")
                    defaults?.set(key, forKey: "keyboardBackgroundColor")
                }
            }
            .foregroundColor(Color.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(color)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple, lineWidth: 2)
            )
            .cornerRadius(8)
            .scaleEffect(isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
            )
        }
    }
}

#Preview {
    ContentView()
}
