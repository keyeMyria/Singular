//
//  AnimationFrames.swift
//  Singular
//
//  Created by dlr4life on 8/25/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit

class AnimationFrames {
    
    class func createFrames() -> [UIImage] {
        
        // Setup "Now Playing" Animation Bars
        var animationFrames = [UIImage]()
        for i in 0...3 {
            if let image = UIImage(named: "NowPlayingBarsBlack-\(i)") {
                animationFrames.append(image)
            }
        }
        
        for i in stride(from: 2, to: 0, by: -1) {
            if let image = UIImage(named: "NowPlayingBarsBlack-\(i)") {
                animationFrames.append(image)
            }
        }
        return animationFrames
    }
    
}
