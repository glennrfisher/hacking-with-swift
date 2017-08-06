//
//  ViewController.swift
//  Project7
//
//  Created by Glenn R. Fisher on 8/4/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(fetchPetitions), with: nil)
    }
    
    func fetchPetitions() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if let json = json as? [String: Any] {
                        self.parsePetitions(json: json)
                        return
                    }
                }
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parsePetitions(json: [String: Any]) {
        let metadata = json["metadata"] as! [String: Any]
        let responseInfo = metadata["responseInfo"] as! [String: Any]
        let status = responseInfo["status"] as! Int
        
        guard status == 200 else {
            print("error response with code \(status)")
            return
        }
        
        let results = json["results"] as! [[String: Any]]
        for result in results {
            let title = result["title"] as! String
            let body = result["body"] as! String
            let sigs = result["signatureCount"] as! Int
            let petition = ["title": title, "body": body, "sigs": "\(sigs)"]
            petitions.append(petition)
        }
        
        tableView.performSelector(
            onMainThread: #selector(UITableView.reloadData),
            with: nil,
            waitUntilDone: false
        )
    }
    
    func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed. " +
                     "Please check your connection and try again.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

