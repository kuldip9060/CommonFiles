//
//  SimpleListVC.swift
//  oomph
//
//  Created by Appuno Solutions on 05/06/19.
//  Copyright © 2019 Ecosmob. All rights reserved.
//

import UIKit

class SimpleListVC: UIViewController {
    
    var strTitle : String?
    var aryList = [cscCommon]()
    var aryFullList = [cscCommon]()
    
    var callBackSelected : ((cscCommon)->())?
    
    @IBOutlet var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doInitialise()

    }
    
    func doInitialise(){
        self.title = strTitle
        
        self.aryFullList = aryList
        self.tblList.tableFooterView = UIView()
        self.tblList.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Uitableview Deleagte /Datasource
extension SimpleListVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.aryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SimpleTblCell
        let dict = self.aryList[indexPath.row]
        if let countryData = dict as? Country{
            cell.cellConfigure(data: countryData)
        } else if let stateData = dict as? State{
            cell.cellConfigure(data: stateData)
        } else if let cityData = dict as? City{
            cell.cellConfigure(data: cityData)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.callBackSelected!(self.aryList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UISeacrhBar delegate
extension SimpleListVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.length > 0{
            self.aryList = self.aryFullList.filter{($0.name?.contains(searchText))!}//filterArrayData(srtSearch: searchText)! as! [cscCommon]
        }else{
            self.aryList = self.aryFullList
        }
        self.tblList.reloadData()
    }
    
}
