//
//  ViewController.swift
//  Swift5MapAndPtotocol1
//
//  Created by 山岡巧 on 2020/08/04.
//  Copyright © 2020 takumi.yamaoka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, SearchLocationDelegate {
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    var locManager: CLLocationManager!
    var addressString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        settingButton.backgroundColor = .white
        settingButton.layer.cornerRadius = 20.0
        
    }

    @IBAction func longPressTap(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began{
            // タップを開始した
            
        } else if sender.state == .ended {
            // タップを終了
            // タップした位置を指定して、MKMapView上の緯度経度を取得する
            // 緯度軽度から住所に変換する
            
            let tapPoint = sender.location(in: view)
            
            // タップした位置(CGPoint)を指定してMKMapView上の緯度経度を取得する
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            let lat = center.latitude
            let log = center.longitude
            convert(lat: lat, log: log)
        }
        
    }
    
    func convert(lat:CLLocationDegrees, log:CLLocationDegrees){
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: log)
        
        // クロージャー
        geocoder.reverseGeocodeLocation(location) { (placeMark, error) in
            
            if let placeMark = placeMark{
                
                if let pm = placeMark.first{
                    
                    if pm.administrativeArea != nil || pm.locality != nil {
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                        
                    } else {
                        
                        self.addressString = pm.name!
                        
                    }
                    
                    self.addressLabel.text = self.addressString
                }
            }
            
        }
    }
    
    @IBAction func goToSearchVC(_ sender: Any) {
        
        //　画面遷移
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            
            let nextVC = segue.destination as! NextViewController
            nextVC.delegate = self
        }
    }
    
    // 任されたデリゲートメソッド
    func searchLocation(idoValue: String, keidoValue: String) {
        if idoValue.isEmpty != true && keidoValue.isEmpty != true{
            
            let idoString = idoValue
            let keidoStriong = keidoValue
            
            // 緯度、軽度からコーディネート
            let coordinate = CLLocationCoordinate2DMake(Double(idoString)! , Double(keidoStriong)!)
            
            // 表示する範囲を指定
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            // 領域を指定
            let region = MKCoordinateRegion(center: coordinate, span: span)
            // 領域をmapViewに指定
            mapView.setRegion(region, animated: true)
            // 緯度軽度から住所へ変換
            convert(lat: Double(idoString)!, log: Double(keidoStriong)!)
            // ラベルに表示
            addressLabel.text = addressString
        } else {
            addressLabel.text = "表示できません"
        }
        
    }
    
}

