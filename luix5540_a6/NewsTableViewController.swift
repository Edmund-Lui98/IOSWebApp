//
//  NewsTableViewController.swift
//  luix5540_a6
//
//  Created by Prism Student on 2020-04-08.
//  Copyright © 2020 Edmund Lui. All rights reserved.
//

import UIKit
import os.log

class NewsTableViewController: UITableViewController, URLSessionTaskDelegate, XMLParserDelegate {
    // MARK: Properties
    var feed = [Item]()
    var item = Item()
    let urlPath: String = "https://globalnews.ca/toronto/feed/"
    
    var dataStore = Data()
    var currentElement = ""
    var processingElement = false
    
    let ITEM_ELEMENT = "item"
    let TITLE_ELEMENT = "title"
    let IMAGE_ELEMENT = "enclosure"
    let DESC_ELEMENT = "description"
    let URL_ELEMENT = "link"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url: URL = URL(string: urlPath)!
        let request: URLRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request, completionHandler:{ (data, response, error) in
            self.dataStore = data!
            let results = NSString(data: self.dataStore, encoding: String.Encoding.utf8.rawValue)

            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            self.parseXML()
            self.loadImages()
        })
        task.resume()
    }

    // MARK: - XML parsing

    func parseXML() {
        let parser = XMLParser(data: dataStore)
        parser.delegate = self // don't forget to set the delegate for the parser
        parser.parse()
    }
    
    func loadImages() {
        let imageQueue = DispatchQueue(label: "Image Queue", attributes: .concurrent)
        for item in feed {
            let imageURL = NSURL(string: item.imageURL)
            imageQueue.async {
                let imageData = NSData(contentsOf: imageURL! as URL)
                item.image = UIImage(data: imageData! as Data)!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == IMAGE_ELEMENT {
            if let imgUrl = attributeDict["url"] {
                self.item.imageURL = imgUrl.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        if elementName == ITEM_ELEMENT {
            processingElement = true // we are processing the "item" element
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if processingElement {
            currentElement += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == TITLE_ELEMENT {
            self.item.title = self.currentElement.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if elementName == DESC_ELEMENT {
            self.item.desc = self.currentElement.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if elementName == URL_ELEMENT {
            self.item.url = self.currentElement.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if elementName == ITEM_ELEMENT {
            let tempItem = Item()
            tempItem.title = self.item.title
            tempItem.imageURL = self.item.imageURL
            tempItem.desc = self.item.desc
            tempItem.url = self.item.url
            self.feed.append(tempItem)
            processingElement = false
        }
        currentElement = ""

    } // didEndElement

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parser error: " + String(describing: parseError))
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsItemViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsItem  else {
            fatalError("The dequeued cell is not an instance of NewsItemViewCell.")
        }
        
        let newsItem = feed[indexPath.row]
        
        cell.newsLabel.text = newsItem.title
        cell.newsLabel.lineBreakMode = .byTruncatingTail
        cell.newsLabel.contentMode = .scaleToFill
        cell.newsLabel.numberOfLines = 2
        
        if ((newsItem.image) != nil) {
            cell.newsImage.image = newsItem.image
            cell.newsImage.contentMode = .scaleAspectFit
        }
    
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowDetail":
            guard let newsItemDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedNewsItemCell = sender as? NewsItem else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedNewsItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedNewsItem = feed[indexPath.row]
            newsItemDetailViewController.newsItem = selectedNewsItem
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
        
    }
    
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {

    }

}
