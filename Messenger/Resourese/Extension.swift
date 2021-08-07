//
//  Extencion.swift
//  Messenger
//
//  Created by Паша Шарков on 28.07.2021.
//

import Foundation
import UIKit


extension UIView {
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var hight: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
        print("scrolled to bottom called")
    }
}
