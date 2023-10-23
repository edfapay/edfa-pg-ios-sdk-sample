//
//  ExpressPayChooserVC.swift
//  Sample
//
//  Created by ExpressPay(zik) on 11.03.2021.
//

import UIKit

final class ExpressPayChooserVC<T: CustomStringConvertible>: UITableViewController {
    var data: [T] = []
    var completion: ((T) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completion?(data[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
