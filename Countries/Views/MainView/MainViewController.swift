//
//  ViewController.swift
//  Countries
//
//  Created by Eric Barnes - iOS on 2/13/24.
//

import UIKit
import Combine
import SVProgressHUD

class MainViewController: UIViewController {

    // MARK: UI Components
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "search countries"
        sb.delegate = self
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    private lazy var countriesTableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = view.bounds.size.height * 0.1
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: Properties/Attributes
    var cancellables: Set<AnyCancellable> = []
    var viewModel = MainViewModel()
    let cellSpacing: CGFloat = 16
    
    // MARK: Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBindings()
        
        SVProgressHUD.show()
        viewModel.getCountries()
        
        setupTableView()
        drawUI()
    }

    // MARK: Helper Functions
    private func drawUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(countriesTableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countriesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            countriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            countriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setupTableView() {
        countriesTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        countriesTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerForSpacing")
    }
    
    func setupBindings() {
        viewModel.$isDoneLoadingData.sink { [weak self] doneLoadingData in
            SVProgressHUD.dismiss()
            self?.countriesTableView.reloadData()
        }.store(in: &cancellables)
    }
}

// MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            viewModel.filteredCountries = viewModel.allCountries.filter({
                $0.nameRegionText.contains(searchText) || $0.capital.contains(searchText)
            })
        } else {
            viewModel.filteredCountries = viewModel.allCountries
        }
        countriesTableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let countryCell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as? CountryTableViewCell else { fatalError("Could not render country tableView cells 😨")}

        countryCell.configure(for: viewModel.filteredCountries[indexPath.section])
        countryCell.selectionStyle = .none
        
        return countryCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = UIColor.clear
        return spacer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacing
    }
}
