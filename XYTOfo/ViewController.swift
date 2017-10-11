//
//  ViewController.swift
//  XYTOfo
//
//  Created by Farben on 2017/10/1.
//  Copyright © 2017年 Farben. All rights reserved.
//

import UIKit
import SWRevealViewController
import FTIndicator

class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate {
    
    var mapView : MAMapView!
    var search : AMapSearchAPI!
    var pin:MyPinAnnotation!
    var pinView :MAAnnotationView!
    var nearBySearch = true
    var start,end : CLLocationCoordinate2D!
    var walkManager:AMapNaviWalkManager!
    
    
    @IBOutlet weak var panelView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arrVC:NSArray = self.childViewControllers as NSArray
        for VC in arrVC {
            if VC is XYTContainerViewController{
                let containVC = VC as! XYTContainerViewController
                containVC.locationBtn.addTarget(self, action: #selector(searchBikeNearby), for: UIControlEvents.touchDown)
                
            }
        }
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView.zoomLevel=17

        mapView.showsUserLocation=true
        mapView.userTrackingMode = .follow
        
        walkManager=AMapNaviWalkManager()
        walkManager.delegate=self
        
     
        self.view.addSubview(mapView)
        mapView.delegate=self
        
        
       view.bringSubview(toFront: panelView)
        let item = UIBarButtonItem.init(title:"返回", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    
    
        self.navigationItem.titleView=UIImageView.init(image: UIImage.init(named: "Login_Logo"))
        self.navigationItem.leftBarButtonItem?.image?=(UIImage.init(named: "user_center_icon")?.withRenderingMode(.alwaysOriginal))!
        self.navigationItem.rightBarButtonItem?.image?=UIImage.init(named: "blue_bar_message_icon")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        if let revealVC = revealViewController() {
            revealVC.rearViewRevealWidth=280
            navigationItem.leftBarButtonItem?.target=revealVC
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
            
        }

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 私有方法
    @objc func searchBikeNearby()  {
        nearBySearch=true
        searchCustomLocation(center: mapView.userLocation.coordinate)
    }
    func searchCustomLocation(center:CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location=AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords="餐馆|酒店"
        request.radius=500
        request.requireExtension=true
        search = AMapSearchAPI()
        search.delegate = self
        search.aMapPOIAroundSearch(request)
        
    }
    
    
    //MARK:- AMapSearchDelegate
    //搜索周边完成后的处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count>0 else {
            NSLog( "周边没有小黄车")
            return
        }

        var annotations:[MAAnnotation]=[]
        annotations = response.pois.map{
            let annotation = MAPointAnnotation()
            annotation.coordinate=CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            //根据类型判断是否为小黄车和红包车
            if $0.type.contains("餐饮服务"){
                annotation.title="正常可用"
            }else{
                annotation.title="红包车"
                annotation.subtitle="骑行10分钟可获取红包车"
            }
            return annotation
            
        }

        mapView.addAnnotations(annotations)
        if nearBySearch {
            mapView.showAnnotations(annotations, animated: true)
            nearBySearch = !nearBySearch
        }
    }
    
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        
        if response == nil {
            return;
        }else{
           let path = response.route.paths[0]
           let walkTime = path.duration/60
            var timeDesc = "1分钟以内"
            if walkTime>0 {
                timeDesc=walkTime.description+"分钟"
            }
            let hintTitle = "步行"+timeDesc
            let hintSubtile = "距离"+(path.distance.description)+"米"
            FTIndicator.setIndicatorStyle(.dark)
            FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hintSubtile)

            if response.count > 0 {
                mapView.removeOverlays(mapView.overlays)
              let pathPolylines = XYTTool.init().polylines(for: path)
                mapView.addOverlays(pathPolylines)
            }
        }
       
    }
    
    //MARK:- MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAUserLocation {
                return nil
            }
        if annotation is MyPinAnnotation {
            let pinId = "anchor"
            var av = mapView.dequeueReusableAnnotationView(withIdentifier: pinId)
            if av == nil{
                av = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            }
            av?.image=#imageLiteral(resourceName: "homePage_wholeAnchor")
            av?.canShowCallout=false
            pinView = av
            return av
        }
        let resusid = "myid"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: resusid)as? MAPinAnnotationView
        if annotationView == nil{
            annotationView=MAPinAnnotationView(annotation: annotation, reuseIdentifier: resusid)
        }
        if annotation.title=="正常可用"{
            annotationView?.image=#imageLiteral(resourceName: "HomePage_nearbyBike")
        }else{
            annotationView?.image=#imageLiteral(resourceName: "HomePage_ParkRedPack")
        }
        annotationView?.canShowCallout=true
        annotationView?.animatesDrop=true
        return annotationView
    }
    
    func mapInitComplete(_ mapView: MAMapView!) {
        pin = MyPinAnnotation()
        pin.coordinate=mapView.centerCoordinate
        pin.lockedScreenPoint=CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        pin.isLockedToScreen=true
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        self.searchCustomLocation(center: self.mapView.userLocation.coordinate)

    }
    //用户移动地图的 交互
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction{
            pin.isLockedToScreen=true
            pinAnimation()
            searchCustomLocation(center: mapView.centerCoordinate)

        }
    }

    //MARK:-大头针动画
    func pinAnimation()  {
        let endFrame = pinView.frame
        pinView.frame = endFrame.offsetBy(dx: 0, dy: -15)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            self.pinView.frame=endFrame
        }, completion: nil)
    }
   
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as![MAAnnotationView]
        for aView in aViews{
            guard aView.annotation is MAPointAnnotation else{
                continue
            }
            aView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
                aView.transform = .identity
                
            }, completion: nil)
        }
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        self.start = pin.coordinate
        self.end = view.annotation.coordinate
        let navi:AMapWalkingRouteSearchRequest = AMapWalkingRouteSearchRequest()
       navi.origin=AMapGeoPoint.location(withLatitude: CGFloat(self.start.latitude), longitude:  CGFloat(self.start.longitude))
        navi.destination=AMapGeoPoint.location(withLatitude: CGFloat(self.end.latitude), longitude:  CGFloat(self.start.longitude))
        self.search.aMapWalkingRouteSearch(navi)
        
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            pin.isLockedToScreen=false
            mapView.visibleMapRect=overlay.boundingMapRect
            let render = MAPolylineRenderer(overlay: overlay)
            render?.lineWidth=8.0
            render?.strokeColor=UIColor.blue
            render?.lineJoinType=kMALineJoinRound
            render?.lineCapType=kMALineCapRound
            return render

        }
        return nil
    }
    
 
    
    //MARK:- AMapNaviWalkManagerDelegate 导航的代理
//
//    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
//        mapView.removeOverlays(mapView.overlays)
//        var coordinates = walkManager.naviRoute!.routeCoordinates!.map{
//            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
//        }
//
//        let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
//        mapView.add(polyline)
//        let walkTime = (walkManager.naviRoute?.routeTime)!/60
//        var timeDesc = "1分钟以内"
//        if walkTime>0 {
//            timeDesc=walkTime.description+"分钟"
//        }
//        let hintTitle = "步行"+timeDesc
//        let hintSubtile = "距离"+(walkManager.naviRoute?.routeLength.description)!+"米"
//        FTIndicator.setIndicatorStyle(.dark)
//        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hintSubtile)
//
//    }
//
//    func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
//        print("计算失败")
//    }
    
}

