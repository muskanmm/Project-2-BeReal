//
//  CommentViewController.swift
//  Project-2-BeReal
//
//  Created by Muskan Mankikar on 3/15/24.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var comments = [Comment]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.reloadData()
//        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        queryComments()
    }
    
    
    @IBAction func onSendTapped(_ sender: Any) {
        var comment = Comment()
        comment.user = User.current
        comment.comment = commentTextField.text
        
        comment.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let comment):
                    print("✅ Comment Saved! \(comment)")

                    // Return to previous view controller
                    self?.queryComments()
//                    self?.tableView.reloadData()

                case .failure(let error):
                    print(error)
                }
            }
        }
        commentTextField.text = ""

    }
    
    private func queryComments() {
        let query = Comment.query()
            .include("user")
            .order([.descending("createdAt")])

        // Fetch objects (posts) defined in query (async)
        query.find { [weak self] result in
            switch result {
            case .success(let comments):
                // Update local posts property with fetched posts
                self?.comments = comments
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}

extension CommentViewController: UITableViewDelegate { }

