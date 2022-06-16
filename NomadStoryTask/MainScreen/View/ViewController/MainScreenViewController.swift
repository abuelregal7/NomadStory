//
//  MainScreenViewController.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let database = DatabaseHandler.shared
    
    var data: [OfflineStorageModel]? {
        didSet {
            mainTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        data = self.database.fetch(OfflineStorageModel.self)
        print(data)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        data = self.database.fetch(OfflineStorageModel.self)
        print(data)
        
    }
    
    //MARK:- configureTableView
    func configureTableView() {
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.separatorStyle = .none
        //mainTableView.rowHeight = 200
        mainTableView.register(UINib(nibName: MainScreenTableViewCell.cellID, bundle: nil),
                           forCellReuseIdentifier: MainScreenTableViewCell.cellID)
        
    }
    
    @IBAction func FavouriteButtonAction(_ sender: Any) {
        
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsProductViewController") as! DetailsProductViewController
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.cellID, for: indexPath) as? MainScreenTableViewCell else { return UITableViewCell() }
        let item = data?[indexPath.row]
        
        cell.imageOutlet.loadImage(item?.imageURL)
        cell.titleLabelOutlet.text = item?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
