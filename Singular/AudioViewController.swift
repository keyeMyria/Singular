//
//  AudioViewController.swift
//  Singular
//
//  Created by dlr4life on 8/20/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import Pastel
import Pulsar
import Crashlytics

extension Int {
    
    var toAudioString: String {
        let minutes = self / 60
        let seconds = self - minutes * 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        }
        return "\(minutes):\(seconds)"
    }
}

class AudioViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var playlistButton: UIBarButtonItem!
    @IBOutlet weak var nowPlayingItemArtworkImageView: UIImageView!
    @IBOutlet weak var trackLbl: UILabel!
    //    @IBOutlet weak var touchButton: UIButton!
    @IBOutlet var activityIndicatorViewRewind: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewPlay: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewStop: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewPause: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewNext: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewShuffle: UIActivityIndicatorView!
    @IBOutlet weak var slider = UISlider()
    @IBOutlet weak var volumeParentView: UIView!
    
    // volume adjuster object
    var mpVolumeSlider = UISlider()
    
    // audio player object
    var audioPlayer = AVAudioPlayer()
    
    // timer (used to show current track play time)
    var timer:Timer!
    
    // play list file and title list
    var playListFiles = [String]()
    var playListTitles = [String]()
    
    // total number of track
    var trackCount: Int = 0
    var elapsedTimeSeconds = 0
    // currently playing track
    var currentTrack: Int = 0
    
    // is playing or not
    var isPlaying: Bool = false
    
    var nowPlayingImageView: UIImageView!
    var playlistImageView: UIImageView!
    
    let myMusicPlayer = MPMusicPlayerController.applicationMusicPlayer()
    let myMediaQuery = MPMediaQuery.songs()
    
    // outlet - track info label (e.g. Track 1/5)
    @IBOutlet weak var trackInfo: UILabel!
    
    // outlet - play duration label
    @IBOutlet weak var playDuration: UILabel!
    
    // MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pastelView = PastelView(frame: view.bounds)
        
        // Create Now Playing BarItem
        createNowPlayingAnimation()
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 2.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red:0.21, green:0.56, blue:0.73, alpha:1.0),
                              UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        
        // Setup slider
        setupVolumeSlider()
        
        self.addRepeatingPulseToProgressIndicatorRewind()
        self.addRepeatingPulseToProgressIndicatorPlay()
        self.addRepeatingPulseToProgressIndicatorStop()
        self.addRepeatingPulseToProgressIndicatorPause()
        self.addRepeatingPulseToProgressIndicatorNext()
        self.addRepeatingPulseToProgressIndicatorShuffle()
        
        self.activityIndicatorViewRewind.startAnimating()
        self.activityIndicatorViewPlay.startAnimating()
        self.activityIndicatorViewStop.startAnimating()
        self.activityIndicatorViewPause.startAnimating()
        self.activityIndicatorViewNext.startAnimating()
        self.activityIndicatorViewShuffle.startAnimating()
        
        //        trackLbl.text = myMusicPlayer.nowPlayingItem?.title!
        //        nowPlayingItemArtworkImageView.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: nowPlayingItemArtworkImageView.bounds.size)
        //        trackInfo.text! = "Track \(String(describing: myMusicPlayer.nowPlayingItem!.albumTrackNumber))"
        //
        //        let currentTime = Int((myMusicPlayer.nowPlayingItem?.playbackDuration)!)
        //        let minutes = currentTime/60
        //        let seconds = currentTime - (minutes * 60)
        
        
        let playlistButton = UIBarButtonItem(image: UIImage(named: "playlistIcon"), style: .plain, target: self, action: #selector(AudioViewController.openPlaylist(_:)))
        let closeButton = UIBarButtonItem(image: UIImage(named: "closeIconSmall"), style: .plain, target: self, action: #selector(AudioViewController.closeMediaPlayer(_:)))
        self.navigationItem.setLeftBarButtonItems([closeButton,  playlistButton], animated: true)
        
        let myMediaQuery = MPMediaQuery.songs()
        //            let predicateFilter = MPMediaPropertyPredicate(value: "\(playlist)", forProperty: MPMediaPlaylistPropertyName)
        func getArtistSongsWithoutSettingPlaylist(currentSong : MPMediaItem?) -> ([[MPMediaItem]], [MPMediaItem]) {
            //album->*song
            let songs = [MPMediaItem]()
            var groupedSongs = [[MPMediaItem]]()
            if currentSong != nil {
                let query = MPMediaQuery.songs()
                let pred = MPMediaPropertyPredicate(value: currentSong!.albumArtist, forProperty: MPMediaItemPropertyAlbumArtist)
                query.addFilterPredicate(pred)
                let artistSongs = query.items!
                var albumDic = Dictionary<String,Array<MPMediaItem>>(minimumCapacity: artistSongs.count)
                //fill up the dictionary with songs
                for x in artistSongs {
                    if albumDic.index(forKey: x.albumTitle!) == nil {
                        albumDic[x.albumTitle!] = Array<MPMediaItem>()
                    }
                    albumDic[x.albumTitle!]?.append(x)
                }
                
                //get them back out by album and insert into array of arrays
                for (_,y) in albumDic {
                    let sorted = y.sorted { $0.albumTrackNumber < $1.albumTrackNumber }
                    groupedSongs.append(sorted)
                }
            }
            return (groupedSongs, songs)
        }
        
        //            myMediaQuery.filterPredicates = NSSet(object: predicateFilter) as? Set<MPMediaPredicate>
        myMusicPlayer.setQueue(with: myMediaQuery)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVolumeSlider() {
        // Note: This slider implementation uses a MPVolumeView
        // The volume slider only works in devices, not the simulator.
        volumeParentView.backgroundColor = UIColor.clear
        let volumeView = MPVolumeView(frame: volumeParentView.bounds)
        for view in volumeView.subviews {
            let uiview: UIView = view as UIView
            if (uiview.description as NSString).range(of: "MPVolumeSlider").location != NSNotFound {
                mpVolumeSlider = (uiview as! UISlider)
            }
        }
        
        let thumbImageNormal = UIImage(named: "slider-ball")
        slider?.setThumbImage(thumbImageNormal, for: .normal)
        
    }
    
    // MARK: - AVAudio player delegate functions.
    
    //    func prepareSongAndSession() {
    //
    //    do {
    //
    //    let audioSession = AVAudioSession.sharedInstance()
    //    do {
    //    //10 - Set our session category to playback music
    //    try audioSession.setCategory(AVAudioSessionCategoryPlayback)
    //    //11 -
    //    } catch let sessionError {
    //
    //    print(sessionError)
    //    }
    //    //12 -
    //    } catch let myMediaPlayerError {
    //    print(myMediaPlayerError)
    //    }
    //    }
    
    // set status false and set button  when audio finished.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        // set playing off
        self.isPlaying = false
        
        // invalidate scheduled timer.
        self.timer.invalidate()
        
        nowPlayingImageView.stopAnimating()
    }
    
    // show message if error occured while decoding the audio
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        // print friendly error message
        print(error!.localizedDescription)
    }
    
    func colorsWithHalfOpacity(_ colors: [CGColor]) -> [CGColor] {
        return colors.map({ $0.copy(alpha: $0.alpha * 0.5)! })
    }
    
    func addRepeatingPulseToProgressIndicatorRewind() {
        let _ = self.activityIndicatorViewRewind.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewRewind.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 0.1
            pulse.repeatDelay = 0.0
            pulse.repeatCount = 1 // Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func addRepeatingPulseToProgressIndicatorPlay() {
        let _ = self.activityIndicatorViewPlay.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewPlay.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 0.1
            pulse.repeatDelay = 0.0
            pulse.repeatCount = 1 // Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func addRepeatingPulseToProgressIndicatorStop() {
        let _ = self.activityIndicatorViewStop.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewStop.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 0.1
            pulse.repeatDelay = 0.0
            pulse.repeatCount = 1 // Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func addRepeatingPulseToProgressIndicatorPause() {
        let _ = self.activityIndicatorViewPause.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewPause.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 0.1
            pulse.repeatDelay = 0.0
            pulse.repeatCount = 1 // Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func addRepeatingPulseToProgressIndicatorNext() {
        let _ = self.activityIndicatorViewNext.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewNext.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 0.1
            pulse.repeatDelay = 0.0
            pulse.repeatCount = 1 // Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func addRepeatingPulseToProgressIndicatorShuffle() {
        let _ = self.activityIndicatorViewShuffle.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewShuffle.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 0.1
            pulse.repeatDelay = 0.0
            pulse.repeatCount = 1 // Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func createNowPlayingAnimation() {
        
        // Setup ImageView
        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBarsBlack-3"))
        nowPlayingImageView.autoresizingMask = []
        nowPlayingImageView.contentMode = UIViewContentMode.center
        
        // Create Animation
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.7
        
        // Create Top BarButton
        let barButton = UIButton(type: UIButtonType.custom)
        barButton.frame = CGRect(x: 0,y: 0,width: 40,height: 40)
        barButton.addSubview(nowPlayingImageView)
        nowPlayingImageView.center = barButton.center
        
        let barItem = UIBarButtonItem(customView: barButton)
        self.navigationItem.rightBarButtonItem = barItem
        
    }
    
    func openPlaylist(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToPlaylists", sender: nil)
    }
    
    func closeMediaPlayer(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "dismissAudioToHomeVC", sender: nil)
    }
    
    func startNowPlayingAnimation() {
        nowPlayingImageView.startAnimating()
    }
    
    // update currently played time label.
    func updatePlayedTimeLabel(){
        elapsedTimeSeconds += 1
        
        if let nowPlaying = myMusicPlayer.nowPlayingItem {
            let totalDurationTime = Int(nowPlaying.playbackDuration)
            
            let secondsRemained = totalDurationTime - elapsedTimeSeconds
            
            //            let minutes = currentTime/60
            //            let seconds = currentTime - (minutes * 60)
            playDuration.text = secondsRemained.toAudioString
            
            // update time within label
            // playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        
    }
    
    //    @IBAction func touchButtonAction(_ sender: UIButton) {
    //        let _ = touchButton.layer.addPulse { pulse in
    //            pulse.borderColors = [
    //                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
    //            ]
    //            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
    //        }
    //        nowPlayingImageView.startAnimating()
    //    }
    
    // outlet & action - prev button
    @IBOutlet var prevButton: UIButton!
    @IBAction func prevButtonAction(_ sender: UIButton) {
        myMusicPlayer.skipToPreviousItem()
        nowPlayingImageView.startAnimating()
        
        trackLbl.text = myMusicPlayer.nowPlayingItem?.title!
        nowPlayingItemArtworkImageView.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: nowPlayingItemArtworkImageView.bounds.size)
        trackInfo.text = "Track \(myMusicPlayer.nowPlayingItem!.albumTrackNumber.description)"
        
        let currentTime = Int((myMusicPlayer.nowPlayingItem?.playbackDuration)!)
        let minutes = currentTime/60
        let seconds = currentTime - (minutes * 60)
        
        // update time within label
        playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
        let _ = prevButton.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
    }
    
    // outlet & action - play button
    @IBOutlet var playButton: UIButton!
    @IBAction func playButtonAction(_ sender: UIButton) {
        elapsedTimeSeconds = 0
        // Add a playback queue containing filtered songs on the device
        myMusicPlayer.setQueue(with: myMediaQuery)
        
        // Start playing from the beginning of the queue
        myMusicPlayer.prepareToPlay()
        myMusicPlayer.play()
        
        if isPlaying  {
            myMusicPlayer.pause()
        } else {
            myMusicPlayer.play()
        }
        
        nowPlayingImageView.startAnimating()
        
        trackLbl.text = myMusicPlayer.nowPlayingItem?.title!
        
        nowPlayingItemArtworkImageView.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: nowPlayingItemArtworkImageView.bounds.size)
        
        if let nowPlaying = myMusicPlayer.nowPlayingItem {
            trackInfo.text = "Track \(nowPlaying.albumTrackNumber.description)"
        }
        
        if timer != nil {
            timer.invalidate()
        }
        // timer = Timer(timeInterval: 1, target: self, selector: #selector(AudioViewController.updatePlayedTimeLabel), userInfo: nil, repeats: true)
        //timer.tolerance = 0.01
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AudioViewController.updatePlayedTimeLabel), userInfo: nil, repeats: true)
        
        let _ = playButton.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
    }
    
    //MARK: - outlet & action - pause button
    @IBOutlet var pauseButton: UIButton!
    @IBAction func pauseButton(_ sender: UIButton) {
        myMusicPlayer.pause()
        timer.invalidate()
        nowPlayingImageView.stopAnimating()
        
        trackLbl.text = myMusicPlayer.nowPlayingItem?.title!
        nowPlayingItemArtworkImageView.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: nowPlayingItemArtworkImageView.bounds.size)
        
        //        if let nowPlaying = myMusicPlayer.nowPlayingItem {
        //            trackInfo.text = "Track \(nowPlaying.albumTrackNumber.description)"
        //        }
        //
        //        if timer != nil {
        //            timer.invalidate()
        //        }
        if let nowPlaying = myMusicPlayer.nowPlayingItem {
            
            trackInfo.text = "Track \(nowPlaying.albumTrackNumber.description)"
            
            let currentTime = Int(nowPlaying.playbackDuration)
            let minutes = currentTime / 60
            let seconds = currentTime - (minutes * 60)
            
            // update time within label
            playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        
        let _ = pauseButton.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
    }
    
    // outlet & action - forward button
    @IBOutlet var nextButton: UIButton!
    @IBAction func nextButtonAction(_ sender: UIButton) {
        myMusicPlayer.skipToNextItem()
        nowPlayingImageView.startAnimating()
        
        trackLbl.text = myMusicPlayer.nowPlayingItem?.title!
        nowPlayingItemArtworkImageView.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: nowPlayingItemArtworkImageView.bounds.size)
        
        if let nowPlaying = myMusicPlayer.nowPlayingItem {
            trackInfo.text = "Track \(nowPlaying.albumTrackNumber.description)"
            
            let currentTime = Int(nowPlaying.playbackDuration)
            let minutes = currentTime/60
            let seconds = currentTime - (minutes * 60)
            
            // update time within label
            playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        
        
        let _ = nextButton.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
    }
    
    @IBOutlet var stopButton: UIButton!
    @IBAction func stopButtonAction(_ sender: UIButton) {
        myMusicPlayer.stop()
        nowPlayingImageView.stopAnimating()
        
        trackLbl.text = myMusicPlayer.nowPlayingItem?.title!
        nowPlayingItemArtworkImageView.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: nowPlayingItemArtworkImageView.bounds.size)
        if let nowPlaying = myMusicPlayer.nowPlayingItem {
            trackInfo.text = "Track \(nowPlaying.albumTrackNumber.description)"
            
            let currentTime = Int(nowPlaying.playbackDuration)
            let minutes = currentTime / 60
            let seconds = currentTime - (minutes * 60)
            
            // update time within label
            playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        
        let _ = stopButton.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
    }
    
    @IBOutlet weak var shuffleButton: UIButton!
    @IBAction func shuffleButtonAction(_ sender: UIButton) {
        myMusicPlayer.setQueue(with: myMediaQuery)
        myMusicPlayer.shuffleMode = .songs
        myMusicPlayer.play()
        nowPlayingImageView.startAnimating()
        
        trackLbl.text = myMusicPlayer.nowPlayingItem?.title!
        nowPlayingItemArtworkImageView.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: nowPlayingItemArtworkImageView.bounds.size)
        
        if let nowPlaying = myMusicPlayer.nowPlayingItem {
            trackInfo.text = "Track \(nowPlaying.albumTrackNumber.description)"
            
            let currentTime = Int(nowPlaying.playbackDuration)
            let minutes = currentTime/60
            let seconds = currentTime - (minutes * 60)
            
            // update time within label
            playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        
        let _ = shuffleButton.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
    }
    
    @IBAction func volumeChanged(_ sender:UISlider) {
        mpVolumeSlider.value = sender.value
    }
    
    //    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
    //        performSegue(withIdentifier: "dismissAudioToHomeVC", sender: nil)
    //    }
}

extension MPMediaItem {
    
    var canAddToLibrary: Bool {
        let id = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID)
        let query = MPMediaQuery(filterPredicates: [id])
        let count = query.items?.count ?? 0
        return count == 0
    }
    
}
