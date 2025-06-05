//
//  TabReviewsViewController.swift
//  Movies-App
//
//  Created by Lê Tiến Đạt on 24/2/25.
//

import UIKit

class TabReviewsViewController: UIViewController {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private lazy var tabReviewsPresenter = TabReviewsPresenter(tabReviewViewDelegate: self)
    weak var pageTabViewDelegate: PageTabViewDelegate?
    private var width: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        self.tabReviewsPresenter.computeHeightContent(
            tableView: tableView,
            label: descriptionLabel,
            width: width
        )
    }

    func setupView() {
        tableView.register(ReviewTabTableViewCell.nib, forCellReuseIdentifier: ReviewTabTableViewCell.reuseIdentifier)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupData(id: Int?) {
        tabReviewsPresenter.id = id
    }

    func fetchData() {
        tabReviewsPresenter.fetchReviewsMovie()
    }
}

extension TabReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tabReviewsPresenter.listReviews?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTabTableViewCell.reuseIdentifier, for: indexPath) as! ReviewTabTableViewCell

        let review = tabReviewsPresenter.listReviews?[indexPath.item]
        cell.setupData(review: review)

        return cell
    }
}

extension TabReviewsViewController: TabReviewsViewDelegate {
    func heightContent(height: CGFloat) {
        pageTabViewDelegate?.heightContent(index: 1, height: height)
    }

    func showReviews() {
        guard let listReviews = tabReviewsPresenter.listReviews,
              !listReviews.isEmpty
        else {
            self.descriptionLabel.text = "There are no comments for this movie."
            self.descriptionLabel.isHidden = false
            self.tableView.isHidden = true
            return
        }
        self.tableView.reloadData()
        self.tableView.isHidden = false
        self.descriptionLabel.isHidden = true
        self.view.setNeedsLayout()
    }

    func fetchError(_ msgErr: String) {
        descriptionLabel.text = msgErr
        tableView.isHidden = true
        descriptionLabel.isHidden = false
    }
}
