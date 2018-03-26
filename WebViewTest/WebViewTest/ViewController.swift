//
//  ViewController.swift
//  WebViewTest
//
//  Created by Ryan Hiroaki Tsukamoto on 3/24/18.
//  Copyright © 2018 TreeSquared. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let pagePath = Bundle.main.path(forResource: "res/index", ofType: ".html") else {
            print("cannot get page path")
            return
        }
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            let logFunction: @convention(block) (String) -> () = { log in
                self.captureLog(log)
            }
            context.objectForKeyedSubscript("console").setObject(unsafeBitCast(logFunction, to: AnyObject.self), forKeyedSubscript: "log" as NSCopying & NSObjectProtocol)
        } else {
            print("cannot attach log")
        }
        let urlRequest = URLRequest(url: URL(fileURLWithPath: pagePath))
        webView.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureLog(_ log: String) {
        print("JS -> Swift:\n" + log) //todo: instead of printing the log message, attempt to deserialize as JSON, then process each of the objects in the resulting JSON object's "bridgeObjects" array.
    }
}

extension ViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finished loading")
        print("running a JS thing")
        _ = webView.stringByEvaluatingJavaScript(from: "setUpThings();")
        _ = webView.stringByEvaluatingJavaScript(from: "acceptBridgeObjectPayloadJson('{\"bridgeObjects\":[{\"foo\":\"biz\",\"bar\":\"baz\"}]}');") //todo: make this safe by converting all occurrences of "'" to "\'" inside the JSON (since it's being given as a single-quoted string)
    }
}
