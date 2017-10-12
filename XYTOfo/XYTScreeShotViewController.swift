//
//  XYTScreeShotViewController.swift
//  XYTOfo
//
//  Created by Farben on 2017/10/12.
//  Copyright © 2017年 Farben. All rights reserved.
//

import UIKit


class XYTScreeShotViewController: UIViewController {
    var screenshotImage :UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        let imageView = UIImageView.init(image: screenshotImage)
        imageView.frame = CGRect(x: 10, y:84, width: UIScreen.main.bounds.size.width-20, height: UIScreen.main.bounds.size.height-104)
        self.view.addSubview(imageView)
        let rightItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "share"), style: UIBarButtonItemStyle.done, target: self, action: #selector(shareImage))
        self.navigationItem.rightBarButtonItem=rightItem
        
        
    }
    
    @objc func shareImage() {
        
        let shareView = HWShareView.getView()
        shareView.show()
        
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
