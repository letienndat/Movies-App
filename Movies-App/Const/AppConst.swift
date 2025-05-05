//
//  AppConst.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import Foundation
import UIKit

struct AppConst {
    public static let baseURLTheMovieDB = "https://api.themoviedb.org/3"
    public static let endPointGetTopRated = "/movie/top_rated"
    public static let endPointGetNowPlaying = "/movie/now_playing"
    public static let endPointGetTrending = "/trending/movie/day"
    public static let endPointGetUpcoming = "/movie/upcoming"
    public static let endPointGetPopular = "/movie/popular"
    public static let endPointSearch = "/search/movie"
    public static let endPointMovieDetails = "/movie/{movie_id}"
    public static let endPointReviewsMovie = "/movie/{movie_id}/reviews"
    public static let endPointCreditsMovie = "/movie/{movie_id}/credits"
    public static let endPointUpdateMovieInWatchlist = "/account/21799740/watchlist"
    public static let endPointWatchlist = "/account/21799740/watchlist/movies"
    public static let endPointGetListVideos = "/movie/{movie_id}/videos"

    public static let baseURLTMDBImage = "https://image.tmdb.org/t/p/w500"

    public static let urlEmbedVideoYouTube = "https://www.youtube.com/embed/{video_id}"

    public static let colorRefreshControl = UIColor(hex: 0xFFFFFF)
    public static let colorViewTabSelected = UIColor(hex: 0x3A3F47)

    public static let numberItemOfPage = 20
}
