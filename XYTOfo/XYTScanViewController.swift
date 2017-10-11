
//
//  XYTScanViewController.swift
//  XYTOfo
//
//  Created by Farben on 2017/10/8.
//  Copyright © 2017年 Farben. All rights reserved.
//

import UIKit
import swiftScan

class XYTScanViewController: LBXScanViewController {

    
    var isFlashOn = false
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var flashBtn: UIButton!
    
    @IBAction func inputBikeNo(_ sender: Any) {
    
    }
    
    
    @IBAction func falshLight(_ sender: Any) {
        
     isFlashOn = !isFlashOn
        scanObj?.changeTorch()
        if isFlashOn{
            flashBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: UIControlState.normal)
        }else{
            flashBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: UIControlState.normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="扫码用车"
        var style = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage=UIImage(named:"CodeScan.bundle/qrcode_scan_light_green")        
        scanStyle=style
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: self.panelView)
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
