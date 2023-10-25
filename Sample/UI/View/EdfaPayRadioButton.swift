//
//  EdfaPgRadioButton.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit

final class EdfaPayRadioButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        tintColor = UIColor.init(named: "primary")
    }
}

final class EdfaPgRadioButtonContainer {
    
    var selectedButton: EdfaPayRadioButton? {
        didSet {
            if oldValue != selectedButton { didSelectButton?(selectedButton) }
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            if oldValue != selectedIndex { didSelectIndex?(selectedIndex) }
        }
    }
    
    var didSelectButton: ((EdfaPayRadioButton?) -> Void)?
    var didSelectIndex: ((Int?) -> Void)?
    
    var canUnselect: Bool = false
    
    private var buttons: [EdfaPayRadioButton] = []
    
    init(_ buttons: EdfaPayRadioButton...) {
        self.buttons = buttons
        self.buttons.forEach { $0.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside) }
        
        if let superview = buttons.first?.superview, let supersuperview = superview.superview {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .groupTableViewBackground
            backgroundView.layer.cornerRadius = 10
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            supersuperview.insertSubview(backgroundView, belowSubview: superview)
            
            NSLayoutConstraint.activate([
                backgroundView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                backgroundView.topAnchor.constraint(equalTo: superview.topAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
    }
    
    func selectButton(at index: Int) {
        selectButton(buttons[index])
    }
    
    func selectButton(_ button: EdfaPayRadioButton?) {
        buttons.forEach { $0.isSelected = false }
        button?.isSelected = true
        
        selectedButton = button
        selectedIndex = buttons.firstIndex(where: { $0 == button })
    }
    
    @objc private func buttonAction(_ sender: EdfaPayRadioButton) {
        if canUnselect && sender == selectedButton { selectButton(nil) }
        else { selectButton(sender) }
    }
}
