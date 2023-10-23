//
//  ExpressPayButton.swift
//  Sample
//
//  Created by ExpressPay(zik) on 10.03.2021.
//

import UIKit

final class ExpressPayButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = .blue
        contentEdgeInsets = .init(top: 13, left: 13, bottom: 13, right: 13)
        layer.cornerRadius = 8
        
        tintColor = .white
    }
}
