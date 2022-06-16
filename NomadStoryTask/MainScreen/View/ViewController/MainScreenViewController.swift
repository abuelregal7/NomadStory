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
        print(data ?? [])
        
    }
    
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Hud.showHud(in: self.view)
        data = self.database.fetch(OfflineStorageModel.self)
        Hud.dismiss()
        print(data ?? [])
        
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

