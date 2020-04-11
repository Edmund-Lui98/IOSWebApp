//
//  WebViewController.swift
//  luix5540_a6
//
//  Created by Prism Student on 2020-04-08.
//  Copyright © 2020 Edmund Lui. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    let kFOOTERHEIGHT : CGFloat = 44.0
    
    var newsItem: Item?
    var webView : WKWebView = WKWebView()
    var footerView : UIView = UIView()
    var leftArrowButton = UIButton(type: UIButton.ButtonType.custom)
    var rightArrowButton = UIButton(type: UIButton.ButtonType.custom)
    
    @IBAction func newsFeedButton(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToNewsFeed", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        webView.allowsBackForwardNavigationGestures = true
        self.view.backgroundColor = UIColor.white
        self.footerView.backgroundColor = UIColor.white

        // Image set
        self.leftArrowButton.setImage(UIImage(named: "left"), for: [])
        // when user presses on the left arrow button, the method back is executed
        self.leftArrowButton.addTarget(self, action:#selector(back(_ : )), for: .touchUpInside)
        
        self.rightArrowButton.setImage(UIImage(named: "right"), for: [])
        self.rightArrowButton.addTarget(self, action:#selector(forward(_ : )), for: .touchUpInside)
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.footerView)
        self.view.addSubview(self.leftArrowButton)
        self.view.addSubview(self.rightArrowButton)
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest(url: NSURL(string: newsItem!.url)! as URL))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.webView.frame = CGRect(origin: CGPoint(x:0, y:statusBarHeight), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - (statusBarHeight) - kFOOTERHEIGHT))
        
        self.footerView.frame = CGRect(origin: CGPoint(x:0, y:self.view.frame.size.height - kFOOTERHEIGHT), size: CGSize(width: self.view.frame.size.width, height: kFOOTERHEIGHT))
        
        self.leftArrowButton.frame = CGRect(origin: CGPoint(x:5, y:self.view.frame.size.height - kFOOTERHEIGHT), size: CGSize(width: kFOOTERHEIGHT, height: kFOOTERHEIGHT))
        
        self.rightArrowButton.frame = CGRect(origin: CGPoint(x:10 + kFOOTERHEIGHT, y:self.view.frame.size.height - kFOOTERHEIGHT), size: CGSize(width: kFOOTERHEIGHT, height: kFOOTERHEIGHT))
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("Failed Navigation %@", error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Finish navigation
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
    
    @objc func back(_ sender: Any) {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        }
    } // back
    
    @objc func forward(_ sender: Any) {
        if (self.webView.canGoForward) {
            self.webView.goForward()
        }
    } // forward
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
