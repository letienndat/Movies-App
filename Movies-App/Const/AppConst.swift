//
//  AppConst.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import Foundation
import UIKit

struct AppConst {
    public static var apiKeyTheMovieDB: String {
        XCConfig.apiKeyTheMovieDB.value
    }
    public static var sessionID: String {
        XCConfig.sessionID.value
    }
    public static var baseURLTheMovieDB: String {
        XCConfig.baseURLTheMovieDB.value
    }
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
    public static let endPointRecommendations = "/discover/movie"

    public static var baseURLTMDBImage: String {
        XCConfig.baseURLTMDBImage.value
    }
    public static var urlEmbedVideoYouTube: String {
        XCConfig.urlEmbedVideoYouTube.value
    }
    public static var baseURLServerTracking: String {
        XCConfig.baseURLServerTracking.value
    }
    public static var pathPlistAcknowledgements: String {
        Bundle.main.object(forInfoDictionaryKey: "ACKNOWLEDGEMENT_PLIST") as! String
    }

    public static let colorRefreshControl = UIColor(hex: 0xFFFFFF)
    public static let colorViewTabSelected = UIColor(hex: 0x3A3F47)

    public static let numberItemOfPage = 20

    enum TrackingEvent {
        case tapDetailMovie
        case watchMovie
        case addToWatchList
        case removeFromWatchList
        case tapTabAboutMovie
        case tapTabReviewsMovie
        case tapTabCastMovie

        var parameter: String {
            switch self {
            case .tapDetailMovie: "tap_detail_movie"
            case .watchMovie: "watch_movie"
            case .addToWatchList: "add_to_watchlist"
            case .removeFromWatchList: "remove_from_watchlist"
            case .tapTabAboutMovie: "tap_tab_about_movie"
            case .tapTabReviewsMovie: "tap_tab_reviews_movie"
            case .tapTabCastMovie: "tap_tab_cast_movie"
            }
        }
    }

    enum TrackingEndpoint {
        case tracking
        case recommendations

        var endpoint: String {
            switch self {
            case .tracking: "/track"
            case .recommendations: "/:email/recommendations"
            }
        }
    }
}

enum XCConfig {
    case apiKeyTheMovieDB
    case sessionID
    case baseURLTheMovieDB
    case baseURLTMDBImage
    case urlEmbedVideoYouTube
    case baseURLServerTracking

    var key: String {
        switch self {
        case .apiKeyTheMovieDB: "API_KEY_THEMOVIEDB"
        case .sessionID: "SESSION_ID"
        case .baseURLTheMovieDB: "BASE_URL_THE_MOVIE_DB"
        case .baseURLTMDBImage: "BASE_URL_TMDB_IMAGE"
        case .urlEmbedVideoYouTube: "URL_EMBED_VIDEO_YOUTUBE"
        case .baseURLServerTracking: "BASE_URL_SERVER_TRACKING"
        }
    }
}

extension XCConfig {
    var value: String {
        getValueFromPlist(key: self)
    }

    private func getValueFromPlist(key: XCConfig) -> String {
        Bundle.main.object(forInfoDictionaryKey: key.key) as! String
    }
}
