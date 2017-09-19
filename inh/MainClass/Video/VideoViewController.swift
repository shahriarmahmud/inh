//
//  VideoViewController.swift
//  inh
//
//  Created by Priom on 9/18/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoViewController: UIViewController,YouTubePlayerDelegate{
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    var videoId = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.landscapeRight)
        print(videoId)
//        videoPlayer.loadVideoID("pUFiDOQr_j0")
        videoPlayer.loadVideoID(videoId)
        // Do any additional setup after loading the view.
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
