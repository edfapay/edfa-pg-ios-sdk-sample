//
//  ExpressPayRadioButton.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit

final class ExpressPayRadioButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        tintColor = .blue
    }
}

final class ExpressPayRadioButtonContainer {
    
    var selectedButton: ExpressPayRadioButton? {
        didSet {
            if oldValue != selectedButton { didSelectButton?(selectedButton) }
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            if oldValue != selectedIndex { didSelectIndex?(selectedIndex) }
        }
    }
    
    var didSelectButton: ((ExpressPayRadioButton?) -> Void)?
    var didSelectIndex: ((Int?) -> Void)?
    
    var canUnselect: Bool = false
    
    private var buttons: [ExpressPayRadioButton] = []
    
    init(_ buttons: ExpressPayRadioButton...) {
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
    
    func selectButton(_ button: ExpressPayRadioButton?) {
        buttons.forEach { $0.isSelected = false }
        button?.isSelected = true
        
        selectedButton = button
        selectedIndex = buttons.firstIndex(where: { $0 == button })
    }
    
    @objc private func buttonAction(_ sender: ExpressPayRadioButton) {
        if canUnselect && sender == selectedButton { selectButton(nil) }
        else { selectButton(sender) }
    }
}
