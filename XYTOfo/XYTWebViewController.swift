
//
//  XYTWebViewController.swift
//  XYTOfo
//
//  Created by Farben on 2017/10/1.
//  Copyright © 2017年 Farben. All rights reserved.
//

import UIKit

class XYTWebViewController: UIViewController {

    @IBOutlet weak var XYTWebview: UIWebView!
    override func viewDidLoad() {
    super.viewDidLoad()

    self.title="热门活动"
    let url:URL = URL.init(string: "http://m.ofo.so/active.html")!
    let request:URLRequest = URLRequest(url: url)
    self.XYTWebview.loadRequest(request)
    
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
