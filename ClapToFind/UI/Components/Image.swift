//
//  Image.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/17/21.
//

import UIKit


public class ImageView: UIImageView {
    
    enum Image {
        case clapping
        case ringingPhone
        case clappingAndPhone
        case problem
        case rating
    }
    
    init(image: Image) {
        super.init(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
        
        sizeToFit()
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        
        switch image {
        case .clapping:
            self.image = UIImage(named: "Clapping")
        case .ringingPhone:
            self.image = UIImage(named: "RingingPhone")
        case .clappingAndPhone:
            self.image = UIImage(named: "ClappingAndPhone")
        case .problem:
            self.image = UIImage(named: "Problem")
        case .rating:
            self.image = UIImage(named: "Rating")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
