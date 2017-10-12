
//
//  XYTNavigationBar.swift
//  NavigationBar
//
//  Created by Farben on 2017/9/28.
//  Copyright © 2017年 Farben. All rights reserved.
//

import UIKit
import SnapKit

public class XYTNavigationBar: UIView {
    
   public var title:String?{
        willSet{
            self.titileLable.text=title
        }

    }
   public var titleColor:UIColor?{
        willSet{
            self.titileLable.textColor = titleColor
        }
        didSet{
            self.titileLable.textColor = titleColor

        }
    }
  public  var image:UIImage?
  public  var navBackgroundColor:UIColor?{
        willSet{
        self.backgroundColor = navBackgroundColor;
        }
        didSet{
            self.backgroundColor = navBackgroundColor;

        }
    
    }
    var navBackgroundImage:UIImage?{
        willSet{
            self.bgBroundView.image = navBackgroundImage
            
        }
    }
    public var  clickLeftItemBlock :(()->Void)?//声明闭包
    public var  clickRightItemBlock :(()->Void)?


    
    //MARK:- 常量和闭包声明
    let kScreenHeight = UIScreen.main.bounds.size.height
    let kScreenWidth = UIScreen.main.bounds.size.width
    var gof_ColorWithHex: (NSInteger) -> UIColor = {hex in
        return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0, green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(hex & 0xFF)) / 255.0, alpha: 1);
    }
    

    //MARK:- 初始化方法
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
       //MARK:- 懒加载
    fileprivate lazy var titileLable :UILabel={
        let titileLable :UILabel  = UILabel.init()
        titileLable.font=UIFont.systemFont(ofSize: 18)
        titileLable.textAlignment=NSTextAlignment.center
        return titileLable
    }()

    
    fileprivate lazy var leftButton :UIButton = {
        let btn = UIButton.init()
          let leftImage = UIImage.init(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "XYTNavigationBar.bundle/back@2x", ofType: "png")!)
        btn .setImage(leftImage, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(clickBack), for: UIControlEvents.touchDown)
        return btn

    }()
    
    fileprivate lazy var rightButton :UIButton = {
        let rightButton = UIButton.init()
        
        let btnImage = UIImage.init(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "XYTNavigationBar.bundle/share_icon@2x", ofType: "png")!)
        rightButton.setImage(btnImage, for: UIControlState.normal)
        rightButton.addTarget(self, action: #selector(clickGo), for: UIControlEvents.touchDown)
       
        return rightButton
        
    }()
    
    fileprivate lazy var bgBroundView : UIImageView = {
        let bgBroundView = UIImageView.init(image: UIImage.init(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "XYTNavigationBar.bundle/nav_bar@2x", ofType: "png")!))
        let image = UIImage.init(named: "share_icon")

        return bgBroundView
        
    }()
    
    
    //MARK:- 按钮点击事件
    @objc func clickBack()  {
        if clickLeftItemBlock != nil  {
            clickLeftItemBlock!()
        }
       
    }
    
    @objc func clickGo()  {
        if clickRightItemBlock != nil{
            clickRightItemBlock!()
        }
        
    }
    

    //MARK:- 私有方法
  private  func setUp() {
        self.addSubview(bgBroundView)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(titileLable)
        setupSubviewsConstraints()
        setDefalut()
    
    }
    
    private func setupSubviewsConstraints(){
        bgBroundView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(0)
        })
        
        leftButton.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.left.equalTo(0)
            make.top.equalTo(20)
        })
        
        titileLable.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 180, height: 44))
            make.top.equalTo(20)
            make.left.equalTo((kScreenWidth-180)/2)
        })
        rightButton.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.equalTo(0)
            make.top.equalTo(20)
        })
        
    }
    
   private func setDefalut() {
   self.titileLable.textColor = gof_ColorWithHex(0xFFFFFF)
   self.navBackgroundColor = gof_ColorWithHex(0x00C3F5)
    self.backgroundColor=navBackgroundColor
    self.bgBroundView.alpha=0.0
     self.backgroundColor = navBackgroundColor?.withAlphaComponent(0.0)
    
    }
    
    //MARK:- 共有方法
    
  public  func  setupBgColorAlpha(alpha:CGFloat,duration:TimeInterval,compeleteBlock:@escaping()->Void) {
        self.backgroundColor = self.navBackgroundColor?.withAlphaComponent(alpha)
        self.titileLable.textColor = gof_ColorWithHex(0xFFFFFF).withAlphaComponent(alpha);
        compeleteBlock()
    }
    
  public  func  setupBgImageAlpha(alpha:CGFloat,duration:TimeInterval,compeleteBlock:@escaping ()->Void) {
        UIView.animate(withDuration: duration) {
            self.bgBroundView.alpha = alpha
            self.titileLable.textColor = self.gof_ColorWithHex(0xFFFFFF).withAlphaComponent(alpha)
            compeleteBlock()
        }
    }
    
  public  func  setLeftImage(imageName:String,leftItemtitle:String,textColor:UIColor) {
        self.leftButton.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        self.leftButton.setTitle(leftItemtitle, for: UIControlState.normal)
        self.leftButton.setTitleColor(textColor, for: UIControlState.normal)
    }
    
  public  func  setRightItemImage(imageName:String,leftItemtitle:String,textColor:UIColor) {
        self.rightButton.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        self.rightButton.setTitle(leftItemtitle, for: UIControlState.normal)
        self.rightButton.setTitleColor(textColor, for: UIControlState.normal)
    }
    
  public  func  setLeftItemImage(imageName:String) {
        self.leftButton.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        
    }
  public  func  setRightItemImage(imageName:String) {
        self.leftButton.setImage(UIImage.init(named: imageName), for: UIControlState.normal)
        
    }
    
  public  func showCustomNavigationBar(show:Bool)  {
        self.isHidden = !show
    }
    
    //MARK:- getters and setters
    
    

}
