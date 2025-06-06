//
//  PageTabViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 26/02/2025.
//

import UIKit

class PageTabViewController: UIPageViewController {

    var pages: [UIViewController] = []
    var movie: Movie?
    private var indexCurrentPage = -1
    private var heightTabs: [CGFloat] = [0, 0, 0]

    weak var heightContentViewDelegate: HeightContentViewDelegate?
    var handleSwipePage: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupView()
        selectTab(index: 0)
    }

    func setupView() {
        let pageAboutMovie = TabAboutMovieViewController(nibName: "TabAboutMovieViewController", bundle: nil)
        pageAboutMovie.pageTabViewDelegate = self
        let padding: CGFloat = 29
        pageAboutMovie.setupData(aboutMovie: movie?.overview, width: view.bounds.width - (CGFloat(2) * padding))

        let pageReviews = TabReviewsViewController(nibName: "TabReviewsViewController", bundle: nil)
        pageReviews.pageTabViewDelegate = self
        pageReviews.setupData(id: movie?.id)

        let pageCast = TabCastViewController(nibName: "TabCastViewController", bundle: nil)
        pageCast.pageTabViewDelegate = self
        pageCast.setupData(id: movie?.id)

        pages = [pageAboutMovie, pageReviews, pageCast]
    }

    func selectTab(index: Int) {
        if indexCurrentPage == index {
            return
        }
        setViewControllers([pages[index]], direction: index > indexCurrentPage ? .forward : .reverse, animated: false)
        indexCurrentPage = index
        heightContentViewDelegate?.heightContent(index: indexCurrentPage, height: heightTabs[index])
    }
}

extension PageTabViewController: PageTabViewDelegate {
    func heightContent(index: Int, height: CGFloat) {
        heightTabs[index] = height
        heightContentViewDelegate?.heightContent(index: index, height: height)
    }

    func showLoading() {
        heightContentViewDelegate?.showLoading()
    }

    func hideLoading() {
        heightContentViewDelegate?.hideLoading()
    }
}

extension PageTabViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = currentIndex - 1
        return pages[safe: previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = currentIndex + 1
        return pages[safe: nextIndex]
    }
}

extension PageTabViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = pages.firstIndex(of: currentVC)
        else { return }

        indexCurrentPage = index
        handleSwipePage?(index)
        heightContentViewDelegate?.heightContent(index: indexCurrentPage, height: heightTabs[index])
    }
}
