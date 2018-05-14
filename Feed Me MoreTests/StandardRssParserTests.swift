//
//  StandardRssParserTests.swift
//  Feed Me MoreTests
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import XCTest
@testable import Feed_Me_More

class StandardRssParserTests: XCTestCase {
    
    var _feed: Data! = nil
    
    var itemResults: [[String: String]] = [
        [
            "title": "Российские тхэквондисты стали первыми в Европе",
            "description": "Сборная России по тхэквондо заняла первое место в медальном зачете на первенстве Европы, который завершился в Казани. Всего в активе национальной команды 15 медалей, четыре из них — золотые. Также россияне выиграли пять серебряных медалей и шесть бронзовых. Чемпионат Европы прошел с 10 по 13 мая.",
            "pubDate": "Sun, 13 May 2018 23:20:21 +0300"
        ],
        [
            "title": "Умер Баадур Цуладзе",
            "description": "Грузинский актер и режиссер Баадур Цуладзе умер в возрасте 83 лет. Заслуженный артист Грузии ушел из жизни в Тбилиси после продолжительной болезни. Он исполнил более 90 ролей в кино, широкую известность ему принесла роль трактирщика в «Приключениях Буратино». Также он срежиссировал десять собственных картин.<br />",
            "pubDate": "Sun, 13 May 2018 23:06:39 +0300"
        ],
        [
            "title": "Telegram обжаловал решение суда о блокировке",
            "description": "Юристы Telegram подали апелляционную жалобу на решение суда о блокировке мессенджера. По мнению адвокатов, Роскомнадзор вышел за рамки своих полномочий, обратившись в суд, а суд нарушил процессуальный порядок, не возбудив гражданское дело, а рассмотрев иск в особом порядке.",
            "pubDate": "Sun, 13 May 2018 22:34:00 +0300"
        ]
    ]
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        guard let feedUrl = bundle.url(forResource: "TestFeed1", withExtension: "xml"),
            let feed = try? Data(contentsOf: feedUrl) else {
            fatalError("Could not load critical resource for tests")
        }
        _feed = feed
    }
    
    func testParse() {
        let parser = StandardRssParser()
        let items = parser.parse(data: _feed)
        AssertEquality(items.count, 3)
        
        let dateFormatter = RFC822DateFormatter()
        
        for i in 0..<items.count {
            AssertEquality(items[i].title, itemResults[i]["title"])
            AssertEquality(items[i].description, itemResults[i]["description"])
            let date = dateFormatter.date(from: itemResults[i]["pubDate"] ?? "")
            AssertEquality(items[i].pubDate, date)
        }
    }
}

func AssertEquality<T: Equatable>(_ lhs: T, _ rhs: T, file: StaticString = #file, line: UInt = #line) {
    XCTAssert(lhs == rhs, "\(lhs) != \(rhs)", file: file, line: line)
}
