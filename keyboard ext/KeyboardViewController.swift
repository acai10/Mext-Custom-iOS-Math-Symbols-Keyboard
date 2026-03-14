//
//  KeyboardViewController.swift
//  math ext
//
//  Created by acai10 on 02.06.25.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    // MARK: - variables
    // stacks
    var infoLabel: UILabel!
    var mainStack: UIStackView!
    var varStack: UIStackView!
    var functionStack: UIStackView!
    
    // user input
    var defaults: UserDefaults!
    var theme: [String: String] = [:] // ["buttons": ..., "keyboardBackgroundColor": ..., ...]
    
    // pop-up
    var popupLabel: UILabel?
    var popupButtons: [String: [UIButton]] = [:]
    
    // continuous action
    var deleteTimer: Timer?

    @IBOutlet var nextKeyboardButton: UIButton!

    // height for keyboard
    var keyboardHeightConstraint: NSLayoutConstraint?

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // MARK: - keyboard size initialisation
        if self.keyboardHeightConstraint == nil {
            let height: CGFloat = 290 // ideally self.view.frame.height * 0.34
            let constraint = NSLayoutConstraint(
                item: self.inputView!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: height
            )
            constraint.priority = UILayoutPriority(999)
            self.inputView?.addConstraint(constraint)
            self.keyboardHeightConstraint = constraint
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
        
        // MARK: - update
        updateStack(stack: self.mainStack)
        updateStack(stack: self.varStack)
        updateStack(stack: self.functionStack)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - main function to initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - user input
        self.defaults = UserDefaults(suiteName: "group.com.acai10.mext")
        self.theme["buttons"] = self.defaults?.string(forKey: "buttons") ?? "system"
        self.theme["buttonTitle"] = self.defaults?.string(forKey: "buttonTitle") ?? "system"
        self.theme["keyboardBackgroundColor"] = self.defaults?.string(forKey: "keyboardBackgroundColor") ?? "system"
        
        backgroundColor(stack: self.view)
        
        self.infoLabel = UILabel()
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.numberOfLines = 0
        updateInfoLabel()
        self.infoLabel.textAlignment = .center
        self.infoLabel.font = UIFont.systemFont(ofSize: 16)
        
        switch self.theme["buttonTitle"] {
        case "blackTitle":
            self.infoLabel.textColor = .black
        case "whiteTitle":
            self.infoLabel.textColor = .white
        default:
            // check if darkmode
            if self.traitCollection.userInterfaceStyle == .dark {
                self.infoLabel.textColor = .white
            } else {
                self.infoLabel.textColor = .black
            }
        }

        self.view.addSubview(self.infoLabel)

        // position
        NSLayoutConstraint.activate([
            self.infoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.infoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5)
        ])
        
        // MARK: - popup buttons initialisation
        self.popupButtons = popUpSymbolTitles.mapValues { titles in
            titles.map {
                if !pageSwitch_symbols.contains($0) { createButton(with: $0, action: #selector(insertSymbol)) }
                else { createButton(with: $0, action: #selector(switchModeTapped)) }
            }
        }
        
        // MARK: - mainStack
        
        // MARK: - basic arithmetic & comparison
        let mainstack_row1 = UIStackView(arrangedSubviews: mainStack_fst_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        allignment(stack: mainstack_row1, distr: "normal")
        
        // MARK: - proofs
        let mainstack_row2 = UIStackView(arrangedSubviews: mainStack_snd_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        allignment(stack: mainstack_row2, distr: "normal")
        
        // MARK: - mainstack_backspace and mainstack_tabulator
        let mainstack_backspace = createButton(with: "⌫", action: #selector(backspaceTapped))
        buttonAllignment(button: mainstack_backspace, constant: 65)
        let mainstack_subrow3_right = UIStackView(arrangedSubviews:[
            mainstack_backspace
        ])
        mainstack_subrow3_right.axis = .horizontal
        
        let mainstack_tabulator = createButton(with: "⇥", action: #selector(tabTapped))
        buttonAllignment(button: mainstack_tabulator, constant: 65)
        let mainstack_subrow3_left = UIStackView(arrangedSubviews:[
            mainstack_tabulator
        ])
        mainstack_subrow3_left.axis = .horizontal
        
        // MARK: - sets
        let mainstack_subrow3_center = UIStackView(arrangedSubviews: mainStack_trd_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        for button in mainstack_subrow3_center.arrangedSubviews { button.tag = 3 }
        allignment(stack: mainstack_subrow3_center, distr: "center3")
        
        let mainstack_row3 = UIStackView(arrangedSubviews:[
            mainstack_subrow3_left,
            mainstack_subrow3_center,
            mainstack_subrow3_right
        ])
        allignment(stack: mainstack_row3, distr: "proportionally")
        
        // MARK: - mainstack_space and mainstack_backspace
        let maintack_space = createButton(with: "space", action: #selector(spaceTapped))
        let mainstack_subrow4_center = UIStackView(arrangedSubviews:[
            maintack_space
        ])
        allignment(stack: mainstack_subrow4_center, distr: "center4")
        
        let mainstack_enter = createButton(with: "⏎", action: #selector(enterTapped))
        buttonAllignment(button: mainstack_enter, constant: 75)
        let mainstack_subrow4_right = UIStackView(arrangedSubviews:[
            mainstack_enter
        ])
        mainstack_subrow4_right.axis = .horizontal
        
        let contextSwitchPage1 = createButton(with: "αβγ", action: #selector(switchModeTapped))
        buttonAllignment(button: contextSwitchPage1, constant: 75)
        contextSwitchPage1.tag = 0
        let mainstack_subrow4_left = UIStackView(arrangedSubviews:[
            contextSwitchPage1
        ])
        mainstack_subrow4_left.axis = .horizontal
        
        let mainstack_row4 = UIStackView(arrangedSubviews:[
            mainstack_subrow4_left,
            mainstack_subrow4_center,
            mainstack_subrow4_right
        ])
        allignment(stack: mainstack_row4, distr: "proportionally")
        

        // MARK: - mainStack arrangement
        self.mainStack = UIStackView(arrangedSubviews: [mainstack_row1, mainstack_row2, mainstack_row3, mainstack_row4])
        allignment(stack: self.mainStack, distr: "main")
        
        // MARK: - varStack
        
        // MARK: - integer
        let varstack_row1 = UIStackView(arrangedSubviews: varStack_fst_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        allignment(stack: varstack_row1, distr: "normal")
        
        // MARK: - letters
        let varstack_row2 = UIStackView(arrangedSubviews: varStack_snd_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        allignment(stack: varstack_row2, distr: "normal")
        
        // MARK: - varstack_backspace and varstack_tabulator
        let varstack_backspace = createButton(with: "⌫", action: #selector(backspaceTapped))
        buttonAllignment(button: varstack_backspace, constant: 65)
        let varstack_subrow3_right = UIStackView(arrangedSubviews:[
            varstack_backspace
        ])
        varstack_subrow3_right.axis = .horizontal
        
        let varstack_tabulator = createButton(with: "⇥", action: #selector(tabTapped))
        buttonAllignment(button: varstack_tabulator, constant: 65)
        let varstack_subrow3_left = UIStackView(arrangedSubviews:[
            varstack_tabulator
        ])
        varstack_subrow3_left.axis = .horizontal
        
        // MARK: - greek letters
        let varstack_subrow3_center = UIStackView(arrangedSubviews: varStack_trd_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        for button in varstack_subrow3_center.arrangedSubviews { button.tag = 3 }
        allignment(stack: varstack_subrow3_center, distr: "center3")
        
        let varstack_row3 = UIStackView(arrangedSubviews:[
            varstack_subrow3_left,
            varstack_subrow3_center,
            varstack_subrow3_right
        ])
        allignment(stack: varstack_row3, distr: "proportionally")
        
        // MARK: - varstack_space and varstack_backspace
        let varstack_space = createButton(with: "space", action: #selector(spaceTapped))
        let varstack_subrow4_center = UIStackView(arrangedSubviews:[
            varstack_space
        ])
        allignment(stack: varstack_subrow4_center, distr: "center4")
        
        let varstack_enter = createButton(with: "⏎", action: #selector(enterTapped))
        buttonAllignment(button: varstack_enter, constant: 75)
        let varstack_subrow4_right = UIStackView(arrangedSubviews:[
            varstack_enter
        ])
        varstack_subrow4_right.axis = .horizontal
        
        let contextSwitchPage2 = createButton(with: "ƒx", action: #selector(switchModeTapped))
        buttonAllignment(button: contextSwitchPage2, constant: 75)
        contextSwitchPage2.tag = 1
        let varstack_subrow4_left = UIStackView(arrangedSubviews:[
            contextSwitchPage2
        ])
        varstack_subrow4_left.axis = .horizontal
        
        let varstack_row4 = UIStackView(arrangedSubviews:[
            varstack_subrow4_left,
            varstack_subrow4_center,
            varstack_subrow4_right
        ])
        allignment(stack: varstack_row4, distr: "proportionally")
        
        // MARK: - varStack arrangement
        self.varStack = UIStackView(arrangedSubviews: [varstack_row1, varstack_row2, varstack_row3, varstack_row4])
        allignment(stack: self.varStack, distr: "main")
        
        // MARK: - functionStack
        
        // MARK: - integer
        let functionstack_row1 = UIStackView(arrangedSubviews: functionStack_fst_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        allignment(stack: functionstack_row1, distr: "normal")
        
        // MARK: - letters
        let functionstack_row2 = UIStackView(arrangedSubviews: functionStack_snd_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        allignment(stack: functionstack_row2, distr: "normal")
        
        // MARK: - functionstack_backspace and functionstack_tabulator
        let functionstack_backspace = createButton(with: "⌫", action: #selector(backspaceTapped))
        buttonAllignment(button: functionstack_backspace, constant: 65)
        let functionstack_subrow3_right = UIStackView(arrangedSubviews:[
            functionstack_backspace
        ])
        functionstack_subrow3_right.axis = .horizontal
        
        let functionstack_tabulator = createButton(with: "⇥", action: #selector(tabTapped))
        buttonAllignment(button: functionstack_tabulator, constant: 65)
        let functionstack_subrow3_left = UIStackView(arrangedSubviews:[
            functionstack_tabulator
        ])
        functionstack_subrow3_left.axis = .horizontal
        
        // MARK: - greek letters
        let functionstack_subrow3_center = UIStackView(arrangedSubviews: functionStack_trd_row.map { createButton(with: $0, action: #selector(insertSymbol)) })
        for button in functionstack_subrow3_center.arrangedSubviews { button.tag = 3 }
        allignment(stack: functionstack_subrow3_center, distr: "center3")
        
        let functionstack_row3 = UIStackView(arrangedSubviews:[
            functionstack_subrow3_left,
            functionstack_subrow3_center,
            functionstack_subrow3_right
        ])
        allignment(stack: functionstack_row3, distr: "proportionally")
        
        // MARK: - functionstack_space and functionstack_backspace
        let functionstack_space = createButton(with: "space", action: #selector(spaceTapped))
        let functionstack_subrow4_center = UIStackView(arrangedSubviews:[
            functionstack_space
        ])
        allignment(stack: functionstack_subrow4_center, distr: "center4")
        
        let functionstack_enter = createButton(with: "⏎", action: #selector(enterTapped))
        buttonAllignment(button: functionstack_enter, constant: 75)
        let functionstack_subrow4_right = UIStackView(arrangedSubviews:[
            functionstack_enter
        ])
        functionstack_subrow4_right.axis = .horizontal
        
        let contextSwitchPage3 = createButton(with: "±×÷", action: #selector(switchModeTapped))
        buttonAllignment(button: contextSwitchPage3, constant: 75)
        contextSwitchPage3.tag = 2
        let functionstack_subrow4_left = UIStackView(arrangedSubviews:[
            contextSwitchPage3
        ])
        functionstack_subrow4_left.axis = .horizontal
        
        let functionstack_row4 = UIStackView(arrangedSubviews:[
            functionstack_subrow4_left,
            functionstack_subrow4_center,
            functionstack_subrow4_right
        ])
        allignment(stack: functionstack_row4, distr: "proportionally")
        
        // MARK: - functionstack arrangement
        self.functionStack = UIStackView(arrangedSubviews: [functionstack_row1, functionstack_row2, functionstack_row3, functionstack_row4])
        allignment(stack: self.functionStack, distr: "main")
        
        // show mainStack first
        self.mainStack.isHidden = false
        
        
        // MARK: - from auto generate
        // perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
     
    override func textWillChange(_ textInput: UITextInput?) {
        // the app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // the app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
}
