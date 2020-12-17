//
//  APATree.swift
//  Adventure
//
//  Created by Reid Ellis on 2020-12-17.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class APATree: APAParallaxSprite {
    @objc var fadeAlpha = false
    
    let kOpaqueDistance: CGFloat = 400

    @objc func updateAlphaWithScene(_ scene: APAMultiplayerLayeredCharacterScene) {
        guard !fadeAlpha else { return }

        var closestHeroDistance: CGFloat = .greatestFiniteMagnitude
        closestHeroDistance = scene.heroes.reduce(closestHeroDistance) {
            min($0, APADistanceBetweenPoints(position, $1.position))
        }
        if closestHeroDistance > kOpaqueDistance {
            alpha = 1
        }
        else {
            let ratio = closestHeroDistance/kOpaqueDistance
            alpha = (0.1 + ratio*ratio) * 0.9
        }
    }
}
