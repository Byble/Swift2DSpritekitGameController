//
//  ControllerViewController.swift
//  KongGaRuController
//
//  Created by 김민국 on 2018. 9. 19..
//  Copyright © 2018년 MGHouse. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class ControllerViewController: UIViewController {
    
    let controllService = ControllerService()
    @IBOutlet var moveLeftBtn: UIButton!
    @IBOutlet var moveRightBtn: UIButton!
    @IBOutlet var jumpBtn: UIButton!
    @IBOutlet var connectionsLabel: UILabel!
    @IBOutlet var attackBtn: UIButton!
    @IBOutlet var skillBtn: UIButton!
    @IBOutlet var transformBtn: UIButton!
    
    var sUiV: UIView!
    
    var dBtn: UIButton!
    var uBtn: UIButton!
    var xBtn: UIButton!
    var sBtn: UIButton!
    
    var atkSeconds = 1.0
    var atkTimer = Timer()
    var attack1 = false
    var attack2 = false
    var attack3 = false
    
    var delaySeconds = 0.8
    
    var skillTimer = Timer()
    var skillDelaySec = 10.0
    
    var startX: CGFloat = 0
    var startY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllService.delegate = self
        
        moveLeftBtn.addTarget(self, action: #selector(leftBtnUp), for: [.touchUpInside, .touchUpOutside])
        moveRightBtn.addTarget(self, action: #selector(rightBtnUp), for: [.touchUpInside, .touchUpOutside])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.transformBtn.setBackgroundImage(UIImage(named: "trans_cat.png"), for: .normal)
    }
    @objc func leftSend(){
        controllService.send(buttonName: "L")
    }
    @objc func leftUpSend(){
        controllService.send(buttonName: "LUp")
    }
    @objc func rightSend(){
        controllService.send(buttonName: "R")
    }
    @objc func rightUpSend(){
        controllService.send(buttonName: "RUp")
    }
    @objc func jumpSend(){
        controllService.send(buttonName: "Jp")
    }
    @objc func dashSend(){
        controllService.send(buttonName: "D")
    }
    @objc func transformSend(){
        controllService.send(buttonName: "T")
    }
    
    @objc func attackSend(){
        controllService.send(buttonName: "A")
    }
    
    @objc func attackSend1(){
        controllService.send(buttonName: "A1")
        attack1 = true
    }
    @objc func attackSend2(){
        controllService.send(buttonName: "A2")
        attack2 = true
    }
    @objc func attackSend3(){
        controllService.send(buttonName: "A3")
        attack3 = true
    }
    @objc func skillSend(){
        controllService.send(buttonName: "S")
    }
    @objc func skillEndSend(){
        controllService.send(buttonName: "HSF")
    }
    @objc func shotSniper(){
        controllService.send(buttonName: "HSG")
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(cancelSniperUI), userInfo: nil, repeats: false)
    }
    @objc func zoomUp(){
        controllService.send(buttonName: "HSU")
    }
    @objc func zoomDown(){
        controllService.send(buttonName: "HSD")
    }
    func runTimer(){
        atkTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer(){
        if (atkSeconds > 0){
            atkSeconds -= 0.1
        }else{
            attack1 = false
            attack2 = false
            attack3 = false
            atkTimer.invalidate()
            atkSeconds = 1
        }
    }
    
    func setSkillTimer(){
        skillTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSkillTimer), userInfo: nil, repeats: true)
    }
    @objc func updateSkillTimer(){
        if (skillDelaySec > 0){
            skillDelaySec -= 1
        }else{
            skillTimer.invalidate()
            skillDelaySec = 10
            skillBtn.backgroundColor = UIColor.clear
            skillBtn.isEnabled = true
        }
    }
    
    func delayTimer(){
        atkTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateDelay), userInfo: nil, repeats: true)
    }
    @objc func updateDelay(){
        if (delaySeconds > 0){
            delaySeconds -= 0.1
        }else{
            attack1 = false
            attack2 = false
            attack3 = false
            atkTimer.invalidate()
            delaySeconds = 0.8
        }
    }
    
}

extension ControllerViewController {
    @IBAction func leftBtnDown(_ sender: Any) {
        leftSend()
    }
    @objc func leftBtnUp(){
        leftUpSend()
    }
    
