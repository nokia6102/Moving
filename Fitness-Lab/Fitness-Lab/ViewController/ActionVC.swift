//
//  ActionVC.swift
//  Fitness-Lab
//
//  Created by 張書涵 on 2018/9/21.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import UIKit
import YouTubePlayer_Swift
import AVFoundation

class ActionVC: UIViewController {
    var actionTimer: Timer?
    var actionSec = 30
    var restTimer: Timer?
    var restSec = 10
    var nowIndex = 0
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoView: YouTubePlayerView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var intensityLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var actionTableView: UITableView!
    
    var lists =  [ListModel]()
    var actionLists = [ActionModel]()
    var selectSender = 0
    
    func initList(category: FitnessCategory){
        lists = Data.instance.getList(forListTitle: category.secondTitle)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        print(lists)
        print(actionLists)
        videoView.isHidden = true
        self.videoView.delegate = self
        activityIndicator.isHidden = true
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        videoView.isHidden = false
        videoView.playerVars = ["playsinline": 1 as AnyObject]
        videoView.loadVideoID(lists[selectSender].videoID)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
    }
    
    @objc func actionCountDown(){
        let indexPath = IndexPath(row: nowIndex, section: 0)
        guard let cell = self.actionTableView.cellForRow(at: indexPath) as? ActionCell  else {return}
       
        actionSec -= 1
        cell.timeDescription.text = "0:\(actionSec)"
        if actionSec == 0 {
                actionTimer?.invalidate()
                actionSec = 0
                if nowIndex < actionLists.count-1 {
                    cell.timeDescription.text = "✓"
                    nowIndex += 1
                    print("nowIndex:\(nowIndex),\(actionLists.count-1)")
                    restSec = Int(actionLists[nowIndex].restTime!)
                    self.renewVideo()
                    self.restTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.restCountDown), userInfo: nil, repeats: true)
                    print("休息時間！")
                }else{
                    videoView.pause()
                    print("做完囉要去下一頁了")
                   // indexpath都跑完了
                }
        }
    }
    
    
    @objc func restCountDown(){
        
        let indexPath = IndexPath(row: nowIndex, section: 0)
        guard let cell = self.actionTableView.cellForRow(at: indexPath) as? ActionCell  else {return}
        restSec -= 1
        cell.timeDescription.text = "0:\(restSec)"
        cell.actionDescription.text = "休息時間"
        if restSec == 0 {
            cell.actionDescription.text = actionLists[nowIndex].actionDescription
            restTimer?.invalidate()
            actionSec = Int(lists[selectSender].actionModel[nowIndex].timesDescription)
            self.actionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.actionCountDown), userInfo: nil, repeats: true)
            }
        }
    
    func renewVideo(){
        var floatYoutubeTime = Float(actionLists[nowIndex].youtubeTime)
        videoView.seekTo(floatYoutubeTime, seekAhead: true)
        let youtubestopTime = actionLists[nowIndex].stopTime
        DispatchQueue.main.asyncAfter(deadline: .now() + youtubestopTime!) {
            self.videoView.seekTo(Float(self.actionLists[self.nowIndex].youtubeTime), seekAhead: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + youtubestopTime!) {
                self.videoView.seekTo(Float(self.actionLists[self.nowIndex].youtubeTime), seekAhead: true)
            }
            
        }
        
    }
    
    
        
//        if nowIndex <= actionLists.count{
//            nowIndex += nowIndex
//            print("nowIndex:\(nowIndex),actionLists.count:\(actionLists.count)")
//
//            //現在運動的的cell
//            let indexPath = IndexPath(row: nowIndex, section: 0)
//            guard let cell = self.actionTableView.cellForRow(at: indexPath) as? ActionCell  else {return}
//            print(indexPath)
//
//
//            //現在的時間播放youtube
//            videoView.seekTo(Float(actionLists[nowIndex].youtubeTime), seekAhead: true)
//            //超過stoptime回放
//            let youtubestopTime = actionLists[nowIndex].stopTime
//            DispatchQueue.main.asyncAfter(deadline: .now() + youtubestopTime!) {
//                self.videoView.seekTo(Float(self.actionLists[self.nowIndex].youtubeTime), seekAhead: true)
//            }
//
//            //遞減的actionSec與UI
//            actionSec -= 1
//            cell.timeDescription.text = "0:\(restSec)"
//            if actionSec == 0 {
//                actionTimer?.invalidate()
//            }
        

    
    
 
    
     func actionTime(){
        
        //播影片
//        let floatYoutubeTime = Float(actionLists[nowIndex].youtubeTime) ?? 0
//        videoView.seekTo(floatYoutubeTime, seekAhead: true)
        let youtubestopTime = actionLists[nowIndex].stopTime
        print(youtubestopTime)
        DispatchQueue.main.asyncAfter(deadline: .now() + youtubestopTime!) {
            self.videoView.seekTo(Float(self.actionLists[self.nowIndex].youtubeTime), seekAhead: true)
        }
        
        //現在運動的的cell
        let indexPath = IndexPath(row: nowIndex, section: 0)
        guard let cell = self.actionTableView.cellForRow(at: indexPath) as? ActionCell  else {return}
        
        //抓到cell的action時間
        //actionSec = Int(actionLists[nowIndex].timesDescription)
        
        
        
        //遞減的actionSec與UI
        actionSec -= 1
        cell.timeDescription.text = "0:\(actionSec)"
        //在actionSec==0時判斷是否有休息時間
        if actionSec == 0 {
            if actionLists[nowIndex].restTime != nil{
                actionTimer?.invalidate()
                cell.timeDescription.text = "完成"
                //設定restTime
                restSec = Int(actionLists[nowIndex+1].restTime!)
                print("restSec:\(restSec)")
               // self.restTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.restTime), userInfo: nil, repeats: true)
            }else{
                //沒有休息時間
                //跳轉頁面
            }

        }
    }
}
    

    
    
    



extension ActionVC: UITableViewDelegate{}

extension ActionVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return actionLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = actionTableView.dequeueReusableCell(withIdentifier: "ActionCell") as? ActionCell{
            
            actionSec = Int(lists[selectSender].actionModel[0].timesDescription)
            
            let listIndex = lists[selectSender]
            startBtn.clipsToBounds = true
            startBtn.layer.cornerRadius = 50
            videoTitle.text = listIndex.videoTitle
            videoImg.image = UIImage(named: listIndex.videoImg)
            intensityLbl.text = listIndex.intensity
            durationLbl.text = "\(listIndex.durationLbl)min"
            let actionlist = actionLists[indexPath.row]
            cell.updateView(actionModel: actionlist)
            cell.selectionStyle = .none
            return cell
            
        }else{
            
            return ActionCell()
        }
    }
}


//swiftlint:disable identifier_name
extension ActionVC: YouTubePlayerDelegate {
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {

        if playerState == .Playing{
        
        }
        
        if playerState == .Ended{
            print("完成之後跳這")
        }
        

        func start(){
            
        }
        
        func countDown(){
            
        }
        
        
    }
    
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        activityIndicator.isHidden = true
        let floatYoutubeTime = Float(actionLists[nowIndex].youtubeTime) ?? 0
        videoPlayer.seekTo(floatYoutubeTime, seekAhead: true)
        self.actionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.actionCountDown), userInfo: nil, repeats: true)
        
        let youtubestopTime = actionLists[nowIndex].stopTime
        DispatchQueue.main.asyncAfter(deadline: .now() + youtubestopTime!) {
            self.videoView.seekTo(Float(self.actionLists[self.nowIndex].youtubeTime), seekAhead: true)
        }

    }
}
