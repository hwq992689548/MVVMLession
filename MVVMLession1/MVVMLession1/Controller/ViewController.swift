//
//  ViewController.swift
//  MVVMLession1
//
//  Created by huangweiqiang on 2021/8/27.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    var tableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .grouped)
        table.register(TestTableCell.self, forCellReuseIdentifier: "TestTableCell")
        table.separatorStyle = .none
        return table
    }()
    
    var viewModel: UserListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        self.viewModel = UserListViewModel.init()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchGetData {[weak self] list in
            self?.viewModel.users.value = list
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.users.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableCell", for: indexPath) as! TestTableCell
        let arr = self.viewModel.users.value ?? []
        
        cell.setUpCellViewModel(vm: arr[indexPath.row])
        return cell
    }
}
