//
//  UIViewController+Extention.swift
//  Evaluation Test (Fora Soft)
//
//  Created by Andrey Alymov on 22.10.2021.
//

import UIKit

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}
