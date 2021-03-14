//
//  MockTwitterAPIResponseData.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation

struct MockTwitterAPIResponseData {
    static var oauth2Token: String {
       """
       {
         "token_type":"bearer",
         "access_token":"token"
       }
       """
    }

    static var search: String {
        """
        {
          "statuses": [
            {
              "created_at": "Thu Mar 11 12:46:53 +0000 2021",
              "id": 1369993228452196400,
              "id_str": "1369993228452196358",
              "text": "tweet text!!",
              "truncated": false,
              "metadata": {
                "iso_language_code": "ja",
                "result_type": "recent"
              },
              "source": "<a href=\'http://twitter.com/download/iphone\' rel=\'nofollow\'>Twitter for iPhone</a>",
              "in_reply_to_status_id": 1369961044064411600,
              "in_reply_to_status_id_str": "1369961044064411648",
              "in_reply_to_user_id": 177657078,
              "in_reply_to_user_id_str": "177657078",
              "in_reply_to_screen_name": "kanufy",
              "user": {
                "id": 2433307896,
                "id_str": "2433307896",
                "name": "NK5",
                "screen_name": "nkws_5",
                "location": "",
                "description": "中川慶悟 iOS Android Javascript SDK FF ダウンタウン VG → SHOWROOM",
                "url": "https://t.co/xqNuTbslYr",
                "entities": {
                  "url": {
                    "urls": [
                      {
                        "url": "https://t.co/xqNuTbslYr",
                        "expanded_url": "https://plum-plus.jp/",
                        "display_url": "plum-plus.jp",
                        "indices": [
                          0,
                          23
                        ]
                      }
                    ]
                  },
                  "description": {
                    "urls": []
                  }
                },
                "protected": false,
                "followers_count": 128,
                "friends_count": 534,
                "listed_count": 1,
                "created_at": "Tue Apr 08 08:56:36 +0000 2014",
                "favourites_count": 2208,
                "utc_offset": null,
                "time_zone": null,
                "geo_enabled": false,
                "verified": false,
                "statuses_count": 1926,
                "lang": null,
                "contributors_enabled": false,
                "is_translator": false,
                "is_translation_enabled": false,
                "profile_background_color": "000000",
                "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
                "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
                "profile_background_tile": false,
                "profile_image_url": "http://pbs.twimg.com/profile_images/1190985555644952576/cDurbyzD_normal.jpg",
                "profile_image_url_https": "https://pbs.twimg.com/profile_images/1190985555644952576/cDurbyzD_normal.jpg",
                "profile_banner_url": "https://pbs.twimg.com/profile_banners/2433307896/1611214785",
                "profile_link_color": "6279AC",
                "profile_sidebar_border_color": "000000",
                "profile_sidebar_fill_color": "000000",
                "profile_text_color": "000000",
                "profile_use_background_image": false,
                "has_extended_profile": false,
                "default_profile": false,
                "default_profile_image": false,
                "following": null,
                "follow_request_sent": null,
                "notifications": null,
                "translator_type": "none"
              },
              "geo": null,
              "coordinates": null,
              "place": null,
              "contributors": null,
              "is_quote_status": false,
              "retweet_count": 0,
              "favorite_count": 0,
              "favorited": false,
              "retweeted": false,
              "lang": "ja"
            },
            {
               "created_at": "Thu Mar 11 12:46:53 +0000 2021",
               "id": 1369993228452196400,
               "id_str": "1369993228452196358",
               "text": "お寿司が食べたい🍣",
               "truncated": false,
               "metadata": {
                 "iso_language_code": "ja",
                 "result_type": "recent"
               },
               "source": "<a href=\'http://twitter.com/download/iphone\' rel=\'nofollow\'>Twitter for iPhone</a>",
               "in_reply_to_status_id": 1369961044064411600,
               "in_reply_to_status_id_str": "1369961044064411648",
               "in_reply_to_user_id": 177657078,
               "in_reply_to_user_id_str": "177657078",
               "in_reply_to_screen_name": "kanufy",
               "user": {
                 "id": 2433307896,
                 "id_str": "2433307896",
                 "name": "NK5",
                 "screen_name": "nkws_5",
                 "location": "",
                 "description": "中川慶悟 iOS Android Javascript SDK FF ダウンタウン VG → SHOWROOM",
                 "url": "https://t.co/xqNuTbslYr",
                 "entities": {
                   "url": {
                     "urls": [
                       {
                         "url": "https://t.co/xqNuTbslYr",
                         "expanded_url": "https://plum-plus.jp/",
                         "display_url": "plum-plus.jp",
                         "indices": [
                           0,
                           23
                         ]
                       }
                     ]
                   },
                   "description": {
                     "urls": []
                   }
                 },
                 "protected": false,
                 "followers_count": 128,
                 "friends_count": 534,
                 "listed_count": 1,
                 "created_at": "Tue Apr 08 08:56:36 +0000 2014",
                 "favourites_count": 2208,
                 "utc_offset": null,
                 "time_zone": null,
                 "geo_enabled": false,
                 "verified": false,
                 "statuses_count": 1926,
                 "lang": null,
                 "contributors_enabled": false,
                 "is_translator": false,
                 "is_translation_enabled": false,
                 "profile_background_color": "000000",
                 "profile_background_image_url": "http://abs.twimg.com/images/themes/theme1/bg.png",
                 "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme1/bg.png",
                 "profile_background_tile": false,
                 "profile_image_url": "http://pbs.twimg.com/profile_images/1190985555644952576/cDurbyzD_normal.jpg",
                 "profile_image_url_https": "https://pbs.twimg.com/profile_images/1190985555644952576/cDurbyzD_normal.jpg",
                 "profile_banner_url": "https://pbs.twimg.com/profile_banners/2433307896/1611214785",
                 "profile_link_color": "6279AC",
                 "profile_sidebar_border_color": "000000",
                 "profile_sidebar_fill_color": "000000",
                 "profile_text_color": "000000",
                 "profile_use_background_image": false,
                 "has_extended_profile": false,
                 "default_profile": false,
                 "default_profile_image": false,
                 "following": null,
                 "follow_request_sent": null,
                 "notifications": null,
                 "translator_type": "none"
               },
               "geo": null,
               "coordinates": null,
               "place": null,
               "contributors": null,
               "is_quote_status": false,
               "retweet_count": 0,
               "favorite_count": 0,
               "favorited": false,
               "retweeted": false,
               "lang": "ja"
             }
          ],
          "search_metadata": {
            "completed_in": 0.019,
            "max_id": 1369993228452196400,
            "max_id_str": "1369993228452196358",
            "next_results": "?max_id=1369993228452196357&q=nkws_5&count=1",
            "query": "nkws_5",
            "refresh_url": "?since_id=1369993228452196358&q=nkws_5",
            "count": 1,
            "since_id": 0,
            "since_id_str": "0"
          }
        }
        """
}
}
