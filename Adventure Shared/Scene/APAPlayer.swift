//
//  APAPlayer.swift
//  Adventure
//
//  Created by Reid Ellis on 2020-12-17.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import GameController

class APAPlayer: NSObject {
    @objc var hero: APAHeroCharacter?
    @objc var heroClass: AnyClass = APAWarrior.self
    
    @objc var moveForward = false
    @objc var moveLeft = false
    @objc var moveRight = false
    @objc var moveBack = false
    @objc var fireAction = false
    
    @objc var heroMoveDirection = CGPoint.zero
    @objc var livesLeft: UInt8 = 0
    @objc var score: UInt32 = 0
    
    @objc var controller: GCController?
    
    @objc static let kStartLives: UInt8 = 3
    
    #if os(iOS)
    @objc var movementTouch: UITouch?
    @objc var targetLocation: CGPoint = .zero
    @objc var moveRequested = false
    #endif

    override init() {
        super.init()
        livesLeft = Self.kStartLives;
    }
}