    @IBAction func rightBtnDown(_ sender: Any) {
        rightSend()
    }
    
    @objc func rightBtnUp(){
        rightUpSend()
    }
    
    @IBAction func jumpBtnDown(_ sender: Any) {
        jumpSend()
    }
    
    @IBAction func dashBtnDown(_ sender: Any) {
        dashSend()
    }
    @IBAction func transformBtnDown(_ sender: Any) {
        transformSend()
    }
    @IBAction func attackBtnDown(_ sender: Any) {
        if !attack1{
            attackSend1()
            
            atkTimer.invalidate()
            atkSeconds = 0.5
            
            runTimer()
        }else if !attack2{
            if(atkSeconds > 0){
                attackSend2()
                
                atkTimer.invalidate()
                atkSeconds = 1
                
                runTimer()
            }
        }else if !attack3{
            if (atkSeconds > 0){
                attackSend3()
                
                atkTimer.invalidate()
                atkSeconds = 1
                delayTimer()
                attackBtn.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.attackBtn.isEnabled = true
                }
            }
        }
    }
    @IBAction func skillBtnDown(_ sender: Any) {
        skillSend()
        setSkillTimer()
        skillBtn.backgroundColor = UIColor.red
        skillBtn.isEnabled = false
    }
}

extension ControllerViewController{ //Sniper UI
    
    func makeSniperUI(){
        sUiV = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        sUiV.center = self.view.center
        
        let backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: sUiV.frame.width, height: sUiV.frame.height))
        backImage.center = sUiV.center
        backImage.image = UIImage(named: "grid.png")
        
        dBtn = UIButton(frame: CGRect(x: sUiV.frame.minX+50, y: 100, width: 60, height: 60))
        uBtn = UIButton(frame: CGRect(x: sUiV.frame.minX+50, y: 200, width: 60, height: 60))
        xBtn = UIButton(frame: CGRect(x: sUiV.frame.maxX-120, y: 20, width: 60, height: 60))
        sBtn = UIButton(frame: CGRect(x: sUiV.frame.maxX-180, y: sUiV.frame.maxY-160, width: 120, height: 120))
        
        xBtn.addTarget(self, action: #selector(cancelSniperUI), for: .touchUpInside)
        xBtn.setBackgroundImage(UIImage(named: "close.png"), for: .normal)
        
        sBtn.addTarget(self, action: #selector(shotSniper), for: .touchUpInside)
        sBtn.setBackgroundImage(UIImage(named: "shoot.png"), for: .normal)
        
        uBtn.addTarget(self, action: #selector(zoomUp), for: .touchUpInside)
        uBtn.setBackgroundImage(UIImage(named: "minus.png"), for: .normal)
        
        dBtn.addTarget(self, action: #selector(zoomDown), for: .touchUpInside)
        dBtn.setBackgroundImage(UIImage(named: "plus.png"), for: .normal)
        
        sUiV.addSubview(backImage)
        sUiV.addSubview(xBtn)
        sUiV.addSubview(sBtn)
        sUiV.addSubview(uBtn)
        sUiV.addSubview(dBtn)
        self.view.addSubview(sUiV)
    }
    @objc func cancelSniperUI(){
        skillEndSend()
        sUiV.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: sUiV)
        startX = (location?.x)!
        startY = (location?.y)!
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: sUiV)
        let tmpX = location!.x - startX
        let tmpY = location!.y - startY
        
        controllService.send(buttonName: "\(tmpX),\(tmpY)")
    }
}
extension ControllerViewController : ControllerServiceDelegate {
    func buttonChanged(manager: ControllerService, changedBtn: String) {
        OperationQueue.main.addOperation {
            switch changedBtn{
            case "HSS":
                self.makeSniperUI()
            case "MV":
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            case "TC":
                DispatchQueue.main.async {
                    self.transformBtn.setBackgroundImage(UIImage(named: "trans_h.png"), for: .normal)
                }
            case "TH":
                DispatchQueue.main.async {
                    self.transformBtn.setBackgroundImage(UIImage(named: "trans_cat.png"), for: .normal)
                }
            default:
                break
            }
        }
    }
    
    func connectedDevicesChanged(manager: ControllerService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = connectedDevices.first
        }
    }
}
