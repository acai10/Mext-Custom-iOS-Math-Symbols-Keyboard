//
//  HelperFunctions.swift
//  Mext
//
//  Created by acai10 on 09.06.25.
//

import UIKit

extension KeyboardViewController {
    // MARK: - update
    @objc func updateStack(stack: UIStackView) {
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 15
    }
    
    // MARK: - create a button
    func createButton(with title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Apple-similar Styling
        
        // check if user input
        buttonColors(button: button)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        button.layer.cornerRadius = 5
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 1
                
        if title == "⌫" {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress_back(_:)))
            longPress.minimumPressDuration = 0.5
            button.addGestureRecognizer(longPress)
        }
        
        button.addTarget(self, action: #selector(updateInfoLabel), for: .touchDown)
        
        if !noPopUp_symbols.contains(title)  {
            if !pageSwitch_symbols.contains(title) {
                button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
                button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
            }
            
            if self.popupButtons[title] != nil {
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress_popup(_:)))
                longPress.minimumPressDuration = pageSwitch_symbols.contains(title) ? 0.1 : 0.5
                button.addGestureRecognizer(longPress)
            }
            
            if pageSwitch_symbols.contains(title) {
                button.addTarget(self, action: #selector(switchModeTappedNormal), for: .touchDown)
                
                switch title {
                case "±×÷":
                    button.tag = 0
                case "αβγ":
                    button.tag = 1
                case "ƒx":
                    button.tag = 2
                default:
                    break
                }
            }
        }

        return button
    }
    
    // MARK: - allignment
    @objc func allignment(stack: UIStackView, distr: String) {
        switch distr {
        case "normal":
            //normal first and second row layout
            stack.axis = .horizontal
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
            stack.distribution = .fillEqually
            stack.spacing = 6
            stack.alignment = .center
            
        case "proportionally":
            // third and fourth row general layout
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.spacing = 6
            stack.alignment = .center
            
        case "center3":
            // third row center buttons layout
            stack.axis = .horizontal
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            stack.distribution = .fillEqually
            stack.spacing = 6
            stack.alignment = .center
            
        case "center4":
            // fourth row center buttons layout
            stack.axis = .horizontal
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            stack.distribution = .fillEqually
            stack.spacing = 6
            stack.alignment = .center
            
        case "main":
            // main page layout
            stack.axis = .vertical
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
            stack.alignment = .fill
            stack.distribution = .fillEqually
            stack.spacing = 12
            
            // add constraints and add to view
            stack.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(stack)
            stack.isHidden = true
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6).isActive = true
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6).isActive = true
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
            
        default:
            return
        }
    }
    
    // MARK: - button allignment
    @objc func buttonAllignment(button: UIButton, constant: CGFloat) {
        button.widthAnchor.constraint(equalToConstant: constant).isActive = true
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: - continuous deletions
    @objc func handleLongPress_back(_ gesture: UILongPressGestureRecognizer) {

        switch gesture.state {
        case .began:
            self.textDocumentProxy.deleteBackward()

            self.deleteTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.textDocumentProxy.deleteBackward()
            }

        case .ended, .cancelled, .failed:
            self.deleteTimer?.invalidate()
            self.deleteTimer = nil

        default:
            break
        }
    }
    
    // MARK: - pop-up view for buttons
    @objc func handleLongPress_popup(_ gesture: UILongPressGestureRecognizer) {
        guard let ogButton = gesture.view as? UIButton else { return }
        
        guard let key = ogButton.title(for: .normal),
              self.popupButtons[key] != nil else { return }
        
        guard let unwrapped_popupButtons = self.popupButtons[key] else { return }
        
        // filter popup symbols regarding the contextSwitch
        let containsMatch = unwrapped_popupButtons.contains { button in
            if let title = button.title(for: .normal) {
                return pageSwitch_symbols.contains(title)
            }
            return false
        }
        var filtered: [UIButton] = []
             
        if containsMatch {
            filtered = unwrapped_popupButtons.filter { $0.tag != ogButton.tag }
        } else {
            filtered = unwrapped_popupButtons
        }
                        
        switch gesture.state {
        case .began:
            // delete popup before
            self.popupLabel?.removeFromSuperview()
            self.popupLabel = nil
            
            // Store popupButtons for drag-to-select
            // (popupButtons is already global)
            
            let popupSubStack = UIStackView(arrangedSubviews: filtered)
            popupSubStack.axis = .horizontal
            popupSubStack.isLayoutMarginsRelativeArrangement = true
            popupSubStack.layoutMargins = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            popupSubStack.distribution = .fillEqually
            popupSubStack.spacing = 4
            popupSubStack.alignment = .center

            let popupStack = UIStackView(arrangedSubviews: [popupSubStack])
            popupStack.axis = .horizontal
            popupStack.spacing = 6
            popupStack.distribution = .fillProportionally
            popupStack.alignment = .center
            popupStack.translatesAutoresizingMaskIntoConstraints = false
            
            backgroundColor(stack: popupStack)
            
            popupStack.layer.cornerRadius = 8
            popupStack.layer.borderWidth = 0
            popupStack.tag = 888

            // popUp Stack frame
            DispatchQueue.main.async {
                // delete popup before
                self.popupLabel?.removeFromSuperview()
                self.popupLabel = nil
                
                self.view.addSubview(popupStack)
                self.view.layoutIfNeeded()
                
                // offset
                var offset: CGFloat = 0
                
                // offset of tab button
                if ogButton.tag == 3 {
                    if let row3 = self.mainStack.arrangedSubviews[2] as? UIStackView,
                       let subrow3_left = row3.arrangedSubviews[0] as? UIStackView,
                       let leftButton = subrow3_left.arrangedSubviews.first as? UIButton {
                        offset = leftButton.frame.width
                    }
                }
                
                popupStack.bottomAnchor.constraint(equalTo: ogButton.topAnchor, constant: -4).isActive = true
                popupStack.widthAnchor.constraint(equalTo: popupSubStack.widthAnchor).isActive = true
                
                if ogButton.frame.midX + offset - popupStack.frame.width / 2 <= 4 {
                    // border left
                    popupStack.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 4).isActive = true
                } else if ogButton.frame.midX + offset + popupStack.frame.width / 2 >= self.view.frame.maxX - 4 {
                    // border right
                    popupStack.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -4).isActive = true
                } else {
                    // standard position
                    popupStack.centerXAnchor.constraint(equalTo: ogButton.centerXAnchor).isActive = true
                }
            }

            self.popupLabel = UILabel()
            self.popupLabel?.tag = 999
            self.popupLabel?.isHidden = true
            self.view.addSubview(self.popupLabel!)

        case .changed:
            let location = gesture.location(in: self.view)

            for button in filtered {
                let buttonFrameInView = button.convert(button.bounds, to: self.view)
                let minX = buttonFrameInView.origin.x
                let maxX = minX + buttonFrameInView.width
                
                if location.x >= minX && location.x <= maxX {
                    UIView.animate(withDuration: 0.05) {
                        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }
                    buttonColors(button: button)
                } else {
                    button.transform = .identity
                }
            }

        case .ended:
            let location = gesture.location(in: self.view)
            
            for button in filtered {
                let buttonFrameInView = button.convert(button.bounds, to: self.view)
                let minX = buttonFrameInView.origin.x
                let maxX = minX + buttonFrameInView.width
                
                if location.x >= minX && location.x <= maxX {
                    if !pageSwitch_symbols.contains(key) { self.insertSymbol(sender: button) }
                    else { switchModeTapped(sender: button) }
                    updateInfoLabel()
                    UIView.animate(withDuration: 0.05) {
                        button.transform = CGAffineTransform.identity
                    }
                    buttonColors(button: button)
                    break
                }
            }
            fallthrough
        case .cancelled, .failed:
            if let popup = self.view.subviews.first(where: { $0 is UIStackView && $0.tag == 888 }) {
                popup.removeFromSuperview()
            }
            self.popupLabel?.removeFromSuperview()
            self.popupLabel = nil

        default:
            break
        }
        // get smaller button
        UIView.animate(withDuration: 0.05) {
            ogButton.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - key touch up for normal buttons
    @objc func keyTouchDown(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        // delete popup before
        self.popupLabel?.removeFromSuperview()
        self.popupLabel = nil
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 38)
        label.textAlignment = .center
        label.backgroundColor = sender.backgroundColor
        label.textColor = sender.titleColor(for: .normal)
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label)
        self.popupLabel = label
        
        // position label above button
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: sender.topAnchor, constant: -6),
            label.widthAnchor.constraint(equalTo: sender.widthAnchor, multiplier: 1.5),
            label.heightAnchor.constraint(equalTo: sender.heightAnchor, multiplier: 1.2)
        ])

        // scale animation for button itself
        UIView.animate(withDuration: 0.05) {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }

    @objc func keyTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            sender.transform = CGAffineTransform.identity
        }
        self.popupLabel?.removeFromSuperview()
        self.popupLabel = nil
    }
    
    // MARK: - insert functions
    @objc func insertSymbol(sender: UIButton) {
        if let symbol = sender.title(for: .normal) {
            textDocumentProxy.insertText(symbol)
        }
    }
    
    @objc func backspaceTapped() {
        textDocumentProxy.deleteBackward()
    }
    
    @objc func spaceTapped() {
        textDocumentProxy.insertText(" ")
    }
    
    @objc func tabTapped() {
        textDocumentProxy.insertText("\t")
    }
    
    @objc func enterTapped() {
        textDocumentProxy.insertText("\n")
    }

    // MARK: - switch keyboards mode
    @objc func switchModeTapped(sender: UIButton) {
        let mode = sender.title(for: .normal)

        self.mainStack.isHidden = (mode != "±×÷")
        self.varStack.isHidden = (mode != "αβγ")
        self.functionStack.isHidden = (mode != "ƒx")
    }
    
    @objc func switchModeTappedNormal(sender: UIButton) {
        let mode = sender.title(for: .normal)

        self.mainStack.isHidden = (mode != "αβγ")
        self.varStack.isHidden = (mode != "ƒx")
        self.functionStack.isHidden = (mode != "±×÷")
    }
    
    // MARK: - button colors
    @objc func buttonColors(button: UIButton) {
        switch self.theme["buttonTitle"] {
        case "blackTitle":
            button.setTitleColor(.black, for: .normal)
        case "whiteTitle":
            button.setTitleColor(.white, for: .normal)
            
        default:
            // check if darkmode
            if self.traitCollection.userInterfaceStyle == .dark {
                button.setTitleColor(.white, for: .normal)
            } else {
                button.setTitleColor(.black, for: .normal)
            }
        }
        
        switch self.theme["buttons"] {
        case "mint":
            button.backgroundColor = .systemMint
        case "teal":
            button.backgroundColor = .systemTeal
        case "cyan":
            button.backgroundColor = .cyan
        case "blue":
            button.backgroundColor = .systemBlue
        case "indigo":
            button.backgroundColor = .systemIndigo
        case "purple":
            button.backgroundColor = .systemPurple
        case "pink":
            button.backgroundColor = .systemPink
        case "red":
            button.backgroundColor = .systemRed
        case "orange":
            button.backgroundColor = .systemOrange
        case "yellow":
            button.backgroundColor = .systemYellow
        case "green":
            button.backgroundColor = .systemGreen
        case "brown":
            button.backgroundColor = .brown
        case "white":
            button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        case "lavender":
            button.backgroundColor = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.9, alpha: 1.0)
        case "coral":
            button.backgroundColor = UIColor(hue: 0.1, saturation: 0.7, brightness: 1.0, alpha: 1.0)
        case "fuchsia":
            button.backgroundColor = UIColor(hue: 0.85, saturation: 0.4, brightness: 0.8, alpha: 1.0)
        case "appleGreen":
            button.backgroundColor = UIColor(hue: 0.3, saturation: 0.7, brightness: 0.8, alpha: 1.0)
        case "rose":
            button.backgroundColor = UIColor(hue: 0.95, saturation: 0.3, brightness: 0.9, alpha: 1.0)
        case "smokeBlue":
            button.backgroundColor = UIColor(hue: 0.5, saturation: 0.2, brightness: 0.6, alpha: 1.0)
        case "midnight":
            button.backgroundColor = UIColor(hue: 0.67, saturation: 0.6, brightness: 0.7, alpha: 1.0)
        case "lime":
            button.backgroundColor = UIColor(hue: 0.45, saturation: 0.6, brightness: 0.9, alpha: 1.0)
        case "mustard":
            button.backgroundColor = UIColor(hue: 0.2, saturation: 0.4, brightness: 0.7, alpha: 1.0)
            
        default:
            // check if darkmode
            if self.traitCollection.userInterfaceStyle == .dark {
                button.backgroundColor = UIColor(white: 0.4, alpha: 1.0)
            } else {
                button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            }
        }
    }
    
    // MARK: - background colors
    @objc func backgroundColor(stack: UIView) {
        var brightness: CGFloat = 1.0
        if stack is UIStackView { brightness = 0.75 }

        switch self.theme["keyboardBackgroundColor"] {
        case "sand":
            stack.backgroundColor = UIColor(hue: 0.1, saturation: 0.3, brightness: brightness * 0.95, alpha: 1.0)
        case "caramel":
            stack.backgroundColor = UIColor(hue: 0.15, saturation: 0.4, brightness: brightness * 0.8, alpha: 1.0)
        case "olive":
            stack.backgroundColor = UIColor(hue: 0.25, saturation: 0.6, brightness: brightness * 0.9, alpha: 1.0)
        case "sage":
            stack.backgroundColor = UIColor(hue: 0.4, saturation: 0.5, brightness: brightness * 0.85, alpha: 1.0)
        case "sky":
            stack.backgroundColor = UIColor(hue: 0.55, saturation: 0.4, brightness: brightness * 0.7, alpha: 1.0)
        case "lavenderGray":
            stack.backgroundColor = UIColor(hue: 0.6, saturation: 0.3, brightness: brightness * 0.75, alpha: 1.0)
        case "plum":
            stack.backgroundColor = UIColor(hue: 0.7, saturation: 0.4, brightness: brightness * 0.6, alpha: 1.0)
        case "roseGray":
            stack.backgroundColor = UIColor(hue: 0.83, saturation: 0.3, brightness: brightness * 0.85, alpha: 1.0)
        case "peach":
            stack.backgroundColor = UIColor(hue: 0.05, saturation: 0.5, brightness: brightness * 1.0, alpha: 1.0)
            
        default:
            if !(stack is UIStackView) { break }
            // check if darkmode
            if self.traitCollection.userInterfaceStyle == .dark {
                stack.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
            } else {
                stack.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            }
        }
    }
    
    // MARK: - update infolable
    @objc func updateInfoLabel() {
        self.infoLabel.text = "Score: \(self.defaults?.integer(forKey: "Score") ?? 0)\nMax: \(self.defaults?.integer(forKey: "MaxScore") ?? 0)\n\(String(format: "Reset-Chance: %.0f%%", (self.defaults?.double(forKey: "ResetChance") ?? 0.0) * 100))"
    }
}
