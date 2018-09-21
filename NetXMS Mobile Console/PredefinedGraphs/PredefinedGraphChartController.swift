//
//  PredefinedGraphChartController.swift
//  NetXMS Mobile Console
//
//  Created by Ēriks Jenkēvics on 13/09/2018.
//  Copyright © 2018 Raden Solutions. All rights reserved.
//

import Foundation
import Charts

class PredefinedGraphChartController: LineChartViewController
{
   @IBOutlet weak var predefinedGraphView: LineChartView!
   var object: AnyObject?
   
   override func viewDidLoad() {
      self.lineChartView = predefinedGraphView
      super.viewDidLoad()
      if let object = self.object as? GraphSettings
      {
         var query = ""
         for d in object.dciList
         {
            switch object.timeFrameType
            {
               case TimeFrameType.TIME_FRAME_BACK_FROM_NOW:
                  query.append("\(d.dciId),\(d.nodeId),\(0),\(0),\(object.timeRange),\(object.timeUnits.rawValue);")
               case TimeFrameType.TIME_FRAME_FIXED:
                  query.append("\(d.dciId),\(d.nodeId),\(object.timeFrom),\(object.timeTo),\(0),\(0);")
               default:
                  query.append("\(d.dciId),\(d.nodeId),\(0),\(0),\(0),\(0);")
            }
         }
         Connection.sharedInstance?.getLastValuesForMultipleObjects(query: query, onSuccess: onGetSuccess)
      }
   }
   
   override func onGetSuccess(jsonData: [String : Any]?) {
      if let jsonData = jsonData,
         let values = jsonData["values"] as? [String: Any]
      {
         var dciData = [DciData]()
         for v in values
         {
            if let v = v.value as? [String : Any]
            {
               dciData.append(DciData(json: v))
            }
         }
         
         var dataPoints = [[Double]]()
         var timeStamps = [[Double]]()
         var values = [Double]()
         var time = [Double]()
         for d in dciData
         {
            for v in d.values
            {
               values.append(v.value)
               time.append(Double(v.timestamp))
            }
            values.reverse()
            time.reverse()
            dataPoints.append(values)
            timeStamps.append(time)
            values.removeAll()
            time.removeAll()
         }
         
         var labels = [String]()
         for d in (object as! GraphSettings).dciList
         {
            labels.append(d.dciDescription)
         }
         
         DispatchQueue.main.async
         {
            self.setChart(dataPoints: dataPoints, values: timeStamps, labels: labels)
         }
      }
   }
}
