//
//  AskViewController.swift
//  InifiniteScroll
//
//  Created by Sergei Semko on 8/8/23.
//

import UIKit

class AskViewController: UIViewController {
    
    var storyIds = [Int]()
    var displayedStories = [Story]()
    
    let limit = 20
    var lastItemIndex = -1
    var isUpdating = false
    var isAllDataDisplayed = false
    
    private let askTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        view.addSubview(askTable)
        
        askTable.delegate = self
        askTable.dataSource = self
        
        fetchAskStories()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        askTable.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Ask Stories"
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    private func fetchAskStories() {
        APICaller.shared.getAskStories { askStoryResponse in
            self.storyIds = askStoryResponse
            self.updateDisplayedData()
        }
    }
    
    private func updateDisplayedData() {
        let firstIndex = lastItemIndex + 1
        if (firstIndex > storyIds.count - 1) {
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
                    self?.askTable.reloadData()
                    if self?.displayedStories.count == maxIndex + 1 {
                        self?.isUpdating = false
                    }
                }
            }
        }
        lastItemIndex = maxIndex
    }
}

extension AskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (!isAllDataDisplayed && indexPath.row >= lastItemIndex && !isUpdating) {
            updateDisplayedData()
        }
    }
    
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
}

extension AskViewController: UITableViewDataSource {
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
