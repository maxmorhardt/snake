//
//  GameScene.swift
//  GameController
//
//  Created by Max Morhardt on 3/24/20.
//  Copyright © 2020 Max Morhardt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Game Controller Sprites
    private var up = SKSpriteNode(imageNamed: "arrow_right")
    private var down = SKSpriteNode(imageNamed: "arrow_right")
    private var left = SKSpriteNode(imageNamed: "arrow_right")
    private var right = SKSpriteNode(imageNamed: "arrow_right")
    
    // Positional Animation
    private var squareSize = CGFloat(30) // size of the width/height of one snake piece
    
    // properties
    var model = Snake()  // model
    var food = SKShapeNode.init(rectOf: CGSize(width: 40, height: 40)) // food
    var continueGame = true // if true the game continues
    var fps = 3 // starting frames per second
    
    // Called once when the scene is loaded
    override func didMove(to view: SKView) {
        
        // adjusts framerate
        self.view?.preferredFramesPerSecond = fps
        
        // up sprite
        up.position = CGPoint(x: frame.midX, y: 300)
        up.scale(to: CGSize(width: 120, height: 120))
        up.zRotation = CGFloat.pi / 2.0
        up.name = "up"
        addChild(up)
        
        // down sprite
        down.position = CGPoint(x: frame.midX, y: 100)
        down.scale(to: CGSize(width: 120, height: 120))
        down.zRotation = 3.0 * CGFloat.pi / 2.0
        down.name = "down"
        addChild(down)
        
        // left sprite
        left.position = CGPoint(x: frame.midX - 100, y: 200)
        left.scale(to: CGSize(width: 120, height: 120))
        left.zRotation = CGFloat.pi
        left.name = "left"
        addChild(left)
        
        // right sprite
        right.position = CGPoint(x: frame.midX + 100, y: 200)
        right.scale(to: CGSize(width: 120, height: 120))
        right.zRotation = 0.0
        right.name = "right"
        addChild(right)
    
        // adds the snake head in the middle to begin
        model.head.position = CGPoint(x: frame.midX, y: frame.midY)
        model.head.fillColor = .red
        model.head.strokeColor = .red
        model.head.isAntialiased = true
        addChild(model.head)
        
        // adds food
        moveFood() // randomly places it
        food.fillColor = .blue
        food.strokeColor = .blue
        food.isAntialiased = true
        addChild(food)
        
    }
    
    // changes the direction based on which touchNode is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchNode = self.atPoint(touchPosition)
            
            if touchNode.name == "up" {
                model.changeDirection(Direction: "up")
            } else if touchNode.name == "down" {
                model.changeDirection(Direction: "down")
            } else if touchNode.name == "left" {
                model.changeDirection(Direction: "left")
            } else if touchNode.name == "right" {
                model.changeDirection(Direction: "right")
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // called every frame
    override func update(_ currentTime: TimeInterval) {
        
        // first checks to see if the snake has hit itself or the wall
        // if the game can continue the snake moves
        // if you hit food then a segment is added the food moves to a new location and the game speeds up
        // if the game is over then it displays "game over" and the score
        
        let gameScene = GameScene()
        
        didHitSelf()
        didHitWall()
        if continueGame {
            model.update(scene: gameScene)
            if didHitFood() {
                addChild(model.grow(scene: gameScene))
                moveFood()
                speedUp()
            }
        } else {
            gameOver()
        }
        
    }
    
    // moves the food randomly inside the playable area
    func moveFood() {
        
        food.position = CGPoint(x: Int.random(in: 40..<Int(frame.maxX)-40), y: Int.random(in: 440..<Int(frame.maxY)-40))
        
    }
    
    // returns true if the head touches any part of the food square
    func didHitFood() -> Bool {
        
        // x and y's of the head and food
        let headX = model.head.position.x
        let headY = model.head.position.y
        let foodX = food.position.x
        let foodY = food.position.y
        
        if headX + squareSize >= foodX && headX <= foodX + 40 && headY + squareSize >= foodY && headY <= foodY + 40 {
            return true
        }
        return false
        
    }
    
    // discontinues the game if the head of the snake hits the wall
    func didHitWall() {
        
        if model.direction == .up {
            let yPos = model.head.position.y + squareSize
            if yPos > frame.maxY - squareSize {
                continueGame = false
            }
        } else if model.direction == .down {
            let yPos = model.head.position.y - squareSize
            if yPos < 400 + squareSize {
                continueGame = false
            }
        } else if model.direction == .left {
            let xPos = model.head.position.x - squareSize
            if xPos < squareSize {
                continueGame = false
            }
        } else if model.direction == .right {
            let xPos = model.head.position.x + squareSize
            if xPos > frame.maxX - squareSize {
                continueGame = false
            }
        }
        
    }
    
    // discontinues game if the hits any part of the body
    func didHitSelf() {
        
        // x and y's of the head
        let headX = model.head.position.x
        let headY = model.head.position.y
        
        if model.snake.count > 1 {
            for i in 1..<model.snake.count {
                
                let currSquare = model.snake[i]
                let currSquareX = currSquare.position.x
                let currSquareY = currSquare.position.y
                
                if headX + squareSize > currSquareX && headX < currSquareX + squareSize && headY + squareSize > currSquareY && headY < currSquareY + squareSize {
                    continueGame = false
                }
            }
        }
        
    }
    
    // speeds up the game by adding to the frames per second (fps)
    func speedUp() {
        self.view?.preferredFramesPerSecond = fps + 1
    }
    
    // is called once the game ends to display a game over label and the score
    func gameOver() {
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        let scoreLabel = SKLabelNode(text: "Score: " + String(model.snake.count))
        
        gameOverLabel.fontSize = CGFloat(100)
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY+200)
        
        scoreLabel.fontSize = CGFloat(100)
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)

        addChild(gameOverLabel)
        addChild(scoreLabel)
        
    }
    
}
