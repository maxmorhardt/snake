//
//  Snake.swift
//  GameController
//
//  Created by Max Morhardt on 3/31/20.
//  Copyright © 2020 Max Morhardt. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class Snake {
    
    // properties
    var snake: [SKShapeNode] = [] // the full snake
    var head: SKShapeNode // the top of the snake
    var squareSize = CGFloat(30) // size of the width/height of one snake segment
    
    enum CurrDirection {
        case up
        case down
        case left
        case right
    }
    
    var direction = CurrDirection.up // starts the snake moving up
    
    // initializer
    init() {
        
        snake.append(SKShapeNode.init(rectOf: CGSize(width: 30, height: 30))) // snake starts with one element
        head = snake[0] // sets the head to the first element of the snake
        
    }
    
    // changes the direction of the snake
    func changeDirection(Direction: String) {
        if Direction == "up" {
            direction = .up
        } else if Direction == "down" {
            direction = .down
        } else if Direction == "left" {
            direction = .left
        } else if Direction == "right" {
            direction = .right
        }
    }
    
    // moves the top of the snake based on the direction
    func moveHead() {

        if direction == .up {
            let yPos = head.position.y + squareSize
            head.position.y = yPos
        } else if direction == .down {
            let yPos = head.position.y - squareSize
            head.position.y = yPos
        } else if direction == .left {
            let xPos = head.position.x - squareSize
            head.position.x = xPos
        } else if direction == .right {
            let xPos = head.position.x + squareSize
            head.position.x = xPos
        }
        
    }
    
    // moves each part of the body to the position of the previous part
    func moveBody(prev: [CGPoint]) {
        
        if snake.count > 1 {
            for i in 1..<snake.count {
                snake[i].position = prev[i-1]
            }
        }
        
    }
    
    // adds a segment to the snake and returns a shape node to be placed in the game scene
    func grow(scene: GameScene) -> SKShapeNode {
        
        snake.append(SKShapeNode.init(rectOf: CGSize(width: 30, height: 30)))
        
        let newSegment = snake[snake.count-1]
        let previousSegment = snake[snake.count-2]
        
        // puts the new segment directly behind the last one
        if direction == .up {
            newSegment.position = CGPoint(x: previousSegment.position.x, y: previousSegment.position.y - squareSize)
        } else if direction == .down {
            newSegment.position = CGPoint(x: previousSegment.position.x, y: previousSegment.position.y + squareSize)
        } else if direction == .left {
            newSegment.position = CGPoint(x: previousSegment.position.x + squareSize, y: previousSegment.position.y)
        } else if direction == .right {
            newSegment.position = CGPoint(x: previousSegment.position.x - squareSize, y: previousSegment.position.y)
        }
        
        // alternates red and green color
        if snake.count % 2 == 0 {
            newSegment.fillColor = .green
            newSegment.strokeColor = .green
        } else {
            newSegment.fillColor = .red
            newSegment.strokeColor = .red
        }
        
        newSegment.isAntialiased = true
        return newSegment
        
    }
    
    // moves the head and body of the snake
    func update(scene: GameScene) {
        
        // gathers previous locations of all segments of the snake to move the body
        var previous: [CGPoint] = []
        if snake.count > 1 {
            for i in 0..<snake.count {
                previous.append(snake[i].position)
            }
        }
        
        moveHead()
        moveBody(prev: previous)
        
    }
    
}
