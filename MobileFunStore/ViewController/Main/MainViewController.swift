//
//  ViewController.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 09/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Photos

extension MainViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        cell.titleLabel.text = "Sample title label"
        cell.detailTextLabel?.text = "Detail label text"
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        let manager = PHImageManager.default()
        if cell.tag != 0 {
            cell.imageViewHandler.image = nil
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        let asset = assets[indexPath.row]
        let imageId = manager.requestImage(for: asset, targetSize: CGSize(width: cell.imageViewHandler.frame.width, height:cell.imageViewHandler.frame.height), contentMode: PHImageContentMode.aspectFill, options: options) { (image, _) in

            cell.imageViewHandler.image = image
        }
        cell.tag = Int(imageId)
        
        return cell
    }
}

extension MainViewController : UITableViewDelegate {
    
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var assets : [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func getPicturesBtnPressed(_ sender: UIButton) {
        fetchPhotos()
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotos() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        print("\(fetchResult.count)")
        
        fetchResult.enumerateObjects { (asset, _, _) in
            self.assets.append(asset)
        }
        
        tableView.reloadData()

    }
}


