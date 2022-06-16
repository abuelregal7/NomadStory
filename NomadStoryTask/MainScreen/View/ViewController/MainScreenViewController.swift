//
//  MainScreenViewController.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import UIKit
import Combine

class MainScreenViewController: UIViewController {
    
    // properties
    // outlets
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    
    // instance of Singleton DtabaseHandler class
    let database = DatabaseHandler.shared
    
    // var data and make didset{} to reload tableView
    var data: [OfflineStorageModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.mainTableView.reloadData()
            }
        }
    }
    
    // AnyCancellable
    var subscripation = Set<AnyCancellable>()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favouriteButtonOutlet.pulsate()
        
        Hud.showHud(in: self.view)
        data = self.database.fetch(OfflineStorageModel.self)
        Hud.dismiss()
        print(data)
        
    }
    
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Hud.showHud(in: self.view)
        data = self.database.fetch(OfflineStorageModel.self)
        Hud.dismiss()
        print(data)
        
    }
    
    //MARK:- configure TableView
    func configureTableView() {
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.separatorStyle = .none
        //mainTableView.rowHeight = 200
        mainTableView.register(UINib(nibName: MainScreenTableViewCell.cellID, bundle: nil),
                           forCellReuseIdentifier: MainScreenTableViewCell.cellID)
        mainTableView.register(UINib(nibName: TotalPriceTableViewCell.cellID, bundle: nil),
                           forCellReuseIdentifier: TotalPriceTableViewCell.cellID)
        
    }
    
    //MARK:- Favourite Button Action
    @IBAction func FavouriteButtonAction(_ sender: Any) {
        
        // move and navigate from Main Screen to Details product screen
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsProductViewController") as! DetailsProductViewController
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
}

//MARK:- extension from MainScreenViewController for TableViewDataSource and TableViewDelegate
extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return data?.count ?? 0
        }else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // if section = 0 show list cell
        if indexPath.section == 0 {
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.cellID, for: indexPath) as? MainScreenTableViewCell else { return UITableViewCell() }
            let item = data?[indexPath.row]
            
            // UI elementin cell and load data from local database(dataModelValue)
            cell.imageOutlet.setImageWith(item?.imageURL)
            cell.titleLabelOutlet.text = item?.name
            cell.priceLabelOutlet.text = "Price : \(item?.retailPrice ?? 0) $"
            
            // this closure in button action to => remove data from database(OfflineStorageModel)
            cell.tappedButton = { [weak self] in
                guard let self = self else { return }
                guard let item = self.data?[indexPath.row] else { return }
                self.mainTableView.beginUpdates()
                self.database.delete(object: item)
                self.data?.remove(at: indexPath.row)
                self.mainTableView.deleteRows(at: [indexPath], with: .automatic)
                self.mainTableView.endUpdates()
            }
            
            return cell
        }else { // else section = 1 show totalPrice cell
            
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: TotalPriceTableViewCell.cellID, for: indexPath) as? TotalPriceTableViewCell else { return UITableViewCell() }
            
            /// implement `map and reduce` to calculate total price
            let totalPrice = data?.map { Int($0.retailPrice) }.reduce(0, +)
            
            // UI elementin cell and load data from local database(dataModelValue)
            cell.priceLabelOutlet.text = "Total Price : \(totalPrice ?? 0) $"
            
            return cell
        }
        
    }
    
    // to make swipe action in cell to remove product with indexPath.row
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            guard let item = self.data?[indexPath.row] else { return }
            self.mainTableView.beginUpdates()
            self.database.delete(object: item)
            self.data?.remove(at: indexPath.row)
            self.mainTableView.deleteRows(at: [indexPath], with: .automatic)
            self.mainTableView.endUpdates()
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // if section = 0, make height = 200
        if indexPath.section == 0 {
            return 200
        }else { // else check if toatPrice = 0 or totalPrice = nil
            let totalPrice = data?.map { Int($0.retailPrice) }.reduce(0, +)
            if totalPrice == 0 || totalPrice == nil { // if totalPrice = 0 or totalPrice = nil, then make height = 0
                return 0
            }else { // else => totalPrice != 0 or totalPrice != nil, then make height = 60
                return 60
            }
        }
    }
    
}
