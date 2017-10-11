
//
//  XYTBaseViewController.swift
//  XYTOfo
//
//  Created by Farben on 2017/10/8.
//  Copyright © 2017年 Farben. All rights reserved.
//

import UIKit

class XYTBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem.init(title:"你好", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item

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
