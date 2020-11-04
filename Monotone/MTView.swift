//
//  MTView.swift
//  Monotone
//
//  Created by Xueliang Chen on 2020/11/3.
//

import UIKit

class MTView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.buildSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal func buildSubviews(){
        
    }
    
}
