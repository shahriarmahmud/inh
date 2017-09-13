//
//  BackgroundGradient.swift
//  BlockChainsMyMerchant
//
//  Created by Shahriar Mahmud on 8/20/17.
//  Copyright © 2017 Shahriar Mahmud. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func dashboardBackground() -> CAGradientLayer{
        let topColor = UIColor(red: (39/255.0), green: (42/255.0), blue: (102/255.0), alpha: 1)
        let bottomColor = UIColor(red: (20/255.0), green: (22/255.0), blue: (36/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        return gradientLayer
    }
}
