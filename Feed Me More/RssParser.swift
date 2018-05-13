//
//  RssParser.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

struct Item {
    var title: String = ""
    var description: String = ""
    // TODO: Use formatter to parse data
    var pubDate: String = ""
}

protocol RssParser {
    func parse(data: Data) -> [Item]
}

class StandardRssParser: NSObject, RssParser, XMLParserDelegate {
    enum Elem: String {
        case title
        case description
        case pubDate
        case none
    }
    
    struct State {
        var inItem: Bool = false
        var element: Elem = .none
        
        var curItem: Item = Item()
        var items: [Item] = []
    }
    
    struct ItemNames {
        static let item = "item"
        static let title = "title"
        static let description = "description"
        static let pubDate = "pubDate"
    }
    
    private var internalParser: XMLParser?
    private var state: State
    
    override init() {
        internalParser = nil
        state = State()
    }
    
    func parse(data: Data) -> [Item] {
        internalParser = XMLParser(data: data)
        self.state = State()
        
        internalParser?.delegate = self
        internalParser?.parse()
        return state.items
    }
    
    // MARK: - XMLParserDelegate
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        
        #if DEBUG
        // FIXME: DEBUG stuff
        if state.items.count > 10 {
            parser.abortParsing()
            return
        }
        #endif
        
        switch elementName {
        case ItemNames.item:
            state.inItem = true
            state.curItem = Item()
        case ItemNames.title, ItemNames.description, ItemNames.pubDate:
            if state.inItem {
                state.element = Elem(rawValue: elementName)!
            }
        default:
            // skip unknown tags
            return
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case ItemNames.item:
            state.inItem = false
            state.items.append(state.curItem)
        case ItemNames.title, ItemNames.description, ItemNames.pubDate:
            state.element = .none
        default:
            // skip unknown tags
            return
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if state.inItem {
            switch state.element {
            case .title:
                state.curItem.title += string
            case .pubDate:
                state.curItem.pubDate += string
            default:
                // skip unrelated text
                return
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        if state.inItem {
            // CDATA is standard way to store description in feeds
            if state.element == .description {
                state.curItem.description = String(data: CDATABlock, encoding: .utf8) ?? ""
            }
        }
    }
}
