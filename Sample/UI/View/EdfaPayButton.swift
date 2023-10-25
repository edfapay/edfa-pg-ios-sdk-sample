//
//  EdfaPgButton.swift
//  Sample
//
//  Created by EdfaPg(zik) on 10.03.2021.
//

import UIKit

final class EdfaPayButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(named: "primary") // 69E2A5
        contentEdgeInsets = .init(top: 13, left: 13, bottom: 13, right: 13)
        layer.cornerRadius = 8
        
        tintColor = .white
    }
}
