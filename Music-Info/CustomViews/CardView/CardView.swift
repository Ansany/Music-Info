//
//  CardView.swift
//  Music-Info
//
//  Created by Andrey Alymov on 20.10.2021.
//

import UIKit

class CardView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.shadowColor = UIColor.blue.cgColor
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.cornerRadius = 10
    }
    
}
