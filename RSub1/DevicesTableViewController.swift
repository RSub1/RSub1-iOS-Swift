//
//  DevicesTableViewController.swift
//  RSub1
//
//  Created by b600609 on 22.03.20.
//  Copyright © 2020 RSub1. All rights reserved.
//

import UIKit

class DevicesTableViewController: UITableViewController {

    var devices: [NearByModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        devices = NearByMessageApi.getExposures()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "devicesCell", for: indexPath)

        let device = self.devices[indexPath.row]
        let endExposure = device.endExposure ?? Int(NSDate().timeIntervalSince1970)
        let exposureTime = endExposure - device.startExposure
        
        cell.textLabel?.text = "\(device.uuid) - \(exposureTime)"

        return cell
    }

}
