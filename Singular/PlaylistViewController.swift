//
//  PlaylistViewController.swift
//  Singular
//
//  Created by dlr4life on 8/26/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

@available(iOS 9.3, *)
class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView?
    @IBOutlet weak var backButton: UIBarButtonItem!

    let myTableView: UITableView = UITableView( frame: CGRect.zero, style: .grouped )
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?
    
    var sectionTitles = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        animateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.estimatedRowHeight = 70 // this is your storyboard default cell height
        tableView?.rowHeight = UITableViewAutomaticDimension //Automatic dimensions
        
        self.title = "Songs"
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.albums = self.songQuery.get(songCategory: "")
                DispatchQueue.main.async {
                    self.tableView?.rowHeight = UITableViewAutomaticDimension;
                    self.tableView?.estimatedRowHeight = 60.0;
                    self.tableView?.reloadData()
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
    }
    
    func refresh() {
        sectionTitles[0].removeAll()
        sectionTitles[1].removeAll()
        sectionTitles[2].removeAll()
        sectionTitles[3].removeAll()
        sectionTitles[4].removeAll()
        sectionTitles[5].removeAll()
        sectionTitles[6].removeAll()
        sectionTitles[7].removeAll()
        sectionTitles[8].removeAll()
        sectionTitles[9].removeAll()
        sectionTitles[10].removeAll()
        sectionTitles[11].removeAll()
        sectionTitles[12].removeAll()
        sectionTitles[13].removeAll()
        sectionTitles[14].removeAll()
        sectionTitles[15].removeAll()
        sectionTitles[16].removeAll()
        sectionTitles[17].removeAll()
        sectionTitles[18].removeAll()
        sectionTitles[19].removeAll()
        sectionTitles[20].removeAll()
        sectionTitles[21].removeAll()
        sectionTitles[22].removeAll()
        sectionTitles[23].removeAll()
        sectionTitles[24].removeAll()
        sectionTitles[25].removeAll()
        sectionTitles[26].removeAll()
        tableView?.reloadData()
    }
    
    func displayMediaLibraryError() {
        
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }
    
    func animateTable() {
        
        myTableView.reloadData()
        
        let cells = myTableView.visibleCells
        let tableHeight: CGFloat = myTableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
        return albums[section].songs.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicPlayerCell", for: indexPath) as! MusicPlayerCell
        cell.labelMusicTitle?.text = albums[indexPath.section].songs[indexPath.row].songTitle
        cell.labelMusicDescription?.text = albums[indexPath.section].songs[indexPath.row].artistName
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem( songId: songId )
        
        if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
            cell.imageMusic?.image = imageSound.image(at: CGSize(width: cell.imageMusic.frame.size.width, height: cell.imageMusic.frame.size.height))
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return albums[section].albumTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "dismissToPlaylistVC", sender: nil)
    }
    
}
