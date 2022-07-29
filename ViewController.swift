//
//  ViewController.swift
//  Scrabble
//
//  Created by Sam Lerner on 3/1/21.
//  Copyright © 2021 Sam Lerner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TileDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var rackView: RackView!
    @IBOutlet weak var cpuRackView: RackView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rowNumberView: RackView!
    @IBOutlet weak var columnNumberView: RackView!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var cpuScoreLabel: UILabel!
    
    var bag: Bag!
    var game: Game!
    
    var containers: [TileContainer]!
    
    var userPlayer: UserPlayer!
    var cpuPlayer: CPUPlayer!
    var players: [Player]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*boardView.minimumZoomScale = 1.0
        boardView.maximumZoomScale = 2.0
        boardView.contentSize = boardView.bounds.size
        boardView.clipsToBounds = true
        
        boardView.delegate = self
        
        let doubleTap = UITapGestureRecognizer(target: self,
                                               action: #selector(ViewController.boardDoubleTap(tap:)))
        
        doubleTap.numberOfTapsRequired = 2
        
        boardView.addGestureRecognizer(doubleTap)*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let showNumbers = false
        
        if showNumbers {
            let rowNumberContainer = TileContainer(dimensions: [Constants.NR], view: rowNumberView),
                colNumberContainer = TileContainer(dimensions: [Constants.NC], view: columnNumberView, orientation: 0)
            
            for i in 0..<Constants.NR {
                let tile = Tile(container: rowNumberContainer, indices: [i], text: "\(i)")
                rowNumberContainer.create(tile: tile, at: [i], interactable: false)
            }
            
            for i in 0..<Constants.NC {
                let tile = Tile(container: colNumberContainer, indices: [i], text: "\(i)")
                colNumberContainer.create(tile: tile, at: [i], interactable: false)
            }
        }
        
        let bag = Bag()
        let board = Board(boardView: boardView)
        
        game = Game(board: board, bag: bag)
        
        userPlayer = UserPlayer(game: game, rackView: rackView)
        cpuPlayer = CPUPlayer(game: game, rackView: cpuRackView)
        players = [userPlayer, cpuPlayer]
        
        myScoreLabel.text = "Me: \(userPlayer.score)"
        cpuScoreLabel.text = "CPU: \(cpuPlayer.score)"
        
        board.delegate = self
        
        for player in players {
            player.rack.delegate = self
        }
        
        containers = [board, userPlayer.rack]
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerChanged(_:)),
                                               name: Notification.Name("player-changed"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(tileCreated(_:)),
                                                name: Notification.Name("tile-created"),
                                                object: nil)
        
        game.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return boardView.contentView
    }
    
    @objc
    func playerChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:AnyObject],
              let player = userInfo["player"] as? Player
        else {
            print("Bad player notification")
            return
        }
        
        submitButton.isEnabled = player == userPlayer
    }
    
    @objc
    func tileCreated(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:AnyObject],
              let tile = userInfo["tile"] as? Tile
        else {
            print("Bad tile notification")
            return
        }
        
        var coords = game.board.view.coordinates(for: tile.idxs)
        coords.x += boardView.frame.minX
        coords.y += boardView.frame.minY

        // resize will change the origin so move it again. gross
        tile.view!.move(to: coords)
        resize(tileView: tile.view!)
        tile.view!.move(to: coords)
    }
    
    @objc
    func boardDoubleTap(tap: UITapGestureRecognizer) {
        if boardView.zoomScale == 1.0 {
            let pos = tap.location(in: boardView),
                newW = boardView.frame.width / 2.0,
                newH = boardView.frame.height / 2.0
            
            boardView.zoom(to: CGRect(x: pos.x - newW / 2.0,
                                       y: pos.y - newH / 2.0,
                                       width: newW,
                                       height: newH), animated: true)
        }
        else {
            boardView.zoom(to: CGRect(x: 0.0,
                                       y: 0.0,
                                       width: boardView.frame.width,
                                       height: boardView.frame.height), animated: true)
        }
    }
    
    @objc
    func tilePan(pan: UIPanGestureRecognizer) {
        guard let tileView = pan.view as? TileView else {
            return
        }
        
        switch pan.state {
        case .began:
            break
            
        case .changed:
            /*if let _ = tileView.container as? BoardView {
                tileView.removeFromSuperview()
                view.addSubview(tileView)
                tileView.frame = view.convert(tileView.frame, from: boardView.contentView)
            }*/
            
            tileView.translate(by: pan.translation(in: view))
            resize(tileView: tileView)
            break
            
        case .cancelled:
            reset(tileView: tileView)
            break
            
        case .ended:
            snap(tileView: tileView)
            break
            
        default:
            break
        }
    }
    
    func resize(tileView: TileView) {
        for container in containers {
            if container.view.frame.intersects(tileView.frame) && tileView.container != container.view {
                tileView.container = container.view
                tileView.resize(to: container.view.tileSize)
                break
            }
        }
    }
    
    func reset(tileView: TileView) {
        tileView.container = tileView.origContainer
        
        // Resize (if applicable) before moving the tile since resizing changes the frame's origin.
        if tileView.frame.width != tileView.container.tileSize {
            tileView.resize(to: tileView.container.tileSize)
        }
        
        tileView.move(to: tileView.origFrame.origin)
    }
    
    func snap(tileView: TileView) {
        let tile = tileView.tile!
        var tileFrame: CGRect
        
        var newFrame: CGRect? = nil,
            newIdxs: [Int]? = nil,
            newContainer: TileContainer? = nil;
        
        for tmpContainer in containers {
            if tmpContainer.view.frame.intersects(tileView.frame) {
                tileFrame = view.convert(tileView.frame, to: tmpContainer.view)
                (newIdxs, newFrame) = tmpContainer.getBestIndicesFor(tileFrame)
                
                newContainer = tmpContainer
                break
            }
        }
        
        // gross
        if newFrame != nil {
            newFrame = view.convert(newFrame!, from: tileView.container)
        }
        
        // This means that either in the board or the rack, there were no available
        // squares under the location being hovered over.
        if newIdxs == nil {
            print("No valid locations under tile")
            reset(tileView: tileView)
            return
        }
        
        // First let the old container know that there is no longer a tile at the old position.
        tile.container?.nullify(at: tile.idxs)
        
        /*if let _ = newContainer as? Board {
            newFrame = newContainer?.view.contentView.convert(newFrame!, from: view)
            tileView.removeFromSuperview()
            newContainer?.view.contentView.addSubview(tileView)
        }
        else {
            tileView.removeFromSuperview()
            view.addSubview(tileView)
        }*/
        
        // Then let the new container know that we now have a tile in the new position.
        tile.container = newContainer
        tile.idxs = newIdxs!
        tile.container?.set(tile: tile, at: tile.idxs)
        
        tileView.origFrame = newFrame
        tileView.origContainer = newContainer?.view
        tileView.move(to: tileView.origFrame.origin)
    }
    
    @IBAction func submitMove(sender: UIButton) {
        for row in 0..<game.board.dimensions[0] {
            for col in 0..<game.board.dimensions[1] {
                let ixs = [row, col]
                game.board.unhighlight(ixs)
            }
        }
 
        _ = game.submitMove()
        
        myScoreLabel.text = "Me:  \(userPlayer.score)"
        cpuScoreLabel.text = "CPU: \(cpuPlayer.score)"
    }
    
    @IBAction func recallTiles(sender: UIButton) {
        for tile in game.board.placedTiles {
            // find an open spot on the rack.
            for idx in 0..<userPlayer.rack.dimensions[0] {
                if !userPlayer.rack.indicesOccupied([idx]) {
                    tile.rackIdxs = [idx]
                    
                    var coords = rackView.coordinates(for: tile.rackIdxs!)
                    coords.x += rackView.frame.minX
                    coords.y += rackView.frame.minY
                    
                    if let tileView = tile.view {
                        tileView.move(to: coords)
                        resize(tileView: tileView)
                        tileView.move(to: coords)
                        snap(tileView: tileView)
                    }
                }
            }
        }
    }

}

