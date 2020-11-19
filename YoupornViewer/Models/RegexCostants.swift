//
//  RegexCostants.swift
//  YoupornViewer
//
//  Created by Fabrizio Chimienti on 19/11/2020.
//  Copyright © 2020 fabrizio chimienti. All rights reserved.
//

struct RegexConst {
    static let titlestempRegex =  "<div.*class\\s*=\\s*[\"\'].*video-box-title.*[\"\']\\s*>(\\s.*?)+</div>"
    static let regexes = "<div data-espnode=\"videobox\"\\s*class\\s*=\\s*[\"\'].*video-box four-column video_block_wrapper.*[\"\'](.|\n|\r)*?<a href=[\"\']/watch/(.|\n|\r)*?class=[\"\']video-box-image[\"\'](.|\n|\r)*?</a>"
    static let titleRegex = ">[\\s](.|\n|\r)*?[\\s]?<"
    static let imageRegex = "data-thumbnail=[\"\'](.|\n|\r)*?[\"\']"
    static let videoLinkRegex = "href=[\"\'](.|\n|\r)*?[\"\']"
}
