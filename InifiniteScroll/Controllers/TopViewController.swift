//
//  TopViewController.swift
//  InifiniteScroll
//
//  Created by Sergei Semko on 8/8/23.
//

import UIKit

class TopViewController: UIViewController {
    
    var storyIds = [Int]()
    var displayedStories = [Story]()
    
    let limit = 20
    var lastItemIndex = -1
    var isUpdating = false
    var isAllDataDisplayed = false
    
    private let topTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        view.addSubview(topTable)
        
        NSLayoutConstraint.activate([
            topTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        topTable.delegate = self
        topTable.dataSource = self
        
        fetchTopStories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "New and Top Stories"
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    private func fetchTopStories() {
        APICaller.shared.getTopStories { topStoryResponse in
            self.storyIds = topStoryResponse
            self.updateDisplayedData()
        }
    }
    
    private func updateDisplayedData() {
        let firstIndex = lastItemIndex + 1
        if firstIndex > storyIds.count - 1 {
            print("All data already displayed")
            isAllDataDisplayed = true
            return
        }
        
        print("UpdateDisplayedData")
        
        let maxIndex = (lastItemIndex + limit) <= (storyIds.count - 1) ? (lastItemIndex + limit) : (storyIds.count - 1)
        isUpdating = true
        
        for i in firstIndex...maxIndex {
            print("get data ke-\(i)")
            
            APICaller.shared.getStoryById(id: storyIds[i]) { story in
                self.displayedStories.append(story)
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.topTable.reloadData()
                    if strongSelf.displayedStories.count == maxIndex + 1 {
                        strongSelf.isUpdating = false
                    }
                }
            }
        }
        lastItemIndex = maxIndex
    }

}

extension TopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let safeUrl = displayedStories[indexPath.row].url else { return }
        let webView = DetailViewController()
        webView.url = safeUrl
        navigationController?.pushViewController(webView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isAllDataDisplayed && indexPath.row >= lastItemIndex && !isUpdating {
            updateDisplayedData()
        }
    }
}

extension TopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = displayedStories[indexPath.row].title
        return cell
    }
    
}
