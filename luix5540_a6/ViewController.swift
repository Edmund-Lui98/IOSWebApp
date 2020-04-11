//
//  ViewController.swift
//  luix5540_a6
//
//  Created by Prism Student on 2020-04-08.
//  Copyright © 2020 Edmund Lui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var newsTitle: UINavigationItem!
    var newsItem: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = newsItem.image
        image.contentMode = .scaleAspectFill
        desc.text = newsItem!.desc
        desc.numberOfLines = 0
        newsTitle.title = newsItem.title
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           super.prepare(for: segue, sender: sender)
           
           switch(segue.identifier ?? "") {
               
           case "ShowWeb":
               guard let webViewController = segue.destination as? WebViewController else {
                   fatalError("Unexpected destination: \(segue.destination)")
               }
               
               let item = newsItem
               webViewController.newsItem = item
               
           default:
               fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
           }
           
       }


}



