//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Peter on 2017/3/5.
//  Copyright © 2017年 Peter. All rights reserved.
//

import SpriteKit
import AVFoundation
//import GameplayKit



enum 图层:CGFloat{
     case 背景
     case 障碍物层
     case 前景
     case 游戏角色
}

class GameScene: SKScene {
    
    let k前景地面数 = 2
    let k地面移动速度 = -150.0
    
    
    let k重力:CGFloat = -1500.0
    let  k上冲速度:CGFloat = 400.0
    
    let k底部障碍物最小乘数:CGFloat=0.1
    
    let k底部障碍物最大乘数:CGFloat=0.1
    
    var 速度 = CGPoint.zero
    
    
    let 世界单位=SKNode()
    var 游戏区域起始点:CGFloat=0
    var 游戏区域的高度:CGFloat=0
    let 主角 = SKSpriteNode(imageNamed:"Bird0")
    
    var 上一次更新时间:TimeInterval = 0
    
    var dt:TimeInterval = 0
    
    let 拍打的音效=SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
    
    var player: AVAudioPlayer?
    
    func 播放主角飞一下声音() {
        let url = Bundle.main.url(forResource: "flapping", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url);
            guard let player = player else { return }
            
            player.prepareToPlay();
            player.play();
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func didMove(to view: SKView) {
        
        addChild(世界单位)
        
        设置背景();
        
        设置前景();
        
        设置主角();
        
        生成障碍物();
        
        
    }
    
    func  设置背景(){
        //let texture = SKTexture(imageNamed:"Background");
        
        let 背景=SKSpriteNode(imageNamed: "Background" );
        
        背景.anchorPoint = CGPoint(x: 0.5, y: 1.0);
        
        背景.position = CGPoint(x: size.width/2, y: size.height);
        
        背景.zPosition = 图层.背景.rawValue;
        
        
        世界单位.addChild(背景);
        
        游戏区域起始点 = size.height-背景.size.height;
        游戏区域的高度 = 背景.size.height;

        
    }
    func  设置主角(){
        
        主角.position = CGPoint(x: size.width*0.2, y: 游戏区域的高度*0.4+游戏区域起始点);
        主角.zPosition = 图层.游戏角色.rawValue;
        世界单位.addChild(主角);
        
        
    }
    
    func  设置前景(){
        for i in 0..<k前景地面数 {
        let 前景=SKSpriteNode(imageNamed: "Ground" );
        前景.anchorPoint = CGPoint(x: 0, y: 1.0);
        前景.position = CGPoint(x: CGFloat(i) * 前景.size.width, y: 游戏区域起始点);
        前景.zPosition=图层.前景.rawValue;
        前景.name="前景";
        世界单位.addChild(前景);
        
        }
        
    }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            主角飞一下()
            
        }
    
    func 创建障碍物(图片名:String )->SKSpriteNode{
        let 障碍物=SKSpriteNode(imageNamed: 图片名);
        障碍物.zPosition=图层.障碍物层.rawValue;
        return 障碍物;

    
    }
    
    func 生成障碍物(){
        let 底部障碍=创建障碍物(图片名: "CactusBottom")
        let 起始X坐标=size.width/2
        let y坐标最小值=(游戏区域起始点 - 底部障碍.size.height/2) + 游戏区域的高度 * k底部障碍物最小乘数
        let y坐标最大值=(游戏区域起始点 - 底部障碍.size.height/2) + 游戏区域的高度 * k底部障碍物最大乘数

        let y坐标=CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (y坐标最大值 - y坐标最小值) + y坐标最小值;

        底部障碍.position=CGPoint(x:起始X坐标,y:y坐标)
        世界单位.addChild(底部障碍)
        
        
    }
    
    
       func  主角飞一下(){
        速度 = CGPoint(x:0,y:k上冲速度);
        播放主角飞一下声音();
       }
    
        override func update( _ 当前时间: TimeInterval) {
            if 上一次更新时间>0{
                dt = 当前时间 - 上一次更新时间;
            }else{
            
              dt=0
            }
            上一次更新时间=当前时间;
            
            更新主角();
            更新前景();
        }
    
    
    func 更新主角(){
        let 加速度 = CGPoint(x:0,y:k重力)
        速度 = 速度 + 加速度 * CGFloat(dt)
        主角.position = 主角.position + 速度 * CGFloat(dt)
        
        //检测撞地
        if((主角.position.y - 主角.size.height/2)<游戏区域起始点){
            主角.position=CGPoint(x:主角.position.x,y:游戏区域起始点+主角.size.height/2)
        }
    }
    
    
    func 更新前景(){
        
        世界单位.enumerateChildNodes(withName: "前景") { (匹配单位, stop) in
            if let 前景 = 匹配单位 as? SKSpriteNode {
            let 地面移动速度 = CGPoint(x: self.k地面移动速度, y: 0)
            前景.position += 地面移动速度 * CGFloat(self.dt)
                if 前景.position.x < -前景.size.width{
                    前景.position += CGPoint(x:前景.size.width*CGFloat(self.k前景地面数),y:0)
                
                }
            
            
            }
        }
    }
    
    
   
    
    
    
  
    
    
    
    
    
//    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//   
//    
//    func touchDown(atPoint pos : CGPoint) {
//      
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//       
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        
//    }
//    
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
    
    

}
