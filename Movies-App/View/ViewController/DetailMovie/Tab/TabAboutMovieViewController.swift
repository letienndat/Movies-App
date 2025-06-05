//
//  TabAboutMovieViewController.swift
//  Movies-App
//
//  Created by Lê Tiến Đạt on 24/2/25.
//

import UIKit

class TabAboutMovieViewController: UIViewController {
    @IBOutlet private weak var labelAboutMovie: UILabel!

    private var aboutMovie: String?
    private var width: CGFloat = 0

    private lazy var tabAboutMoviePresenter = TabAboutMoviePresenter(tabAboutMovieViewDelegate: self)
    weak var pageTabViewDelegate: PageTabViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        labelAboutMovie.text = aboutMovie
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabAboutMoviePresenter.computeHeightContent(view: labelAboutMovie, width: width)
    }

    func setupData(aboutMovie: String?, width: CGFloat) {
        let about = aboutMovie ?? ""
        self.aboutMovie = about.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                            "There is no description for this movie." : about
        self.width = width
    }
}

extension TabAboutMovieViewController: TabAboutMovieViewDelegate {
    func heightContent(height: CGFloat) {
        pageTabViewDelegate?.heightContent(index: 0, height: height)
    }
}
